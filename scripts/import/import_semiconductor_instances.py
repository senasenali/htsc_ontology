#!/usr/bin/env python3
"""
半导体项目实例数据导入脚本
根据 data/instances/manifest.csv 中列出的 full_instance CSV，
将实例数据导入到对应 Object Type 的 backing 表中。

前置条件：
- 半导体项目 OT/LT 已通过 import_semiconductor_before_v3.py 导入
- MySQL 服务运行，且 ontology 数据库可访问

执行流程：
  1. 读取 data/instances/manifest.csv，获取所有 full_instance CSV 文件清单
  2. 对每个 CSV：
     a. 根据 objectTypeName 匹配 object_types 表中的 OT
     b. 若 OT.backing_dataset 为空，则设置为 snake_case 的 OT id
     c. 确保 backing 表存在（id/name/unique_id/description/created_at/updated_at）
     d. 将 CSV 中的每一行转换为实例记录并插入
  3. 输出导入统计与错误清单
"""
import csv
import json
import os
import re
import subprocess
import sys
import tempfile
import time
from collections import defaultdict
from pathlib import Path

# ── 配置 ─────────────────────────────────────────────────────────────────────

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"
MANIFEST_PATH = "../../data/instances/manifest.csv"
BASE_DIR = "../../data/instances/full_instance"

# ── 辅助函数 ─────────────────────────────────────────────────────────────────

def run_sql(sql, description=""):
    """执行 SQL 语句（写入临时文件避免 shell 特殊字符问题），返回 subprocess.CompletedProcess"""
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
    """转义 SQL 字符串"""
    if s is None:
        return ""
    return str(s).replace("\\", "\\\\").replace("'", "\\'").replace('"', '\\"')


def to_snake_case(s):
    """将字符串转换为下划线命名，适合作为表名"""
    s = re.sub(r'[^\w\s-]', '', s).strip()
    s = re.sub(r'[-\s]+', '_', s)
    return s.lower()


def slugify(s):
    """生成 unique_id：保留字母数字、下划线、连字符"""
    if not s:
        return ""
    s = str(s).strip().lower()
    s = re.sub(r'[^a-z0-9\-_]+', '_', s)
    s = re.sub(r'_+', '_', s).strip('_')
    return s


def generate_unique_id(name_cn, name_en, ot_id, index):
    """生成唯一标识：优先用 nameEn，否则用 nameCn 的 slug，都不行则用序号"""
    uid = slugify(name_en) if name_en else ""
    if not uid:
        uid = slugify(name_cn)
    if not uid:
        uid = f"{ot_id}_{index}"
    return uid


def table_exists(table_name):
    """检查表是否已存在"""
    r = run_sql(
        f"SELECT 1 FROM information_schema.tables WHERE table_schema='ontology' AND table_name='{escape(table_name)}'",
        f"检查表 {table_name}"
    )
    if not r:
        return False
    return len(r.stdout.strip().split('\n')) > 1


def create_instance_table(table_name):
    """创建实例表（单行 SQL，避免 shell 换行问题）"""
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


def set_backing_dataset(ot_id, table_name):
    """更新 OT 的 backing_dataset"""
    sql = (
        f"UPDATE object_types SET backing_dataset='{escape(table_name)}', "
        f"updated_at=NOW() WHERE id='{escape(ot_id)}' AND project_id='{PROJECT_ID}'"
    )
    return run_sql(sql, f"更新 OT {ot_id} 的 backing_dataset")


# ── Link 实例导入辅助函数 ────────────────────────────────────────────────────

def load_ot_meta():
    """加载 OT 元数据：name->id, id->backing_dataset"""
    r = run_sql(
        f"SELECT id, name, backing_dataset FROM object_types WHERE project_id='{PROJECT_ID}'",
        "查询 OT 元数据"
    )
    by_cn = {}
    by_id = {}
    for line in r.stdout.strip().split('\n')[1:]:
        parts = line.split('\t', 2)
        if len(parts) < 2:
            continue
        ot_id = parts[0].strip()
        name = parts[1].strip()
        backing = parts[2].strip() if len(parts) > 2 else ''
        by_cn[name] = ot_id
        by_id[ot_id] = {'name': name, 'backing': backing}
    return by_cn, by_id


def load_link_types():
    """加载 link_type：name -> {id, source_id, target_id}"""
    r = run_sql(
        f"SELECT id, name, source_object_id, target_object_id FROM link_types WHERE project_id='{PROJECT_ID}'",
        "查询 Link Types"
    )
    lt_by_name = {}
    for line in r.stdout.strip().split('\n')[1:]:
        parts = line.split('\t', 3)
        if len(parts) < 4:
            continue
        lt_id, name, src, tgt = [p.strip() for p in parts]
        lt_by_name[name] = {
            'id': lt_id,
            'source_id': src,
            'target_id': tgt,
        }
    return lt_by_name


def build_name_to_uid(table_name):
    """根据实例名（不区分大小写、去除首尾空格）查找 unique_id，保留最早插入的记录"""
    mapping = {}
    if not table_name:
        return mapping
    r = run_sql(
        f"SELECT name, unique_id FROM `{escape(table_name)}` ORDER BY id ASC",
        f"加载实例名映射 {table_name}"
    )
    if not r:
        return mapping
    for line in r.stdout.strip().split('\n')[1:]:
        if '\t' not in line:
            continue
        name, uid = line.split('\t', 1)
        key = name.strip().lower()
        if key not in mapping:
            mapping[key] = uid.strip()
    return mapping


def import_link_instances(csv_path, file_name, lt_by_name, ot_by_cn, ot_by_id, stats, errors):
    """导入 sourceInstance/targetInstance 形式的 link instance CSV"""
    with open(csv_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        return

    # 获取 linkTypeName（取第一行，回退文件名）
    link_type_name = rows[0].get('linkTypeName', '').strip()
    if not link_type_name:
        link_type_name = file_name.replace('.csv', '')

    lt = lt_by_name.get(link_type_name)
    if not lt:
        print(f"⚠️  跳过（未找到 Link Type）: {file_name} -> {link_type_name}")
        errors.append(f"LINK_TYPE_NOT_FOUND: {file_name} -> {link_type_name}")
        stats['files_skipped'] += 1
        return

    src_ot_id = lt['source_id']
    tgt_ot_id = lt['target_id']
    src_table = ot_by_id.get(src_ot_id, {}).get('backing', '')
    tgt_table = ot_by_id.get(tgt_ot_id, {}).get('backing', '')

    if not src_table or not tgt_table:
        print(f"⚠️  跳过（源/目标 OT 无 backing 表）: {file_name}")
        errors.append(f"NO_BACKING_FOR_LINK: {file_name}")
        stats['files_skipped'] += 1
        return

    src_name_map = build_name_to_uid(src_table)
    tgt_name_map = build_name_to_uid(tgt_table)

    # 查询已有链接去重
    r = run_sql("SELECT link_type_id, source_instance_id, target_instance_id FROM link_instance_data", "查询现有链接")
    existing_links = set()
    if r:
        for line in r.stdout.strip().split('\n')[1:]:
            parts = line.split('\t', 2)
            if len(parts) == 3:
                existing_links.add(tuple(p.strip() for p in parts))

    values = []
    missing = 0
    for row in rows:
        src_name = row.get('sourceInstance', '').strip()
        tgt_name = row.get('targetInstance', '').strip()
        if not src_name or not tgt_name:
            missing += 1
            continue

        src_uid = src_name_map.get(src_name.lower())
        tgt_uid = tgt_name_map.get(tgt_name.lower())
        if not src_uid:
            print(f"  ⚠️ 未找到源实例: {src_name} ({file_name})")
            missing += 1
            continue
        if not tgt_uid:
            print(f"  ⚠️ 未找到目标实例: {tgt_name} ({file_name})")
            missing += 1
            continue

        key = (lt['id'], src_uid, tgt_uid)
        if key in existing_links:
            continue
        existing_links.add(key)
        values.append(
            f"('{escape(lt['id'])}', '{escape(src_uid)}', '{escape(tgt_uid)}')"
        )

    if not values:
        print(f"🔗 {file_name} -> {link_type_name} (无新链接可插入)")
        stats['link_files_processed'] += 1
        return

    inserted = 0
    BATCH_SIZE = 500
    for i in range(0, len(values), BATCH_SIZE):
        chunk = values[i:i + BATCH_SIZE]
        sql = (
            "INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id) VALUES "
            + ",".join(chunk)
        )
        r = run_sql(sql, f"插入链接 {link_type_name} batch {i//BATCH_SIZE + 1}")
        if r:
            inserted += len(chunk)
        else:
            errors.append(f"LINK_INSERT_FAILED: {link_type_name} batch {i//BATCH_SIZE + 1}")

    stats['link_instances_inserted'] += inserted
    stats['link_instances_failed'] += len(values) - inserted
    stats['link_files_processed'] += 1
    print(f"🔗 {file_name} -> {link_type_name}, 插入 {inserted} 条链接, 缺失/重复 {missing + (len(values) - inserted)} 条")


# ── 主流程 ───────────────────────────────────────────────────────────────────

def main():
    start_time = time.time()
    manifest_path = Path(MANIFEST_PATH)
    base_dir = Path(BASE_DIR)

    if not manifest_path.exists():
        print(f"❌ 清单文件不存在: {manifest_path}")
        sys.exit(1)

    # 加载 OT / Link Type 元数据
    print("📖 加载半导体项目 Object Types & Link Types...")
    ot_by_cn, ot_by_id = load_ot_meta()
    lt_by_name = load_link_types()
    print(f"  共加载 {len(ot_by_cn)} 个 OT, {len(lt_by_name)} 个 Link Type")

    # 统计
    stats = {
        'files_processed': 0,
        'files_skipped': 0,
        'instances_inserted': 0,
        'instances_failed': 0,
        'tables_created': 0,
        'ot_updated': 0,
        'link_files_processed': 0,
        'link_instances_inserted': 0,
        'link_instances_failed': 0,
    }
    errors = []

    # 读取清单
    print(f"\n📂 读取清单: {manifest_path}")
    with open(manifest_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        rows = [row for row in reader if row.get('category') == 'full_instance']

    print(f"  共 {len(rows)} 个 full_instance CSV 待处理\n")

    for row in rows:
        file_name = row['file_name']
        csv_path = base_dir / file_name

        if not csv_path.exists():
            print(f"⚠️  跳过（文件不存在）: {file_name}")
            stats['files_skipped'] += 1
            errors.append(f"FILE_MISSING: {file_name}")
            continue

        # 读取 CSV 并判断类型
        with open(csv_path, 'r', encoding='utf-8-sig') as f:
            reader = csv.DictReader(f)
            try:
                first = next(reader)
            except StopIteration:
                print(f"⚠️  跳过（空文件）: {file_name}")
                stats['files_skipped'] += 1
                continue
            instances = [first] + list(reader)

        # ── Link 实例表 ──────────────────────────────────────────────────────
        if 'sourceInstance' in first and 'targetInstance' in first:
            import_link_instances(csv_path, file_name, lt_by_name, ot_by_cn, ot_by_id, stats, errors)
            continue

        # ── 普通实例表 ────────────────────────────────────────────────────────
        # 获取 objectTypeName（取第一行的 objectTypeName，回退到文件名）
        object_type_name = first.get('objectTypeName', '').strip()
        if not object_type_name:
            object_type_name = file_name.replace('.csv', '')

        ot_id = ot_by_cn.get(object_type_name)
        if not ot_id:
            print(f"⚠️  跳过（未找到 OT）: {file_name} -> {object_type_name}")
            stats['files_skipped'] += 1
            errors.append(f"OT_NOT_FOUND: {file_name} -> {object_type_name}")
            continue

        table_name = to_snake_case(ot_id)

        print(f"📦 {file_name} -> OT: {ot_id} ({object_type_name}), 表: {table_name}, 实例: {len(instances)}")

        # 确保 backing_dataset 已设置
        set_backing_dataset(ot_id, table_name)
        stats['ot_updated'] += 1

        # 确保表存在
        if not table_exists(table_name):
            if create_instance_table(table_name):
                stats['tables_created'] += 1
            else:
                errors.append(f"CREATE_TABLE_FAILED: {table_name}")
                continue

        # 收集已存在的 unique_id，用于去重
        existing_r = run_sql(
            f"SELECT unique_id FROM `{escape(table_name)}`",
            f"查询现有 unique_id"
        )
        existing_ids = set()
        if existing_r:
            existing_ids = {line.strip() for line in existing_r.stdout.strip().split('\n')[1:] if line.strip()}

        # 准备 INSERT
        values = []
        local_seen = defaultdict(int)

        for idx, inst in enumerate(instances, start=1):
            name_cn = inst.get('nameCn', '').strip()
            name_en = inst.get('nameEn', '').strip()
            description = inst.get('description', '').strip()

            if not name_cn and not name_en:
                continue

            uid = generate_unique_id(name_cn, name_en, ot_id, idx)

            # 处理同文件内重复
            local_seen[uid] += 1
            if local_seen[uid] > 1:
                uid = f"{uid}_{local_seen[uid]}"

            # 与数据库已有记录重复则跳过，保证幂等
            if uid in existing_ids:
                continue

            existing_ids.add(uid)

            values.append(
                f"('{escape(name_cn or name_en)}','{escape(uid)}','{escape(description)}',NOW(),NOW())"
            )

        if not values:
            print(f"  ⚠️ 无有效实例可插入")
            continue

        # 批量插入
        BATCH_SIZE = 100
        inserted = 0
        for i in range(0, len(values), BATCH_SIZE):
            chunk = values[i:i + BATCH_SIZE]
            sql = (
                f"INSERT INTO `{escape(table_name)}` (name, unique_id, description, created_at, updated_at) VALUES "
                + ",".join(chunk)
            )
            r = run_sql(sql, f"插入 {table_name} batch {i//BATCH_SIZE + 1}")
            if r:
                inserted += len(chunk)
            else:
                errors.append(f"INSERT_FAILED: {table_name} batch {i//BATCH_SIZE + 1}")

        stats['instances_inserted'] += inserted
        stats['instances_failed'] += len(values) - inserted
        stats['files_processed'] += 1

    # ── 汇总 ─────────────────────────────────────────────────────────────────

    elapsed = time.time() - start_time
    print("\n" + "=" * 60)
    print("📊 导入完成统计")
    print("=" * 60)
    print(f"  实例文件数:      {stats['files_processed']}")
    print(f"  链接文件数:      {stats['link_files_processed']}")
    print(f"  跳过文件数:      {stats['files_skipped']}")
    print(f"  新建表数:        {stats['tables_created']}")
    print(f"  更新 OT 数:      {stats['ot_updated']}")
    print(f"  插入实例:        {stats['instances_inserted']}")
    print(f"  失败实例:        {stats['instances_failed']}")
    print(f"  插入链接实例:    {stats['link_instances_inserted']}")
    print(f"  失败链接实例:    {stats['link_instances_failed']}")
    print(f"  耗时:            {elapsed:.1f}s")

    if errors:
        print(f"\n⚠️  错误清单（共 {len(errors)} 条）:")
        for err in errors[:50]:
            print(f"    - {err}")
        if len(errors) > 50:
            print(f"    ... 还有 {len(errors) - 50} 条")


if __name__ == '__main__':
    main()
