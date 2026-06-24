#!/usr/bin/env python3
"""
半导体本体数据导入脚本
从 semiconductor_ontology_completion.json 读取数据，
通过后端 API 创建"半导体项目"及其完整的本体定义（ObjectType, Property, LinkType），
与现有新能源项目完全隔离。
"""

import json
import time
import sys
import urllib.request
import urllib.error

BASE_URL = "http://localhost:8080"
JSON_PATH = "semiconductor_ontology_completion.json"

# ── 辅助函数 ──────────────────────────────────────────────

def api_call(method, path, body=None, params=None):
    """通用的 REST API 调用"""
    url = f"{BASE_URL}{path}"
    if params:
        qs = "&".join(f"{k}={urllib.parse.quote(str(v))}" for k, v in params.items())
        url += f"?{qs}"

    data = None
    if body is not None:
        data = json.dumps(body, ensure_ascii=False).encode("utf-8")

    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Content-Type", "application/json; charset=utf-8")

    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        print(f"  ❌ HTTP {e.code} on {method} {url}")
        print(f"     Response: {e.read().decode('utf-8')[:200]}")
        return None
    except Exception as e:
        print(f"  ❌ Error: {e}")
        return None


def api_get(path, params=None):
    return api_call("GET", path, params=params)

def api_post(path, body, params=None):
    return api_call("POST", path, body=body, params=params)

def api_put(path, body, params=None):
    return api_call("PUT", path, body=body, params=params)


def slugify(text):
    """将中文名转为安全的 ID 片段"""
    s = text.replace("（", "_").replace("）", "_").replace("（", "_").replace("）", "_").replace(" ", "_").replace("/", "_").replace("(", "_").replace(")", "_")
    while "__" in s:
        s = s.replace("__", "_")
    return s.strip("_")


# ── 主流程 ──────────────────────────────────────────────

def main():
    # 1. 读取 JSON
    print("📖 读取 JSON 文件...")
    with open(JSON_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    object_types_json = data["objectType"]
    link_types_json = data["linkType"]

    # 构建中文名 → nameEn 映射表
    cn_to_en = {}
    for ot in object_types_json:
        cn_to_en[ot["nameCn"]] = ot["nameEn"]

    print(f"  找到 {len(object_types_json)} 个对象类型, {len(link_types_json)} 个关系类型")

    # 2. 创建项目
    print("\n🏗️  创建项目...")
    result = api_post("/api/projects", {
        "name": "半导体项目",
        "description": "半导体产业链本体建模，涵盖技术代际、制程节点、GPU/CPU架构、存储、先进封装、互联等"
    })
    if not result or not result.get("success"):
        print("  ❌ 创建项目失败")
        sys.exit(1)

    project_id = result["project"]["id"]
    print(f"  ✅ 项目已创建: {project_id} (半导体项目)")

    # 3. 确定创建顺序：父节点优先
    #    先创建不被其他对象类型引用的顶层类型，再创建子类型
    def get_dependency_order(ots):
        """拓扑排序：父节点先创建"""
        ordered = []
        remaining = list(ots)
        created = set()

        while remaining:
            batch = [ot for ot in remaining
                     if not ot.get("parentObjectTypeName") or ot["parentObjectTypeName"] in created]
            if not batch:
                print(f"  ⚠️  无法解析依赖: {[ot['nameCn'] for ot in remaining]}")
                break
            for ot in batch:
                ordered.append(ot)
                created.add(ot["nameCn"])
                remaining.remove(ot)
        return ordered

    ordered_ots = get_dependency_order(object_types_json)
    print(f"\n📦 按依赖顺序创建 {len(ordered_ots)} 个对象类型...")

    # 存储创建的 OT ID 列表
    created_ot_ids = []

    for i, ot in enumerate(ordered_ots):
        ot_id = ot["nameEn"]
        ot_name = ot["nameCn"]
        parent_cn = ot.get("parentObjectTypeName", "")
        parent_en = cn_to_en.get(parent_cn, "") if parent_cn else ""

        print(f"\n  [{i+1}/{len(ordered_ots)}] {ot_name} ({ot_id})", end="")

        body = {
            "id": ot_id,
            "name": ot_name,
            "description": ot.get("description", ""),
            "icon": ot.get("source", "Database"),
            "objectTypeCategory": "entity",
            "showParentLink": True,
        }
        if parent_en:
            body["parentObjectType"] = parent_en
            print(f" [父节点: {parent_cn}]", end="")

        # 创建 ObjectType
        result = api_post("/api/object-types", body, params={"projectId": project_id})
        if not result or not result.get("success"):
            print(f"  ❌ 创建失败")
            continue

        # 创建 Properties
        props = ot.get("properties", [])
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

            prop_result = api_post(
                f"/api/object-types/{ot_id}/properties",
                prop_body,
                params={"projectId": project_id}
            )
            if not prop_result or not prop_result.get("success"):
                print(f"\n    ⚠️  属性创建失败: {prop_cn} ({prop_id})", end="")

        # 激活 ObjectType（更新 status 为 active）
        activate_result = api_put(
            f"/api/object-types/{ot_id}",
            {"status": "active", "projectId": project_id},
            params={"projectId": project_id}
        )
        if activate_result and activate_result.get("success"):
            print(f"  ✅ ({len(props)} 属性)", end="")
        else:
            print(f"  ⚠️  激活失败", end="")

        created_ot_ids.append(ot_id)
        time.sleep(0.1)  # 稍微延迟，避免压垮后端

    # 4. 创建关系类型（LinkType）
    print(f"\n\n🔗 创建 {len(link_types_json)} 个关系类型...")

    # cardinality 映射
    card_map = {
        "一对多（1:N）": "1:N",
        "多对多（M:N）": "M:N",
        "一对一（1:1）": "1:1",
    }

    for i, lt in enumerate(link_types_json):
        source_cn = lt["sourceObjectType"]
        target_cn = lt["targetObjectType"]
        source_en = cn_to_en.get(source_cn, slugify(source_cn))
        target_en = cn_to_en.get(target_cn, slugify(target_cn))

        # 生成唯一 ID
        lt_key = f"{source_en}_to_{target_en}"
        lt_id = f"lt_{lt_key}"
        cardinality = card_map.get(lt.get("redix", ""), "N:N")

        print(f"\n  [{i+1}/{len(link_types_json)}] {lt['name']}", end="")

        body = {
            "id": lt_id,
            "name": lt["name"],
            "sourceObjectId": source_en,
            "targetObjectId": target_en,
            "cardinality": cardinality,
            "linkCategory": lt.get("linkTypeCategory", ""),
            "description": lt.get("description", ""),
        }

        result = api_post("/api/link-types", body, params={"projectId": project_id})
        if not result or not result.get("success"):
            print(f"  ❌ 创建失败", end="")
            continue

        # 激活 LinkType
        activate_result = api_put(
            f"/api/link-types/{lt_id}",
            {"status": "active", "projectId": project_id},
            params={"projectId": project_id}
        )
        if activate_result and activate_result.get("success"):
            print(f"  ✅", end="")
        else:
            print(f"  ⚠️  激活失败", end="")

        time.sleep(0.05)

    # 5. 验证
    print(f"\n\n🔍 验证导入结果...")

    # 查项目列表
    projects = api_get("/api/projects")
    if projects:
        for p in projects.get("projects", []):
            match = "✅" if p["id"] == project_id else "  "
            print(f"  {match} {p['name']} ({p['id']})")

    # 查该项目的 object types
    ots_check = api_get("/api/object-types", params={"projectId": project_id})
    if ots_check and "data" in ots_check:
        ot_count = len(ots_check["data"].get("objectTypes", []))
        print(f"\n  📊 半导体项目 Object Types: {ot_count} 个")
    else:
        # 如果 /api/object-types 不存在，试试 /api/ontology
        onto_check = api_get("/api/ontology", params={"projectId": project_id})
        if onto_check:
            ot_count = len(onto_check.get("objectTypes", onto_check.get("data", {}).get("objectTypes", [])))
            print(f"\n  📊 半导体项目 Object Types: {ot_count} 个")

    # 查 link types
    lt_check = api_get("/api/link-types", params={"projectId": project_id})
    if lt_check and "data" in lt_check:
        lt_count = len(lt_check["data"].get("linkTypes", []))
        print(f"  📊 半导体项目 Link Types: {lt_count} 个")

    print(f"\n🎉 导入完成！")
    print(f"   项目ID: {project_id}")
    print(f"   在浏览器打开 http://localhost:3000 并切换到半导体项目查看")


if __name__ == "__main__":
    import urllib.parse
    main()
