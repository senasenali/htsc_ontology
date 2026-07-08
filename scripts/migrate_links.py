#!/usr/bin/env python3
"""
link 规范迁移器（before_v3 一次性整改）。

依据《link 命名与方向规范》(docs/link命名与方向规范.md) 迁移 linkType：
  常规归并（附录 B.2-B.4）：
    1. category 归并（21 → 10）
    2. 上游投入/物料组成：端点反转（产品→材料 改为 材料→产品），谓词改「供给于」
    3. 技术关联：谓词按原 category 细分（采用/对应/遵循）
    4. name 重算；补 predicate 字段
  B.7 技术层重分类（附录 B.7）：
    5. 价值链类中涉及技术层 OT 的 link，迁入技术关联/技术协同（层次分离）

description 保留原业务含义，不追加数据血缘（血缘由 git 承载）。
默认 dry-run。加 --write 写出 *_normalized.json（不覆盖原件）。

用法：
  python3 scripts/migrate_links.py                 # dry-run，看 diff（含 B.7 明细）
  python3 scripts/migrate_links.py --write         # 写出 normalized 文件
"""
import argparse
import copy
import json
from collections import Counter
from pathlib import Path

DEFAULT_INPUT = "data/ontology/semiconductor_ontology_before_v3_merge.json"

# ── 归并映射：原 category → 新 category ──
CATEGORY_MERGE = {
    "上游投入": "上游投入", "物料组成": "上游投入",
    "生产供给": "生产供给",
    "能力支撑": "能力支撑", "依赖": "能力支撑", "支持": "能力支撑",
    "提供": "能力支撑", "协同": "能力支撑", "配套协同": "能力支撑",
    "下游应用": "下游应用",
    "先后衔接": "先后衔接",
    "采用": "技术关联", "对应": "技术关联", "实现": "技术关联",
    "集成": "技术关联", "量产": "技术关联", "遵循": "技术关联", "符合": "技术关联",
    "报价对象": "报价对象",
    "统计对象": "统计对象",
    "替代关系": "替代关系",
}

# ── 技术关联（常规归并部分）：原 category → 谓词 ──
TECH_PREDICATE = {
    "采用": "采用", "对应": "对应", "实现": "采用",
    "集成": "采用", "量产": "采用", "遵循": "遵循", "符合": "遵循",
}

# ── 新 category → 默认谓词（技术关联除外，走 TECH_PREDICATE）──
PREDICATE = {
    "上游投入": "供给于",
    "生产供给": "生产供给",
    "能力支撑": "能力支撑",
    "下游应用": "下游应用",
    "先后衔接": "先后衔接",
    "报价对象": "报价对象",
    "统计对象": "统计对象",
    "替代关系": "替代",
}

REVERSE_CATEGORIES = {"上游投入", "物料组成"}
VALUE_CHAIN_CATEGORIES = {"上游投入", "生产供给", "能力支撑", "下游应用"}

# B.7 用户人工裁定：(source, target) → (谓词, 是否反转端点)。谓词/方向按工业技术逻辑定。
B7_OVERRIDE = {
    ("先进封装技术", "HBM世代"): ("适配", False),
    ("封装基板技术", "先进封装技术"): ("依赖", True),   # 反转：先进封装技术 依赖 封装基板技术
    ("光刻机", "制程节点世代"): ("支持", False),
    ("倒装键合机", "先进封装技术"): ("支持", False),
    ("混合键合机", "先进封装技术"): ("支持", False),
    ("晶圆代工", "制造工艺"): ("提供", False),
    ("IDM", "制造工艺"): ("提供", False),
    ("晶圆代工", "特色工艺平台"): ("提供", False),
}


def build_ot_index(data):
    """返回 (tech_set, product_set)。tech_set=技术路线树下 OT；product_set=产品与器件树下 OT。"""
    name2ot = {o["nameCn"]: o for o in data.get("objectType", [])}

    def ancestors(name):
        chain, cur, seen = [], name, set()
        while cur and cur not in seen:
            seen.add(cur)
            chain.append(cur)
            o = name2ot.get(cur)
            cur = o.get("parentObjectTypeName") if o else None
        return chain

    tech_set = {n for n in name2ot if any(a == "技术路线" for a in ancestors(n))}
    product_set = {n for n in name2ot if any(a == "产品与器件" for a in ancestors(n))}
    return tech_set, product_set


def migrate_link(lt):
    """常规归并（B.2-B.4）。返回 (新 link, 日志)。"""
    log = []
    src_cat = lt.get("linkTypeCategory")
    new = copy.deepcopy(lt)
    orig_name = lt.get("name", "")

    # 1. 归并 category
    new_cat = CATEGORY_MERGE.get(src_cat, src_cat)
    if new_cat != src_cat:
        log.append(f"category: {src_cat} → {new_cat}")
    new["linkTypeCategory"] = new_cat

    # 2. 端点反转（上游投入/物料组成，顺物质流：产品→材料 改为 材料→产品）
    if src_cat in REVERSE_CATEGORIES:
        orig_src = lt.get("sourceObjectType", "")
        orig_tgt = lt.get("targetObjectType", "")
        new["sourceObjectType"], new["targetObjectType"] = orig_tgt, orig_src
        log.append(f"反转端点: {orig_src}→{orig_tgt}  ⇒  {orig_tgt}→{orig_src}")

    # 3. 谓词
    if new_cat == "技术关联":
        pred = TECH_PREDICATE.get(src_cat, "采用")
    else:
        pred = PREDICATE.get(new_cat, new_cat)
    new["predicate"] = pred

    # 4. name 重算
    new_name = f"{new['sourceObjectType']}{pred}{new['targetObjectType']}"
    if new_name != orig_name:
        log.append(f"name: {orig_name} → {new_name}")
    new["name"] = new_name
    return new, log


def reclassify_tech(lt, tech_set, product_set):
    """B.7：价值链类中涉及技术层 OT 的 link 迁入技术类（层次分离）。返回 (link, 日志)。

    谓词默认推断（可在 diff 中人工复核调整）：
      技术↔技术        → 技术协同，谓词「协同」
      技术→材料/器件   → 技术关联，谓词「依赖」
      产品→技术        → 技术关联，谓词「采用」
      设备/服务→技术   → 技术关联，谓词「对应」
    """
    cat = lt.get("linkTypeCategory")
    if cat not in VALUE_CHAIN_CATEGORIES:
        return lt, []
    src = lt.get("sourceObjectType", "")
    tgt = lt.get("targetObjectType", "")
    src_tech, tgt_tech = src in tech_set, tgt in tech_set
    if not (src_tech or tgt_tech):
        return lt, []

    log = []
    old_name = lt["name"]
    if src_tech and tgt_tech:
        lt["linkTypeCategory"] = "技术协同"
        lt["predicate"] = "协同"
    elif src_tech:                       # 技术 → 外界（材料/器件）
        lt["linkTypeCategory"] = "技术关联"
        lt["predicate"] = "依赖"
    else:                                # 外界 → 技术
        lt["linkTypeCategory"] = "技术关联"
        lt["predicate"] = "采用" if src in product_set else "对应"

    # 用户人工裁定覆盖（谓词/方向按工业逻辑，见 B7_OVERRIDE）
    ov = B7_OVERRIDE.get((src, tgt))
    if ov:
        pred, reverse = ov
        lt["predicate"] = pred
        if reverse:
            lt["sourceObjectType"], lt["targetObjectType"] = tgt, src
            src, tgt = tgt, src

    lt["name"] = f"{src}{lt['predicate']}{tgt}"
    tag = " [人工裁定]" if ov else ""
    log.append(f"B.7: {old_name} → {lt['name']}  ({cat}→{lt['linkTypeCategory']}, 谓词={lt['predicate']}){tag}")
    return lt, log


def main():
    ap = argparse.ArgumentParser(description="link 规范迁移器（before_v3 整改）")
    ap.add_argument("--input", default=DEFAULT_INPUT)
    ap.add_argument("--write", action="store_true", help="写出 *_normalized.json（默认仅 dry-run）")
    args = ap.parse_args()

    path = Path(args.input)
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    tech_set, product_set = build_ot_index(data)
    links = data.get("linkType", [])

    final_links, b7_logs = [], []
    merge_counter, name_change_counter = Counter(), 0
    for lt in links:
        merged, _ = migrate_link(lt)
        recl, b7log = reclassify_tech(merged, tech_set, product_set)
        final_links.append(recl)
        if b7log:
            b7_logs.extend(b7log)
        merge_counter[f"{lt.get('linkTypeCategory')} → {recl.get('linkTypeCategory')}"] += 1
        if recl["name"] != lt.get("name", ""):
            name_change_counter += 1

    print("=== link 规范迁移 dry-run（归并 + 反转 + B.7 技术层重分类）===")
    print(f"输入: {path}   linkType 总数: {len(links)}")

    print(f"\n--- B.7 技术层重分类明细（{len(b7_logs)} 条，谓词为推断默认，请人工复核）---")
    for line in b7_logs:
        print(f"  {line}")

    print(f"\n--- 迁移后 category 分布 ---")
    for k, n in Counter(lt["linkTypeCategory"] for lt in final_links).most_common():
        print(f"  {n:>4}  {k}")
    print(f"\n--- 迁移后 predicate 分布 ---")
    for k, n in Counter(lt["predicate"] for lt in final_links).most_common():
        print(f"  {n:>4}  {k}")

    bad = [lt for lt in final_links
           if lt["name"] != f"{lt['sourceObjectType']}{lt['predicate']}{lt['targetObjectType']}"]
    print(f"\n--- 自检 ---\n  name 拼接不自洽: {len(bad)} 条" + (" ✅" if not bad else " ❌"))

    if not args.write:
        print("\n（dry-run，未写文件。加 --write 写出 *_normalized.json）")
        return

    data["linkType"] = final_links
    out = path.with_name(path.stem + "_normalized.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"\n✅ 已写出: {out}")


if __name__ == "__main__":
    main()
