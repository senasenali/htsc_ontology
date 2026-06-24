#!/usr/bin/env python3
"""
导出半导体项目的完整 SQL 初始化脚本（含逆向计算的 layout 位置）。
执行后生成 semiconductor_init.sql，同事可直接导入初始化数据库。
"""
import json
import sys
import time
from collections import defaultdict

JSON_PATH = "../../data/ontology/semiconductor_ontology_revised.json"
PROJECT_ID = "project_1780997325389"
PROJECT_NAME = "半导体项目"
PROJECT_DESC = "半导体产业链本体建模，涵盖技术代际、制程节点、GPU/CPU架构、存储、先进封装、互联等"

# ── Layout Constants (与 GraphView.tsx 保持一致) ──────────────────────────────
NODE_WIDTH = 160
NODE_HEIGHT = 40
GROUP_MIN_WIDTH = 220
GROUP_TITLE_HEIGHT = 28
GROUP_PADDING = 14
GROUP_CHILD_GAP = 12
LEAF_GRID_COLS = 5
SECTION_X_GAP = 1600
MARGIN_LEFT = 80
MARGIN_TOP = 60
LAYER_Y_GAP = 280

card_map = {
    "一对多（1:N）": "1:N",
    "多对多（M:N）": "M:N",
    "一对一（1:1）": "1:1",
    "多对一（N:1）": "N:1",
}

# ── 读取 JSON ──────────────────────────────────────────────────────────────

with open(JSON_PATH, "r", encoding="utf-8") as f:
    src = json.load(f)

all_ots = src["objectType"]
all_lts = src["linkType"]
cn_to_en = {ot["nameCn"]: ot["nameEn"] for ot in all_ots}
en_to_ot = {ot["nameEn"]: ot for ot in all_ots}
all_en_ids = set(ot["nameEn"] for ot in all_ots)

print(f"📖 读取 {JSON_PATH}: {len(all_ots)} OTs, {len(all_lts)} LTs")

# ── 递归布局计算（与 layoutSubtree 一致）────────────────────────────────────

def escape_sql(s):
    if not s:
        return ""
    return s.replace("\\", "\\\\").replace("'", "\\'").replace('"', '\\"')

def calculate_group_size(parent_id):
    """递归计算 Group 尺寸（与 calculateGroupSize 一致）"""
    children = [ot for ot in all_ots if ot.get("parentObjectTypeName") == en_to_ot[parent_id]["nameCn"]]
    if not children:
        return {"width": GROUP_MIN_WIDTH, "height": NODE_HEIGHT + GROUP_PADDING * 2 + GROUP_TITLE_HEIGHT}

    child_ids = [ot["nameEn"] for ot in children]
    non_leaf_ids = [cid for cid in child_ids if any(ot["nameEn"] != cid and ot.get("parentObjectTypeName") == en_to_ot[cid]["nameCn"] for ot in all_ots)]
    leaf_ids = [cid for cid in child_ids if cid not in non_leaf_ids]

    # 非叶子纵向
    non_leaf_total_height = 0
    non_leaf_max_width = 0
    for cid in non_leaf_ids:
        cs = calculate_group_size(cid)
        non_leaf_total_height += cs["height"] + GROUP_CHILD_GAP
        non_leaf_max_width = max(non_leaf_max_width, cs["width"])

    # 叶子横向网格
    leaf_cols = min(LEAF_GRID_COLS, max(len(leaf_ids), 1))
    leaf_rows = (len(leaf_ids) + leaf_cols - 1) // leaf_cols if leaf_ids else 0
    leaf_w = leaf_cols * (NODE_WIDTH + GROUP_CHILD_GAP) - GROUP_CHILD_GAP + GROUP_PADDING * 2
    leaf_h = leaf_rows * (NODE_HEIGHT + GROUP_CHILD_GAP) - GROUP_CHILD_GAP

    total_w = max(non_leaf_max_width + GROUP_PADDING * 2, leaf_w, GROUP_MIN_WIDTH)
    total_h = GROUP_TITLE_HEIGHT + GROUP_PADDING + \
        (non_leaf_total_height - GROUP_CHILD_GAP if non_leaf_ids else 0) + \
        (leaf_h + GROUP_CHILD_GAP if leaf_ids else 0) + \
        GROUP_PADDING

    return {"width": total_w, "height": total_h}

def layout_node(ot_id, rel_x, rel_y):
    """递归布局节点（与 layoutNode 一致），返回 {positions: {id: {x,y}}, width, height}"""
    ot = en_to_ot[ot_id]
    children = [c for c in all_ots if c.get("parentObjectTypeName") == ot["nameCn"]]

    if not children:
        return {
            "positions": {ot_id: {"x": rel_x, "y": rel_y, "w": NODE_WIDTH, "h": NODE_HEIGHT}},
            "width": NODE_WIDTH,
            "height": NODE_HEIGHT,
        }

    child_ids = [c["nameEn"] for c in children]
    non_leaf_ids = [cid for cid in child_ids if any(ot["nameEn"] != cid and ot.get("parentObjectTypeName") == en_to_ot[cid]["nameCn"] for ot in all_ots)]
    leaf_ids = [cid for cid in child_ids if cid not in non_leaf_ids]

    positions = {}
    cur_y = GROUP_TITLE_HEIGHT + GROUP_PADDING
    max_child_width = 0

    # 1. 非叶子纵向
    for cid in non_leaf_ids:
        result = layout_node(cid, GROUP_PADDING, cur_y)
        positions.update(result["positions"])
        cur_y += result["height"] + GROUP_CHILD_GAP
        max_child_width = max(max_child_width, result["width"])

    # 2. 叶子横向网格
    leaf_cols = min(LEAF_GRID_COLS, max(len(leaf_ids), 1))
    for idx, cid in enumerate(leaf_ids):
        col = idx % leaf_cols
        row = idx // leaf_cols
        cx = GROUP_PADDING + col * (NODE_WIDTH + GROUP_CHILD_GAP)
        cy = cur_y + row * (NODE_HEIGHT + GROUP_CHILD_GAP)
        positions[cid] = {"x": cx, "y": cy, "w": NODE_WIDTH, "h": NODE_HEIGHT}

    # Group 自身
    positions[ot_id] = {"x": rel_x, "y": rel_y, "w": total_w, "h": total_h}

    # Group 尺寸
    leaf_rows = (len(leaf_ids) + leaf_cols - 1) // leaf_cols if leaf_ids else 0
    leaf_section_w = leaf_cols * (NODE_WIDTH + GROUP_CHILD_GAP) - GROUP_CHILD_GAP + GROUP_PADDING * 2
    leaf_section_h = leaf_rows * (NODE_HEIGHT + GROUP_CHILD_GAP) - GROUP_CHILD_GAP
    total_w = max(max_child_width + GROUP_PADDING * 2, leaf_section_w, GROUP_MIN_WIDTH)
    total_h = cur_y + (leaf_section_h + GROUP_CHILD_GAP if leaf_ids else 0) + GROUP_PADDING

    return {"positions": positions, "width": total_w, "height": total_h}


# ── 计算所有节点位置 ──────────────────────────────────────────────────────

all_positions = {}  # {ot_id: {x, y}} — 绝对坐标

# 左列：company
company_ot = en_to_ot.get("company")
if company_ot:
    all_positions["company"] = {"x": MARGIN_LEFT, "y": MARGIN_TOP}

# 中列：产业链
industry_ot = en_to_ot.get("semiconductor_industry_chain")
if industry_ot:
    industry_start_x = MARGIN_LEFT + SECTION_X_GAP
    result = layout_node("semiconductor_industry_chain", 0, 0)
    # 子节点位置是相对坐标，加上偏移
    for nid, pos in result["positions"].items():
        all_positions[nid] = {"x": pos["x"] + industry_start_x, "y": pos["y"] + MARGIN_TOP}

# 右列：技术路线
tech_ot = en_to_ot.get("technology_route")
if tech_ot:
    tech_start_x = MARGIN_LEFT + SECTION_X_GAP * 2
    result = layout_node("technology_route", 0, 0)
    for nid, pos in result["positions"].items():
        all_positions[nid] = {"x": pos["x"] + tech_start_x, "y": pos["y"] + MARGIN_TOP}

print(f"📐 计算了 {len(all_positions)} 个节点的 layout 位置")

# ── 生成 SQL ──────────────────────────────────────────────────────────────

now = time.strftime('%Y-%m-%d %H:%M:%S')
lines = []

lines.append("-- ============================================================")
lines.append(f"-- 半导体项目初始化 SQL")
lines.append(f"-- 生成时间: {now}")
lines.append(f"-- 数据源: {JSON_PATH}")
lines.append(f"-- OTs: {len(all_ots)}, LTs: {len(all_lts)}, Layouts: {len(all_positions)}")
lines.append("-- ============================================================")
lines.append("")

# 1. 创建项目
lines.append("-- ── 1. 项目 ──────────────────────────────────────────────")
lines.append(f"INSERT IGNORE INTO projects (id, name, description, is_public, status, created_at, updated_at) VALUES")
lines.append(f"  ('{PROJECT_ID}', '{PROJECT_NAME}', '{PROJECT_DESC}', 0, 'ACTIVE', '{now}', '{now}');")
lines.append("")

# 2. 对象类型
lines.append("-- ── 2. 对象类型 ──────────────────────────────────────────")

# 按拓扑深度排序
def get_depth(ot):
    d = 0
    p = ot.get("parentObjectTypeName")
    visited = set()
    while p and p not in visited:
        visited.add(p)
        d += 1
        parent = next((x for x in all_ots if x["nameCn"] == p), None)
        p = parent.get("parentObjectTypeName") if parent else None
    return d

sorted_ots = sorted(all_ots, key=lambda ot: (get_depth(ot), ot["nameEn"]))

ot_values = []
for ot in sorted_ots:
    ot_id = ot["nameEn"]
    name = escape_sql(ot["nameCn"])
    desc = escape_sql(ot.get("description", ""))
    parent_cn = ot.get("parentObjectTypeName", "")
    parent_en = cn_to_en.get(parent_cn, "") if parent_cn else ""
    category = "relation" if "关系" in ot.get("type", "") else "entity"
    parent_sql = f"'{parent_en}'" if parent_en else "NULL"

    ot_values.append(
        f"('{ot_id}','{name}','{desc}','Database','',NULL,NULL,"
        f"{parent_sql},'active','{PROJECT_ID}',1,'{category}','{now}','{now}')"
    )

for i in range(0, len(ot_values), 50):
    chunk = ot_values[i:i+50]
    lines.append("INSERT INTO object_types (id, name, description, icon, backing_dataset, industry_id, data_source, "
                 "parent_object_type, status, project_id, show_parent_link, object_type_category, created_at, updated_at) VALUES")
    lines.append(",\n".join(f"  {v}" for v in chunk) + ";")
    lines.append("")

# 3. 属性
lines.append("-- ── 3. 属性 ──────────────────────────────────────────────")
prop_values = []
for ot in all_ots:
    ot_id = ot["nameEn"]
    for j, prop in enumerate(ot.get("properties", [])):
        prop_en = prop.get("propertyEn", "")
        prop_cn = escape_sql(prop.get("propertyCn", ""))
        data_type = prop.get("dataType", "string")
        unit = prop.get("unit", "")
        desc = f"{prop_cn} ({escape_sql(unit)})" if unit else prop_cn
        prop_id = f"p_{ot_id}_{prop_en}"

        prop_values.append(
            f"('{prop_id}','{ot_id}','{prop_cn}','{data_type}','{desc}',0,'',NULL,{j},'{PROJECT_ID}')"
        )

for i in range(0, len(prop_values), 100):
    chunk = prop_values[i:i+100]
    lines.append("INSERT INTO properties (id, object_type_id, name, type, description, "
                 "is_primary_key, base_column, type_classes, sort_order, project_id) VALUES")
    lines.append(",\n".join(f"  {v}" for v in chunk) + ";")
    lines.append("")

# 4. 关系类型
lines.append("-- ── 4. 关系类型 ──────────────────────────────────────────")
lt_counter = defaultdict(int)
lt_values = []

for lt in all_lts:
    src_cn = lt["sourceObjectType"]
    tgt_cn = lt["targetObjectType"]
    src_en = cn_to_en.get(src_cn)
    tgt_en = cn_to_en.get(tgt_cn)
    if not src_en or not tgt_en:
        continue

    key = f"{src_en}_to_{tgt_en}"
    lt_counter[key] += 1
    idx = lt_counter[key]
    lt_id = f"lt_{key}_{idx}" if idx > 1 else f"lt_{key}"

    name = escape_sql(lt["name"])
    category = escape_sql(lt.get("linkTypeCategory", ""))
    cardinality = card_map.get(lt.get("radix", ""), "N:N")
    desc = escape_sql(lt.get("description", ""))

    lt_values.append(
        f"('{lt_id}','{name}','{src_en}','{tgt_en}','{cardinality}','{category}','{desc}',"
        f"'{PROJECT_ID}','active','{now}','{now}')"
    )

for i in range(0, len(lt_values), 100):
    chunk = lt_values[i:i+100]
    lines.append("INSERT INTO link_types (id, name, source_object_id, target_object_id, "
                 "cardinality, link_category, description, project_id, status, created_at, updated_at) VALUES")
    lines.append(",\n".join(f"  {v}" for v in chunk) + ";")
    lines.append("")

# 5. 布局位置
lines.append("-- ── 5. 布局位置 ──────────────────────────────────────────")
layout_values = []
layout_id = 1
for nid, pos in sorted(all_positions.items()):
    x = round(pos["x"], 1)
    y = round(pos["y"], 1)
    layout_values.append(
        f"({layout_id},'{PROJECT_ID}','{nid}',{x},{y},'{now}','{now}',NULL,NULL)"
    )
    layout_id += 1

for i in range(0, len(layout_values), 100):
    chunk = layout_values[i:i+100]
    lines.append("INSERT INTO object_type_layouts (id, project_id, object_type_id, x, y, "
                 "created_at, updated_at, width, height) VALUES")
    lines.append(",\n".join(f"  {v}" for v in chunk) + ";")
    lines.append("")

# 写入文件
output_path = "../../sql/init/semiconductor_init.sql"
with open(output_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"\n✅ 已生成 {output_path}")
print(f"   项目: 1 条")
print(f"   对象类型: {len(ot_values)} 条")
print(f"   属性: {len(prop_values)} 条")
print(f"   关系类型: {len(lt_values)} 条")
print(f"   布局位置: {len(layout_values)} 条")
print(f"\n💡 同事使用方式:")
print(f"   mysql -u root -p ontology < {output_path}")
