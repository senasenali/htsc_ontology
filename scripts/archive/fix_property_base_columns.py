#!/usr/bin/env python3
"""
修复半导体项目 properties.base_column 为空的问题，并补齐核心属性（名称/唯一标识/描述）。
同时根据属性映射在已存在的 backing 表中添加对应列，使实例 API 能正常查询。
"""
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"
ONTOLOGY_JSON = "数据库/semiconductor_ontology_before_v3_merge.json"


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


def slug_col(s):
    s = re.sub(r'[^\w\s-]', '', str(s)).strip()
    s = re.sub(r'[-\s]+', '_', s)
    s = re.sub(r'_+', '_', s).strip('_')
    return s.lower()[:64]


def data_type_sql(dt):
    t = str(dt or 'string').lower()
    if t in ('int', 'integer'):
        return 'BIGINT'
    if t in ('float', 'double', 'number', 'numeric'):
        return 'DOUBLE'
    if t == 'boolean':
        return 'TINYINT'
    if t in ('date', 'datetime'):
        return 'DATETIME'
    if t in ('text'):
        return 'TEXT'
    return 'VARCHAR(500)'


def load_ot_meta():
    r = run_sql(
        f"SELECT id, name, backing_dataset FROM object_types WHERE project_id='{PROJECT_ID}'",
        "查询 OT"
    )
    if not r:
        sys.exit(1)
    by_name = {}
    by_id = {}
    for line in r.stdout.strip().split('\n')[1:]:
        parts = line.split('\t', 2)
        if len(parts) < 2:
            continue
        ot_id = parts[0].strip()
        name = parts[1].strip()
        backing = parts[2].strip() if len(parts) > 2 else ''
        by_name[name] = ot_id
        by_id[ot_id] = {'name': name, 'backing': backing}
    return by_name, by_id


def main():
    by_name, by_id = load_ot_meta()
    print(f"📖 加载 {len(by_name)} 个 OT")

    with open(ONTOLOGY_JSON, 'r', encoding='utf-8') as f:
        ontology = json.load(f)

    stats = {'props_updated': 0, 'core_inserted': 0, 'cols_added': 0, 'skipped_ot': 0}

    # 预先获取现有属性，避免重复插入
    r = run_sql(
        f"SELECT object_type_id, name FROM properties WHERE project_id='{PROJECT_ID}'",
        "查询属性"
    )
    existing_props = set()
    if r:
        for line in r.stdout.strip().split('\n')[1:]:
            if '\t' in line:
                ot_id, name = line.split('\t', 1)
                existing_props.add((ot_id.strip(), name.strip()))

    for ot in ontology.get('objectType', []):
        ot_name_cn = ot.get('nameCn', '').strip()
        ot_id = by_name.get(ot_name_cn)
        if not ot_id:
            print(f"  ⚠️ 未找到 OT: {ot_name_cn}")
            stats['skipped_ot'] += 1
            continue

        backing = by_id[ot_id]['backing']

        # 1) 为已有属性设置 base_column
        updates = []
        for prop in ot.get('properties', []):
            prop_cn = prop.get('propertyCn', '').strip()
            prop_en = prop.get('propertyEn', '').strip()
            if not prop_cn:
                continue
            base_col = slug_col(prop_en) if prop_en else slug_col(prop_cn)
            if not base_col:
                continue
            updates.append((prop_cn, base_col, prop.get('dataType', 'string')))

        for prop_cn, base_col, dt in updates:
            if (ot_id, prop_cn) not in existing_props:
                continue
            sql = (
                f"UPDATE properties SET base_column='{escape(base_col)}', "
                f"type='{escape(str(dt))}' "
                f"WHERE object_type_id='{escape(ot_id)}' AND name='{escape(prop_cn)}' "
                f"AND project_id='{PROJECT_ID}'"
            )
            if run_sql(sql, f"更新属性 {ot_id}.{prop_cn}"):
                stats['props_updated'] += 1

        # 2) 补齐核心属性
        core_props = [
            ('名称', 'name', 'string', 0),
            ('唯一标识', 'unique_id', 'string', 1),
            ('描述', 'description', 'text', 0),
        ]
        for prop_cn, base_col, dt, is_pk in core_props:
            if (ot_id, prop_cn) in existing_props:
                # 只更新 base_column / 主键
                sql = (
                    f"UPDATE properties SET base_column='{escape(base_col)}', "
                    f"is_primary_key={is_pk}, type='{escape(dt)}' "
                    f"WHERE object_type_id='{escape(ot_id)}' AND name='{escape(prop_cn)}' "
                    f"AND project_id='{PROJECT_ID}'"
                )
                run_sql(sql, f"更新核心属性 {ot_id}.{prop_cn}")
                continue
            prop_id = f"p_{ot_id}_{base_col}"
            sql = (
                f"INSERT INTO properties (id, object_type_id, name, type, description, "
                f"is_primary_key, base_column, sort_order, project_id) VALUES ("
                f"'{escape(prop_id)}', '{escape(ot_id)}', '{escape(prop_cn)}', "
                f"'{escape(dt)}', '', {is_pk}, '{escape(base_col)}', "
                f"999, '{PROJECT_ID}')"
            )
            if run_sql(sql, f"插入核心属性 {ot_id}.{prop_cn}"):
                stats['core_inserted'] += 1
                existing_props.add((ot_id, prop_cn))

        # 3) 在 backing 表中添加列
        if not backing:
            continue

        # 获取表已有列
        col_r = run_sql(
            f"SELECT COLUMN_NAME FROM information_schema.columns "
            f"WHERE table_schema='ontology' AND table_name='{escape(backing)}'",
            f"查询 {backing} 列"
        )
        existing_cols = set()
        if col_r:
            existing_cols = {line.strip().lower() for line in col_r.stdout.strip().split('\n')[1:] if line.strip()}

        all_cols = []
        for prop in ot.get('properties', []):
            prop_cn = prop.get('propertyCn', '').strip()
            prop_en = prop.get('propertyEn', '').strip()
            if not prop_cn:
                continue
            base_col = slug_col(prop_en) if prop_en else slug_col(prop_cn)
            if base_col:
                all_cols.append((base_col, prop.get('dataType', 'string')))
        for _, base_col, dt, _ in core_props:
            all_cols.append((base_col, dt))

        for base_col, dt in all_cols:
            if base_col.lower() in existing_cols:
                continue
            sql_type = data_type_sql(dt)
            sql = (
                f"ALTER TABLE `{escape(backing)}` ADD COLUMN `{escape(base_col)}` {sql_type} "
                f"NULL DEFAULT NULL"
            )
            if run_sql(sql, f"{backing} 添加列 {base_col}"):
                stats['cols_added'] += 1

    print("\n✅ 完成")
    print(f"  更新属性: {stats['props_updated']}")
    print(f"  新增核心属性: {stats['core_inserted']}")
    print(f"  新增列: {stats['cols_added']}")
    print(f"  跳过 OT: {stats['skipped_ot']}")


if __name__ == '__main__':
    main()
