#!/usr/bin/env python3
"""
导入 data/instances/fact_tables/ 下的补充数据：
1. 含 nameCn/objectTypeName 的事实表 → 作为对应 OT 的实例导入（支持 property.* 列）。
2. semiconductor_instance_seed.csv → 作为 link_instance_data 关系导入（公司→产品）。
其余市场/价格/毛利类事实表因缺少目标实例 ID，当前跳过并记录。
"""
import csv
import json
import os
import re
import subprocess
import sys
import tempfile
from collections import defaultdict
from pathlib import Path

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"
FACT_DIR = Path("../../data/instances/fact_tables")
SEED_FILE = "semiconductor_instance_seed.csv"


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


def slugify(s):
    if not s:
        return ""
    s = re.sub(r'[^a-z0-9\-_]+', '_', str(s).strip().lower())
    return re.sub(r'_+', '_', s).strip('_')


def load_ot_meta():
    r = run_sql(
        f"SELECT id, name, backing_dataset FROM object_types WHERE project_id='{PROJECT_ID}'",
        "查询 OT"
    )
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


def load_properties():
    """返回 {ot_id: {property_name: (base_column, data_type)}}"""
    r = run_sql(
        f"SELECT object_type_id, name, base_column, type FROM properties "
        f"WHERE project_id='{PROJECT_ID}' AND base_column IS NOT NULL AND base_column <> ''",
        "查询属性"
    )
    props = defaultdict(dict)
    for line in r.stdout.strip().split('\n')[1:]:
        parts = line.split('\t', 3)
        if len(parts) < 3:
            continue
        ot_id = parts[0].strip()
        name = parts[1].strip()
        base_col = parts[2].strip()
        data_type = parts[3].strip() if len(parts) > 3 else 'string'
        props[ot_id][name] = (base_col, data_type)
    return props


def load_link_types():
    """返回 {target_ot_name: link_type_row} 用于公司生产供给类关系"""
    r = run_sql(
        f"SELECT id, name, source_object_id, target_object_id FROM link_types WHERE project_id='{PROJECT_ID}'",
        "查询 link types"
    )
    lts = []
    for line in r.stdout.strip().split('\n')[1:]:
        parts = line.split('\t', 3)
        if len(parts) < 4:
            continue
        lt_id, name, src, tgt = [p.strip() for p in parts]
        lts.append({'id': lt_id, 'name': name, 'source': src, 'target': tgt})
    return lts


def get_existing_unique_ids(table_name):
    r = run_sql(f"SELECT unique_id FROM `{escape(table_name)}`", f"查询 {table_name} unique_id")
    ids = set()
    if r:
        ids = {line.strip() for line in r.stdout.strip().split('\n')[1:] if line.strip()}
    return ids


def import_instance_fact(csv_path, ot_id, ot_name, backing, props):
    """导入形如 nameCn,nameEn,objectTypeName,description,property.* 的事实表"""
    with open(csv_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        return 0, 0

    existing_ids = get_existing_unique_ids(backing)
    local_seen = defaultdict(int)
    values_list = []

    # 核心列
    core_cols = ['name', 'unique_id', 'description']
    # property.* 列映射：CSV 中的英文键通常与 base_column 一致
    ot_props = props.get(ot_id, {})
    prop_col_map = {}
    sample = rows[0]
    for col in sample.keys():
        if col.startswith('property.'):
            prop_name = col[len('property.'):].strip()
            # 匹配 base_column（英文）
            for pname, (base_col, data_type) in ot_props.items():
                if base_col == prop_name:
                    prop_col_map[col] = (base_col, data_type)
                    break

    for idx, row in enumerate(rows, start=1):
        name_cn = row.get('nameCn', '').strip()
        name_en = row.get('nameEn', '').strip()
        description = row.get('description', '').strip()
        if not name_cn and not name_en:
            continue

        uid = slugify(name_en) if name_en else slugify(name_cn)
        if not uid:
            uid = f"{ot_id}_{idx}"
        local_seen[uid] += 1
        if local_seen[uid] > 1:
            uid = f"{uid}_{local_seen[uid]}"
        if uid in existing_ids:
            base = uid
            c = 1
            while f"{base}_{c}" in existing_ids:
                c += 1
            uid = f"{base}_{c}"
        existing_ids.add(uid)

        name = escape(name_cn or name_en)
        desc = escape(description)
        uid_esc = escape(uid)

        # 动态属性列
        extra_cols = []
        extra_vals = []
        for src_col, (base_col, data_type) in prop_col_map.items():
            val = row.get(src_col, '').strip()
            extra_cols.append(f"`{escape(base_col)}`")
            if val == '' and data_type.lower() in ('number', 'double', 'float', 'int', 'integer', 'numeric'):
                extra_vals.append("NULL")
            else:
                extra_vals.append(f"'{escape(val)}'")

        col_list = ['`name`', '`unique_id`', '`description`'] + extra_cols
        val_list = [f"'{name}'", f"'{uid_esc}'", f"'{desc}'"] + extra_vals
        values_list.append(f"({', '.join(val_list)})")

    if not values_list:
        return 0, 0

    # ON DUPLICATE KEY UPDATE 保证重复 unique_id 时更新属性值
    update_clause = ", ".join(
        f"{c} = VALUES({c})" for c in col_list if c != '`unique_id`'
    )
    inserted = 0
    BATCH = 100
    for i in range(0, len(values_list), BATCH):
        chunk = values_list[i:i+BATCH]
        sql = (
            f"INSERT INTO `{escape(backing)}` ({', '.join(col_list)}) VALUES "
            + ", ".join(chunk)
        )
        if update_clause:
            sql += f" ON DUPLICATE KEY UPDATE {update_clause}"
        if run_sql(sql, f"插入/更新 {backing} batch {i//BATCH + 1}"):
            inserted += len(chunk)

    return inserted, 0


def import_seed_links(seed_path, ot_by_name, ot_by_id):
    """导入 semiconductor_instance_seed.csv 到公司-产品 link_instance_data"""
    with open(seed_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        return 0, 0

    lts = load_link_types()
    # 公司 OT 固定为 company
    company_ot = ot_by_name.get('公司')
    if not company_ot:
        print("  ⚠️ 未找到 公司 OT，跳过 seed 链接")
        return 0, len(rows)
    company_table = ot_by_id[company_ot]['backing']

    # 加载公司名称 -> unique_id
    r = run_sql(f"SELECT name, unique_id FROM `{escape(company_table)}`", "加载公司实例")
    company_by_name = {}
    if r:
        for line in r.stdout.strip().split('\n')[1:]:
            if '\t' not in line:
                continue
            name, uid = line.split('\t', 1)
            company_by_name[name.strip().lower()] = uid.strip()

    # 按目标 OT 缓存实例 name -> unique_id
    target_cache = {}

    # 查询现有链接去重
    r = run_sql("SELECT link_type_id, source_instance_id, target_instance_id FROM link_instance_data", "查询现有链接")
    existing_links = set()
    if r:
        for line in r.stdout.strip().split('\n')[1:]:
            parts = line.split('\t', 2)
            if len(parts) == 3:
                existing_links.add(tuple(p.strip() for p in parts))

    inserted = 0
    skipped = 0
    for row in rows:
        enterprise = row.get('enterprise', '').strip()
        target_obj_name = row.get('standard_product', '').strip()
        target_inst_name = row.get('enterprise_object', '').strip()

        if not enterprise or not target_obj_name or not target_inst_name:
            skipped += 1
            continue

        src_uid = company_by_name.get(enterprise.lower())
        if not src_uid:
            print(f"  ⚠️ 未找到公司实例: {enterprise}")
            skipped += 1
            continue

        target_ot_id = ot_by_name.get(target_obj_name)
        if not target_ot_id:
            print(f"  ⚠️ 未找到目标 OT: {target_obj_name}")
            skipped += 1
            continue

        # 找到对应 link_type：source=公司, target=target_ot_id
        lt = next((x for x in lts if x['source'] == company_ot and x['target'] == target_ot_id), None)
        if not lt:
            print(f"  ⚠️ 未找到 link type: 公司 -> {target_obj_name}")
            skipped += 1
            continue

        # 加载目标实例
        if target_ot_id not in target_cache:
            tgt_table = ot_by_id[target_ot_id]['backing']
            if not tgt_table:
                skipped += 1
                continue
            r = run_sql(f"SELECT name, unique_id FROM `{escape(tgt_table)}`", f"加载 {target_obj_name} 实例")
            mapping = {}
            if r:
                for line in r.stdout.strip().split('\n')[1:]:
                    if '\t' not in line:
                        continue
                    name, uid = line.split('\t', 1)
                    mapping[name.strip().lower()] = uid.strip()
            target_cache[target_ot_id] = mapping

        tgt_uid = target_cache[target_ot_id].get(target_inst_name.lower())
        if not tgt_uid:
            print(f"  ⚠️ 未找到目标实例 {target_obj_name}/{target_inst_name}")
            skipped += 1
            continue

        key = (lt['id'], src_uid, tgt_uid)
        if key in existing_links:
            skipped += 1
            continue
        existing_links.add(key)

        sql = (
            f"INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id) VALUES ("
            f"'{escape(lt['id'])}', '{escape(src_uid)}', '{escape(tgt_uid)}')"
        )
        if run_sql(sql, f"插入链接 {lt['name']}"):
            inserted += 1
        else:
            skipped += 1

    return inserted, skipped


def main():
    ot_by_name, ot_by_id = load_ot_meta()
    props = load_properties()
    print(f"📖 加载 {len(ot_by_name)} 个 OT，{sum(len(v) for v in props.values())} 个有 base_column 的属性\n")

    stats = {
        'instance_files': 0,
        'instance_rows_inserted': 0,
        'link_rows_inserted': 0,
        'skipped_files': 0,
    }

    files = sorted(FACT_DIR.glob("*.csv"))
    for csv_path in files:
        file_name = csv_path.name

        # 1) seed 链接
        if file_name == SEED_FILE:
            print(f"🔗 {file_name} -> link_instance_data")
            ins, skp = import_seed_links(csv_path, ot_by_name, ot_by_id)
            stats['link_rows_inserted'] += ins
            print(f"   插入 {ins} 条，跳过 {skp} 条")
            continue

        with open(csv_path, 'r', encoding='utf-8-sig') as f:
            reader = csv.DictReader(f)
            try:
                first = next(reader)
            except StopIteration:
                continue

        # 2) 实例型事实表
        if 'nameCn' in first:
            ot_name = first.get('objectTypeName', '').strip() or file_name.replace('.csv', '')
            ot_id = ot_by_name.get(ot_name)
            if not ot_id:
                print(f"⏭️  {file_name} -> 无对应 OT ({ot_name})，跳过")
                stats['skipped_files'] += 1
                continue
            backing = ot_by_id[ot_id]['backing']
            if not backing:
                print(f"⏭️  {file_name} -> OT {ot_name} 无 backing_dataset，跳过")
                stats['skipped_files'] += 1
                continue

            print(f"📦 {file_name} -> {ot_name} ({backing})")
            ins, _ = import_instance_fact(csv_path, ot_id, ot_name, backing, props)
            stats['instance_rows_inserted'] += ins
            stats['instance_files'] += 1
            print(f"   插入 {ins} 条实例")
            continue

        # 3) 其他（价格/毛利/产能等）暂跳过
        print(f"⏭️  {file_name} -> 非实例/非链接事实表，跳过")
        stats['skipped_files'] += 1

    print("\n" + "=" * 60)
    print("📊 fact_tables 导入完成")
    print(f"  实例文件数: {stats['instance_files']}")
    print(f"  实例插入数: {stats['instance_rows_inserted']}")
    print(f"  链接插入数: {stats['link_rows_inserted']}")
    print(f"  跳过文件数: {stats['skipped_files']}")


if __name__ == '__main__':
    main()
