#!/usr/bin/env python3
"""
为半导体项目补充 6 个缺失的技术类 Object Type，并导入对应实例。
- 封装技术世代 -> 技术世代层
- CMP技术、刻蚀技术、清洗技术、离子注入技术、薄膜沉积技术 -> 技术能力层
"""
import csv
import json
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"
JSON_PATH = "数据库/semiconductor_ontology_before_v3_merge.json"


def run_sql(sql, description=""):
    with tempfile.NamedTemporaryFile(mode='w', suffix='.sql', delete=False, encoding='utf-8') as f:
        f.write(sql)
        tmp_path = f.name
    try:
        result = subprocess.run(
            f'{MYSQL_CMD} < "{tmp_path}"',
            shell=True, capture_output=True, text=True
        )
        if result.returncode != 0:
            print(f"  ❌ {description}: {result.stderr[:300]}")
            return None
        return result
    finally:
        os.unlink(tmp_path)


def escape(s):
    if s is None:
        return ""
    return str(s).replace("\\", "\\\\").replace("'", "\\'")


NEW_OTS = [
    {
        "nameCn": "CMP技术",
        "nameEn": "cmp_technology",
        "parentObjectTypeName": "技术能力层",
        "description": "化学机械抛光技术，用于晶圆表面平坦化。",
        "type": "实体对象类型",
        "source": "SEMI",
        "properties": [
            {"propertyCn": "CMP类别", "propertyEn": "cmp_category", "dataType": "string", "unit": ""},
            {"propertyCn": "具体工艺", "propertyEn": "specific_process", "dataType": "string", "unit": ""},
            {"propertyCn": "主要应用", "propertyEn": "primary_application", "dataType": "string", "unit": ""},
            {"propertyCn": "关键材料", "propertyEn": "key_material", "dataType": "string", "unit": ""},
        ],
    },
    {
        "nameCn": "刻蚀技术",
        "nameEn": "etching_technology",
        "parentObjectTypeName": "技术能力层",
        "description": "利用等离子体或化学反应选择性去除薄膜图形化材料的工艺技术。",
        "type": "实体对象类型",
        "source": "Lam Research / TEL",
        "properties": [
            {"propertyCn": "等离子体产生方式", "propertyEn": "plasma_generation", "dataType": "string", "unit": ""},
            {"propertyCn": "等离子体密度", "propertyEn": "plasma_density", "dataType": "string", "unit": ""},
            {"propertyCn": "离子能量", "propertyEn": "ion_energy", "dataType": "string", "unit": ""},
            {"propertyCn": "目标材料", "propertyEn": "target_material", "dataType": "string", "unit": ""},
            {"propertyCn": "各向异性能力", "propertyEn": "anisotropic_capability", "dataType": "string", "unit": ""},
            {"propertyCn": "控制灵活性", "propertyEn": "control_flexibility", "dataType": "string", "unit": ""},
        ],
    },
    {
        "nameCn": "封装技术世代",
        "nameEn": "packaging_technology_generation",
        "parentObjectTypeName": "技术世代层",
        "description": "封装技术按世代演进的分类体系。",
        "type": "实体对象类型",
        "source": "ASE / Yole",
        "properties": [
            {"propertyCn": "世代名称", "propertyEn": "generation_name", "dataType": "string", "unit": ""},
            {"propertyCn": "时代", "propertyEn": "era", "dataType": "string", "unit": ""},
            {"propertyCn": "封装维度", "propertyEn": "packaging_dimension", "dataType": "string", "unit": ""},
            {"propertyCn": "IO密度", "propertyEn": "io_density", "dataType": "string", "unit": ""},
            {"propertyCn": "代表技术", "propertyEn": "representative_technology", "dataType": "string", "unit": ""},
        ],
    },
    {
        "nameCn": "清洗技术",
        "nameEn": "cleaning_technology",
        "parentObjectTypeName": "技术能力层",
        "description": "晶圆制造中去除颗粒、金属离子和有机残留物的工艺技术。",
        "type": "实体对象类型",
        "source": "SEMI",
        "properties": [
            {"propertyCn": "清洗方式", "propertyEn": "cleaning_method", "dataType": "string", "unit": ""},
            {"propertyCn": "作用机理", "propertyEn": "mechanism", "dataType": "string", "unit": ""},
            {"propertyCn": "吞吐特征", "propertyEn": "throughput_characteristic", "dataType": "string", "unit": ""},
            {"propertyCn": "清洗精度", "propertyEn": "cleaning_precision", "dataType": "string", "unit": ""},
            {"propertyCn": "交叉污染风险", "propertyEn": "cross_contamination_risk", "dataType": "string", "unit": ""},
        ],
    },
    {
        "nameCn": "离子注入技术",
        "nameEn": "ion_implantation_technology",
        "parentObjectTypeName": "技术能力层",
        "description": "将掺杂离子以特定能量和剂量注入晶圆以改变电学特性的技术。",
        "type": "实体对象类型",
        "source": "Applied Materials / Axcelis",
        "properties": [
            {"propertyCn": "能量等级", "propertyEn": "energy_level", "dataType": "string", "unit": ""},
            {"propertyCn": "能量范围", "propertyEn": "energy_range", "dataType": "string", "unit": ""},
            {"propertyCn": "束流等级", "propertyEn": "beam_current_level", "dataType": "string", "unit": ""},
            {"propertyCn": "束流范围", "propertyEn": "beam_current_range", "dataType": "string", "unit": ""},
            {"propertyCn": "目标应用", "propertyEn": "target_application", "dataType": "string", "unit": ""},
            {"propertyCn": "注入特性", "propertyEn": "implantation_characteristic", "dataType": "string", "unit": ""},
        ],
    },
    {
        "nameCn": "薄膜沉积技术",
        "nameEn": "thin_film_deposition_technology",
        "parentObjectTypeName": "技术能力层",
        "description": "在晶圆表面沉积均匀薄膜材料的工艺技术。",
        "type": "实体对象类型",
        "source": "Applied Materials / Lam Research",
        "properties": [
            {"propertyCn": "沉积原理", "propertyEn": "deposition_principle", "dataType": "string", "unit": ""},
            {"propertyCn": "台阶覆盖", "propertyEn": "step_coverage", "dataType": "string", "unit": ""},
            {"propertyCn": "沉积速率", "propertyEn": "deposition_rate", "dataType": "string", "unit": ""},
            {"propertyCn": "工艺温度", "propertyEn": "process_temperature", "dataType": "string", "unit": ""},
            {"propertyCn": "均匀性", "propertyEn": "uniformity", "dataType": "string", "unit": ""},
            {"propertyCn": "厚度控制", "propertyEn": "thickness_control", "dataType": "string", "unit": ""},
            {"propertyCn": "薄膜纯度", "propertyEn": "film_purity", "dataType": "string", "unit": ""},
        ],
    },
]


def append_to_json(ots):
    with open(JSON_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    existing_names = {ot['nameCn'] for ot in data['objectType']}
    added = 0
    for ot in ots:
        if ot['nameCn'] in existing_names:
            print(f"  ⚠️ JSON 中已存在 {ot['nameCn']}，跳过")
            continue
        data['objectType'].append(ot)
        added += 1
    with open(JSON_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"  ✅ 已向 JSON 追加 {added} 个 OT")


def insert_ot_to_db(ot, now, parent_en):
    ot_id = ot['nameEn']
    ot_name = escape(ot['nameCn'])
    ot_desc = escape(ot.get('description', ''))
    category = "relation" if "关系" in ot.get("type", "") else "entity"
    parent_val = "NULL" if not parent_en else f"'{escape(parent_en)}'"
    backing = escape(ot_id)
    sql = (
        f"INSERT INTO object_types (id, name, description, icon, backing_dataset, "
        f"parent_object_type, status, project_id, show_parent_link, object_type_category, "
        f"created_at, updated_at) VALUES ("
        f"'{escape(ot_id)}','{ot_name}','{ot_desc}','Database','{backing}',"
        f"{parent_val},'active','{PROJECT_ID}',1,'{category}','{now}','{now}')"
    )
    return run_sql(sql, f"插入 OT {ot_id}")


def insert_properties_to_db(ot):
    ot_id = ot['nameEn']
    values = []
    for j, prop in enumerate(ot.get('properties', [])):
        prop_en = prop.get('propertyEn', '')
        prop_cn = escape(prop.get('propertyCn', ''))
        prop_type = prop.get('dataType', 'string')
        unit = prop.get('unit', '')
        prop_desc = f"{prop_cn} ({escape(unit)})" if unit else prop_cn
        prop_id = f"p_{ot_id}_{prop_en}"
        values.append(
            f"('{escape(prop_id)}','{escape(ot_id)}','{prop_cn}','{prop_type}',"
            f"'{prop_desc}',0,'',NULL,{j},'{PROJECT_ID}')"
        )
    if not values:
        return True
    sql = (
        "INSERT INTO properties (id, object_type_id, name, type, "
        "description, is_primary_key, base_column, type_classes, sort_order, project_id) VALUES "
        + ",".join(values)
    )
    return run_sql(sql, f"插入 {ot_id} 属性")


def create_backing_table(table_name):
    sql = (
        f"CREATE TABLE IF NOT EXISTS `{escape(table_name)}` ("
        f"`id` bigint NOT NULL AUTO_INCREMENT, "
        f"`name` varchar(500) DEFAULT NULL, "
        f"`unique_id` varchar(500) DEFAULT NULL, "
        f"`description` text, "
        f"`created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP, "
        f"`updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "
        f"PRIMARY KEY (`id`), "
        f"UNIQUE KEY `uk_unique_id` (`unique_id`) "
        f") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实例数据表'"
    )
    return run_sql(sql, f"创建表 {table_name}")


def main():
    print("📖 步骤 1/5: 向 JSON 追加 6 个 OT...")
    append_to_json(NEW_OTS)

    print("\n📖 步骤 2/5: 获取父 OT 英文 id 映射...")
    r = run_sql(
        f"SELECT name, id FROM object_types WHERE project_id='{PROJECT_ID}'",
        "查询 OT"
    )
    name_to_id = {}
    for line in r.stdout.strip().split('\n')[1:]:
        if '\t' not in line:
            continue
        name, ot_id = line.split('\t', 1)
        name_to_id[name.strip()] = ot_id.strip()

    now = time.strftime('%Y-%m-%d %H:%M:%S')

    print("\n📦 步骤 3/5: 向数据库插入 OT、属性并创建 backing 表...")
    for ot in NEW_OTS:
        parent_cn = ot.get('parentObjectTypeName')
        parent_en = name_to_id.get(parent_cn) if parent_cn else None
        if parent_cn and not parent_en:
            print(f"  ❌ 未找到父 OT {parent_cn}，跳过 {ot['nameCn']}")
            continue
        if insert_ot_to_db(ot, now, parent_en):
            print(f"  ✅ 插入 OT: {ot['nameCn']} ({ot['nameEn']})")
            if insert_properties_to_db(ot):
                print(f"     ✅ 插入 {len(ot.get('properties', []))} 个属性")
        if create_backing_table(ot['nameEn']):
            print(f"     ✅ 创建表: {ot['nameEn']}")

    print("\n🔧 步骤 4/5: 修复 properties.base_column 并补齐核心属性...")
    res = subprocess.run([sys.executable, "fix_property_base_columns.py"], capture_output=True, text=True)
    print(res.stdout[-800:] if len(res.stdout) > 800 else res.stdout)
    if res.returncode != 0:
        print(res.stderr[-500:])

    print("\n📦 步骤 5/5: 导入 fact_tables 中的实例...")
    res = subprocess.run([sys.executable, "import_semiconductor_fact_tables.py"], capture_output=True, text=True)
    print(res.stdout[-1500:] if len(res.stdout) > 1500 else res.stdout)
    if res.returncode != 0:
        print(res.stderr[-500:])

    print("\n✅ 全部完成")


if __name__ == '__main__':
    main()
