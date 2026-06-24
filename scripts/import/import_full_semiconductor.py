#!/usr/bin/env python3
"""
批量导入 semiconductor_ontology.json 到半导体项目。
执行流程:
  1. 重命名现有 dram → DRAM代际 (name仅展示层)
  2. 按拓扑序导入 177 个对象类型
  3. 导入 1845 条关系类型
  4. 保存布局位置
"""
import json
import time
import sys
import urllib.request
import urllib.parse
import urllib.error

BASE_URL = "http://localhost:8080"
PROJECT_ID = "project_1780997325389"
JSON_PATH = "../../data/ontology/semiconductor_ontology.json"

# ── 辅助函数 ──────────────────────────────────────────────

def api(method, path, body=None, params=None):
    url = f"{BASE_URL}{path}"
    if params:
        qs = "&".join(f"{k}={urllib.parse.quote(str(v))}" for k, v in params.items() if v is not None)
        url += f"?{qs}"
    data = json.dumps(body, ensure_ascii=False).encode("utf-8") if body else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Content-Type", "application/json; charset=utf-8")
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except urllib.error.HTTPError as e:
            err_body = e.read().decode("utf-8")[:200]
            if e.code == 409:  # 冲突，跳过
                return None
            if attempt < 2 and e.code in (429, 502, 503):
                time.sleep(1)
                continue
            print(f"  ❌ HTTP {e.code}: {err_body}", file=sys.stderr)
            return None
        except Exception as e:
            if attempt < 2:
                time.sleep(1)
                continue
            print(f"  ❌ {e}", file=sys.stderr)
            return None
    return None

def api_get(path, params=None):
    return api("GET", path, params=params)

def api_post(path, body, params=None):
    return api("POST", path, body=body, params=params)

def api_put(path, body, params=None):
    return api("PUT", path, body=body, params=params)

def api_delete(path, params=None):
    return api("DELETE", path, params=params)

counters = {"created": 0, "failed": 0, "skipped": 0}

# ── 读取 JSON ──────────────────────────────────────────────

print("📖 读取 JSON...")
with open(JSON_PATH, "r", encoding="utf-8") as f:
    src = json.load(f)

all_ots = src["objectType"]
all_lts = src["linkType"]
print(f"  对象类型: {len(all_ots)}, 关系类型: {len(all_lts)}")

# 构建中文名→ nameEn 映射
cn_to_en = {ot["nameCn"]: ot["nameEn"] for ot in all_ots}
# DRAM 是特例：映射到 memory_dram (因现有 dram 已存在)
cn_to_en["DRAM"] = "memory_dram"

# ── Phase 1: 重命名现有 dram ─────────────────────────────────

print("\n🔄 Phase 1: 重命名现有 dram → DRAM代际")
r = api_put(f"/api/object-types/dram", {
    "name": "DRAM代际",
    "parentObjectType": "technology_generation",
    "status": "active",
    "projectId": PROJECT_ID
}, params={"projectId": PROJECT_ID})
if r and r.get("success"):
    print("  ✅ dram 已重命名为 DRAM代际")
else:
    print("  ⚠️  重命名 dram 失败，继续执行")

# ── Phase 2: 导入对象类型 ─────────────────────────────────

print(f"\n📦 Phase 2: 导入 {len(all_ots)} 个对象类型...")

# 计算各 OT 的深度 (用于拓扑序)
depth_map = {}
for ot in all_ots:
    d = 0
    p = ot.get("parentObjectTypeName")
    while p:
        d += 1
        parent = next((x for x in all_ots if x["nameCn"] == p), None)
        p = parent.get("parentObjectTypeName") if parent else None
    depth_map[ot["nameEn"]] = d

# 按深度分组
from collections import defaultdict
by_depth = defaultdict(list)
for ot in all_ots:
    by_depth[depth_map[ot["nameEn"]]].append(ot)

# 为 dram 特殊处理 - 使用不同 ID
DRAM_ALIAS = "memory_dram"

for depth in sorted(by_depth.keys()):
    batch = by_depth[depth]
    print(f"\n  深度 {depth}: {len(batch)} 个 OT...")

    for ot in batch:
        ot_id = ot["nameEn"]
        # dram → memory_dram
        if ot_id == "dram":
            ot_id = DRAM_ALIAS
        ot_name = ot["nameCn"]
        parent_cn = ot.get("parentObjectTypeName", "")
        parent_en = cn_to_en.get(parent_cn, "") if parent_cn else ""
        props = ot.get("properties", [])

        body = {
            "id": ot_id,
            "name": ot_name,
            "description": ot.get("description", ""),
            "icon": ot.get("source", "Database"),
            "objectTypeCategory": "entity" if ot.get("type") == "实体对象类型" else "relation",
            "showParentLink": True,
        }
        if parent_en:
            body["parentObjectType"] = parent_en

        result = api_post("/api/object-types", body, params={"projectId": PROJECT_ID})
        if not result or not result.get("success"):
            counters["failed"] += 1
            continue

        # 创建属性
        for j, prop in enumerate(props):
            prop_en = prop["propertyEn"]
            prop_cn = prop["propertyCn"]
            prop_id = f"p_{ot_id}_{prop_en}"

            prop_body = {
                "id": prop_id,
                "name": prop_cn,
                "type": prop["dataType"],
                "sortOrder": j,
                "description": f"{prop_cn} ({prop.get('unit', '')})" if prop.get('unit') else prop_cn,
            }
            pr = api_post(f"/api/object-types/{ot_id}/properties", prop_body,
                          params={"projectId": PROJECT_ID})
            if not pr or not pr.get("success"):
                print(f"\n    ⚠️  属性创建失败: {prop_cn} ({prop_id})")

        # 激活
        ar = api_put(f"/api/object-types/{ot_id}", {"status": "active"},
                     params={"projectId": PROJECT_ID})
        if ar and ar.get("success"):
            counters["created"] += 1
        else:
            print(f"\n    ⚠️  激活失败: {ot_name}")

        # 显示进度
        sys.stdout.write(f"  ✓ {ot_name} ({ot_id}) [{len(props)} props]\n")
        sys.stdout.flush()
        time.sleep(0.15)

# ── Phase 3: 导入关系类型 ─────────────────────────────────

print(f"\n\n🔗 Phase 3: 导入 {len(all_lts)} 个关系类型...")

card_map = {
    "一对多（1:N）": "1:N",
    "多对多（M:N）": "M:N",
    "一对一（1:1）": "1:1",
}

for i, lt in enumerate(all_lts):
    source_cn = lt["sourceObjectType"]
    target_cn = lt["targetObjectType"]
    source_en = cn_to_en.get(source_cn)
    target_en = cn_to_en.get(target_cn)

    if not source_en or not target_en:
        counters["failed"] += 1
        continue

    lt_id = f"lt_{source_en}_to_{target_en}"
    cardinality = card_map.get(lt.get("radix", ""), "N:N")

    body = {
        "id": lt_id,
        "name": lt["name"],
        "sourceObjectId": source_en,
        "targetObjectId": target_en,
        "cardinality": cardinality,
        "linkCategory": lt.get("linkTypeCategory", ""),
        "description": lt.get("description", ""),
    }

    result = api_post("/api/link-types", body, params={"projectId": PROJECT_ID})
    if not result or not result.get("success"):
        counters["failed"] += 1
        continue

    # 激活
    ar = api_put(f"/api/link-types/{lt_id}", {"status": "active"},
                 params={"projectId": PROJECT_ID})
    if ar and ar.get("success"):
        counters["created"] += 1

    if (i + 1) % 100 == 0:
        print(f"  ... {i+1}/{len(all_lts)} 已处理")
    time.sleep(0.05)

# ── Phase 4: 验证 ──────────────────────────────────────────

print(f"\n\n🔍 验证导入结果...")
onto = api_get("/api/ontology", params={"projectId": PROJECT_ID})
if onto:
    ots = onto.get("objectTypes", [])
    lts = onto.get("linkTypes", [])
    props = sum(len(ot.get("properties", [])) for ot in ots)
    print(f"  ✅ 对象类型: {len(ots)}")
    print(f"  ✅ 属性:     {props}")
    print(f"  ✅ 关系类型: {len(lts)}")

print(f"\n📊 创建: {counters['created']}, 失败: {counters['failed']}")
print(f"🎉 导入完成！请刷新前端查看。")
