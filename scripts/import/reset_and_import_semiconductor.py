#!/usr/bin/env python3
"""
重置半导体项目数据并导入 semiconductor_ontology_revised.json。
执行流程:
  1. 清空半导体项目的全部数据（不影响公共项目）
  2. 导入 197 个对象类型（含属性）
  3. 导入 1895 条关系类型
  4. 验证数据完整性
"""
import json
import subprocess
import sys
import time
from collections import defaultdict

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"
JSON_PATH = "../../data/ontology/semiconductor_ontology_revised.json"


def run_sql(sql, description=""):
    """执行 SQL 语句"""
    result = subprocess.run(
        f'{MYSQL_CMD} -e "{sql}"',
        shell=True, capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"  ❌ {description}: {result.stderr[:300]}")
        return False
    return result


def escape(s):
    """转义 SQL 字符串"""
    if not s:
        return ""
    return s.replace("\\", "\\\\").replace("'", "\\'").replace('"', '\\"')


# ── 读取 JSON ──────────────────────────────────────────────

print("📖 读取 semiconductor_ontology_revised.json ...")
with open(JSON_PATH, "r", encoding="utf-8") as f:
    src = json.load(f)

all_ots = src["objectType"]
all_lts = src["linkType"]
print(f"  对象类型: {len(all_ots)}, 关系类型: {len(all_lts)}")

# 构建映射
cn_to_en = {ot["nameCn"]: ot["nameEn"] for ot in all_ots}
en_to_ot = {ot["nameEn"]: ot for ot in all_ots}

card_map = {
    "一对多（1:N）": "1:N",
    "多对多（M:N）": "M:N",
    "一对一（1:1）": "1:1",
    "多对一（N:1）": "N:1",
}

now = time.strftime('%Y-%m-%d %H:%M:%S')


# ════════════════════════════════════════════════════════════
# Phase 1: 清空半导体项目数据
# ════════════════════════════════════════════════════════════

print("\n🗑️  Phase 1: 清空半导体项目数据...")

# 确认公共项目不会被影响
r = run_sql(
    f"SELECT COUNT(*) AS cnt FROM object_types WHERE project_id='project_public'",
    "检查公共项目"
)
if r:
    public_count = r.stdout.strip().split('\n')[-1]
    print(f"  📋 公共项目 OT 数量: {public_count}（将保持不变）")

# 按 FK 依赖顺序删除
tables_to_clean = [
    ("properties", "属性"),
    ("link_types", "关系类型"),
    ("object_type_layouts", "布局位置"),
    ("object_types", "对象类型"),
]

for table, label in tables_to_clean:
    r = run_sql(
        f"DELETE FROM {table} WHERE project_id='{PROJECT_ID}'",
        f"清空 {table}"
    )
    if r:
        # 获取受影响行数
        count_r = run_sql(
            f"SELECT COUNT(*) AS cnt FROM {table} WHERE project_id='{PROJECT_ID}'",
            f"验证 {table}"
        )
        print(f"  ✅ 已清空 {label} ({table})")

# 验证公共项目未受影响
r = run_sql(
    f"SELECT COUNT(*) AS cnt FROM object_types WHERE project_id='project_public'",
    "验证公共项目"
)
if r:
    after_count = r.stdout.strip().split('\n')[-1]
    print(f"  🛡️  公共项目 OT 数量: {after_count}（未受影响）")


# ════════════════════════════════════════════════════════════
# Phase 2: 导入对象类型 + 属性
# ════════════════════════════════════════════════════════════

print(f"\n📦 Phase 2: 导入 {len(all_ots)} 个对象类型...")

# 计算拓扑深度
depth_map = {}
for ot in all_ots:
    d = 0
    p = ot.get("parentObjectTypeName")
    visited = set()
    while p and p not in visited:
        visited.add(p)
        d += 1
        parent = next((x for x in all_ots if x["nameCn"] == p), None)
        p = parent.get("parentObjectTypeName") if parent else None
    depth_map[ot["nameEn"]] = d

# 按深度分组（确保 parent 在 child 之前插入）
by_depth = defaultdict(list)
for ot in all_ots:
    by_depth[depth_map[ot["nameEn"]]].append(ot)

ot_created = 0
prop_created = 0
BATCH_SIZE = 50

for depth in sorted(by_depth.keys()):
    batch = by_depth[depth]
    print(f"\n  深度 {depth}: {len(batch)} 个 OT...")

    # 批量 INSERT 对象类型
    values = []
    for ot in batch:
        ot_id = ot["nameEn"]
        ot_name = escape(ot["nameCn"])
        ot_desc = escape(ot.get("description", ""))
        parent_cn = ot.get("parentObjectTypeName", "")
        parent_en = cn_to_en.get(parent_cn, "") if parent_cn else ""
        category = "relation" if "关系" in ot.get("type", "") else "entity"
        parent_val = "NULL" if not parent_en else "'" + escape(parent_en) + "'"

        values.append(
            f"('{escape(ot_id)}','{ot_name}','{ot_desc}','Database','',"
            f"{parent_val},"
            f"'active','{PROJECT_ID}',1,'{category}','{now}','{now}')"
        )

    # 分批插入
    for i in range(0, len(values), BATCH_SIZE):
        chunk = values[i:i + BATCH_SIZE]
        sql = (
            "INSERT INTO object_types (id, name, description, icon, backing_dataset, "
            "parent_object_type, status, project_id, show_parent_link, object_type_category, "
            "created_at, updated_at) VALUES "
            + ",".join(chunk)
        )
        r = run_sql(sql, f"插入 OT batch {i//BATCH_SIZE+1}")
        if r:
            ot_created += len(chunk)

    # 插入属性
    prop_values = []
    for ot in batch:
        ot_id = ot["nameEn"]
        for j, prop in enumerate(ot.get("properties", [])):
            prop_en = prop.get("propertyEn", "")
            prop_cn = escape(prop.get("propertyCn", ""))
            prop_type = prop.get("dataType", "string")
            unit = prop.get("unit", "")
            prop_desc = f"{prop_cn} ({escape(unit)})" if unit else prop_cn
            prop_id = f"p_{ot_id}_{prop_en}"

            prop_values.append(
                f"('{escape(prop_id)}','{escape(ot_id)}','{prop_cn}','{prop_type}',"
                f"'{prop_desc}',0,'',NULL,{j},'{PROJECT_ID}')"
            )

    if prop_values:
        for i in range(0, len(prop_values), BATCH_SIZE):
            chunk = prop_values[i:i + BATCH_SIZE]
            sql = (
                "INSERT INTO properties (id, object_type_id, name, type, "
                "description, is_primary_key, base_column, type_classes, sort_order, project_id) VALUES "
                + ",".join(chunk)
            )
            r = run_sql(sql, f"插入 Properties batch {i//BATCH_SIZE+1}")
            if r:
                prop_created += len(chunk)

    # 显示本深度完成的 OT
    for ot in batch:
        sys.stdout.write(f"    ✓ {ot['nameCn']} ({ot['nameEn']})\n")
    sys.stdout.flush()

print(f"\n  📊 OT 创建: {ot_created}, 属性创建: {prop_created}")


# ════════════════════════════════════════════════════════════
# Phase 3: 导入关系类型
# ════════════════════════════════════════════════════════════

print(f"\n🔗 Phase 3: 导入 {len(all_lts)} 个关系类型...")

lt_created = 0
lt_skipped = 0
# 用于处理同名 source→target 的多条 LT
lt_counter = defaultdict(int)
BATCH_SIZE = 200

batch_values = []

for lt in all_lts:
    source_cn = lt["sourceObjectType"]
    target_cn = lt["targetObjectType"]
    source_en = cn_to_en.get(source_cn)
    target_en = cn_to_en.get(target_cn)

    if not source_en or not target_en:
        lt_skipped += 1
        continue

    # 处理同名 LT 的 ID 冲突
    key = f"{source_en}_to_{target_en}"
    lt_counter[key] += 1
    idx = lt_counter[key]
    lt_id = f"lt_{key}_{idx}" if idx > 1 else f"lt_{key}"

    name = escape(lt["name"])
    category = escape(lt.get("linkTypeCategory", ""))
    cardinality = card_map.get(lt.get("radix", ""), "N:N")
    desc = escape(lt.get("description", ""))

    batch_values.append(
        f"('{escape(lt_id)}','{name}','{escape(source_en)}','{escape(target_en)}',"
        f"'{cardinality}','{category}','{desc}','{PROJECT_ID}',"
        f"'active','{now}','{now}')"
    )

    if len(batch_values) >= BATCH_SIZE:
        sql = (
            "INSERT INTO link_types (id, name, source_object_id, target_object_id, "
            "cardinality, link_category, description, project_id, "
            "status, created_at, updated_at) VALUES "
            + ",".join(batch_values)
        )
        r = run_sql(sql, f"插入 LT batch")
        if r:
            lt_created += len(batch_values)
        done = lt_created + lt_skipped
        print(f"  ... {done}/{len(all_lts)} 已处理 ({done*100//len(all_lts)}%)")
        batch_values = []

# 处理剩余
if batch_values:
    sql = (
        "INSERT INTO link_types (id, name, source_object_id, target_object_id, "
        "cardinality, link_category, description, project_id, "
        "status, created_at, updated_at) VALUES "
        + ",".join(batch_values)
    )
    r = run_sql(sql, "插入 LT 最后一批")
    if r:
        lt_created += len(batch_values)

print(f"\n  📊 LT 创建: {lt_created}, 跳过: {lt_skipped}")


# ════════════════════════════════════════════════════════════
# Phase 4: 验证
# ════════════════════════════════════════════════════════════

print("\n\n🔍 Phase 4: 验证数据完整性...")

# 直接 SQL 验证
for table, label in [("object_types", "对象类型"), ("link_types", "关系类型"), ("properties", "属性")]:
    r = run_sql(
        f"SELECT COUNT(*) AS cnt FROM {table} WHERE project_id='{PROJECT_ID}'",
        f"验证 {table}"
    )
    if r:
        count = r.stdout.strip().split('\n')[-1]
        print(f"  {label}: {count}")

# 验证公共项目未受影响
r = run_sql(
    "SELECT COUNT(*) AS cnt FROM object_types WHERE project_id='project_public'",
    "验证公共项目"
)
if r:
    count = r.stdout.strip().split('\n')[-1]
    print(f"  🛡️  公共项目 OT: {count}（未受影响）")

# API 验证
try:
    import urllib.request
    req = urllib.request.Request(f'http://localhost:8080/api/ontology?projectId={PROJECT_ID}')
    with urllib.request.urlopen(req, timeout=10) as resp:
        api_data = json.loads(resp.read().decode('utf-8'))
    ots = api_data.get('objectTypes', [])
    lts = api_data.get('linkTypes', [])
    props = sum(len(ot.get('properties', [])) for ot in ots)
    print(f"\n  API 验证:")
    print(f"    对象类型: {len(ots)}")
    print(f"    属性:     {props}")
    print(f"    关系类型: {len(lts)}")
except Exception as e:
    print(f"  ⚠️  API 验证失败: {e}")

print("\n🎉 导入完成！请刷新前端查看。")
