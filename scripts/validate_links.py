#!/usr/bin/env python3
"""
link 命名与方向规范校验器。

依据《link 命名与方向规范》(docs/link命名与方向规范.md) 校验 linkType。
支持两套规则集：
  --ruleset current  现状规则（谓词=category 名，白名单=现有 20 类），用于发现基线问题
  --ruleset target   目标规范（9 类 + 谓词词表 + predicate/anchorSide 字段），用于校验迁移后数据

用法：
  python3 scripts/validate_links.py --ruleset current
  python3 scripts/validate_links.py --ruleset target --input data/ontology/xxx_normalized.json
"""
import argparse
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

DEFAULT_INPUT = "data/ontology/semiconductor_ontology_before_v3_merge.json"

# ── 现状白名单（20 类，迁移前的真实 category 集合）──
CURRENT_CATEGORIES = {
    "上游投入", "统计对象", "下游应用", "生产供给", "能力支撑", "报价对象",
    "先后衔接", "采用", "对应", "依赖", "配套协同", "支持", "物料组成",
    "实现", "替代关系", "遵循", "提供", "符合", "集成", "量产", "协同",
}

# ── 目标白名单（9 类）──
TARGET_CATEGORIES = {
    "上游投入", "生产供给", "能力支撑", "下游应用", "先后衔接", "替代关系",
    "技术关联", "技术协同", "报价对象", "统计对象",
}

# ── 目标谓词词表（category → predicate；技术关联按 link 自带 predicate 字段细分）──
TARGET_PREDICATE = {
    "上游投入": "供给于",
    "生产供给": "生产供给",
    "能力支撑": "能力支撑",
    "下游应用": "下游应用",
    "先后衔接": "先后衔接",
    "报价对象": "报价对象",
    "统计对象": "统计对象",
    "替代关系": "替代",
    # 技术关联：predicate 取自 link 自身 lt["predicate"]（采用/对应/遵循）
}
TECH_CATEGORY = "技术关联"
TECH_PREDICATES = {"采用", "对应", "遵循", "依赖", "支持", "提供"}
TECH_SYNERGY_CATEGORY = "技术协同"
TECH_SYNERGY_PREDICATES = {"协同", "替代", "对应", "适配", "依赖"}

REQUIRED_FIELDS = ("name", "sourceObjectType", "targetObjectType", "linkTypeCategory")


def load(path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def resolve_predicate(lt, ruleset):
    """返回该 link 在当前规则集下应当使用的谓词；None 表示无法确定。"""
    cat = lt.get("linkTypeCategory")
    if ruleset == "current":
        return cat  # 现状：谓词 == category 名
    # target：技术关联按 link 自带 predicate 字段，其余查词表
    if cat in (TECH_CATEGORY, TECH_SYNERGY_CATEGORY):
        return lt.get("predicate")
    return TARGET_PREDICATE.get(cat)


def validate(data, ruleset):
    ot_names = {ot.get("nameCn") for ot in data.get("objectType", [])}
    whitelist = CURRENT_CATEGORIES if ruleset == "current" else TARGET_CATEGORIES
    links = data.get("linkType", [])

    issues = defaultdict(list)
    cat_counter = Counter()

    for i, lt in enumerate(links):
        ctx = f"#{i} name={lt.get('name')!r}"
        # 1. 必填字段
        for fld in REQUIRED_FIELDS:
            if not lt.get(fld):
                issues["缺必填字段"].append(f"{ctx} 缺 {fld}")

        cat = lt.get("linkTypeCategory")
        cat_counter[cat] += 1
        # 2. category 白名单
        if cat not in whitelist:
            issues["category 不在白名单"].append(f"{ctx} category={cat!r}")

        src = lt.get("sourceObjectType", "")
        tgt = lt.get("targetObjectType", "")
        name = lt.get("name", "")
        # 3. OT 存在性
        if src and src not in ot_names:
            issues["source OT 不存在"].append(f"{ctx} source={src!r}")
        if tgt and tgt not in ot_names:
            issues["target OT 不存在"].append(f"{ctx} target={tgt!r}")

        # 4. name 拼接一致性
        pred = resolve_predicate(lt, ruleset)
        if pred is None:
            if ruleset == "target":
                issues["谓词缺失/非法"].append(f"{ctx} category={cat!r} 未提供 predicate")
        else:
            expected = f"{src}{pred}{tgt}"
            if name != expected:
                issues["name 拼接不一致"].append(
                    f"{ctx}\n      期望={expected!r}\n      实际={name!r}"
                )

        # 5. target 专属：predicate 字段
        if ruleset == "target":
            if "predicate" not in lt:
                issues["缺 predicate 字段"].append(ctx)
            elif cat == TECH_CATEGORY and lt.get("predicate") not in TECH_PREDICATES:
                issues["技术关联谓词非法"].append(f"{ctx} predicate={lt.get('predicate')!r}")
            elif cat == TECH_SYNERGY_CATEGORY and lt.get("predicate") not in TECH_SYNERGY_PREDICATES:
                issues["技术协同谓词非法"].append(f"{ctx} predicate={lt.get('predicate')!r}")

    return issues, cat_counter, len(links)


def main():
    ap = argparse.ArgumentParser(description="link 命名与方向规范校验器")
    ap.add_argument("--input", default=DEFAULT_INPUT, help="本体 JSON 路径")
    ap.add_argument("--ruleset", choices=("current", "target"), default="current",
                    help="current=现状规则(发现基线问题)；target=目标规范(校验迁移后)")
    ap.add_argument("--max", type=int, default=15, help="每类问题最多打印明细条数")
    args = ap.parse_args()

    path = Path(args.input)
    if not path.exists():
        sys.exit(f"❌ 文件不存在: {path}")

    data = load(path)
    issues, cat_counter, total = validate(data, args.ruleset)
    whitelist = CURRENT_CATEGORIES if args.ruleset == "current" else TARGET_CATEGORIES

    print(f"=== link 规范校验（ruleset={args.ruleset}）===")
    print(f"文件: {path}")
    print(f"linkType 总数: {total}")
    print(f"\n--- category 分布 ---")
    for cat, n in cat_counter.most_common():
        flag = "" if cat in whitelist else "  ⚠️ 非白名单"
        print(f"  {n:>4}  {cat}{flag}")

    if not issues:
        print("\n✅ 0 违规，完全符合规范。")
        return

    total_issues = sum(len(v) for v in issues.values())
    print(f"\n--- 违规明细（共 {total_issues} 条，{len(issues)} 类）---")
    for kind, items in sorted(issues.items(), key=lambda kv: -len(kv[1])):
        print(f"\n[{kind}]  {len(items)} 条")
        for line in items[: args.max]:
            print(f"  - {line}")
        if len(items) > args.max:
            print(f"  ... 还有 {len(items) - args.max} 条")

    print(f"\n❌ 发现 {total_issues} 处违规，请修复后重跑。")
    sys.exit(1)


if __name__ == "__main__":
    main()
