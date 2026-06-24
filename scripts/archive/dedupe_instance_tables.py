#!/usr/bin/env python3
"""
清理 backing 表中的重复实例（按 name 重复），保留 id 最小的一条。
"""
import subprocess
import tempfile
import os

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"


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


def main():
    r = run_sql(
        f"SELECT backing_dataset FROM object_types WHERE project_id='{PROJECT_ID}' AND backing_dataset <> ''",
        "查询 backing 表"
    )
    tables = [line.strip() for line in r.stdout.strip().split('\n')[1:] if line.strip()]
    total_deleted = 0
    for table in tables:
        # 查找重复 name 数量
        r = run_sql(
            f"SELECT name, COUNT(*) AS c FROM `{table}` GROUP BY name HAVING c > 1 LIMIT 1",
            f"检查 {table} 重复"
        )
        if not r or len(r.stdout.strip().split('\n')) <= 1:
            continue
        # 删除重复，保留最小 id
        del_sql = (
            f"DELETE t1 FROM `{table}` t1 "
            f"INNER JOIN `{table}` t2 ON t1.name = t2.name AND t1.id > t2.id"
        )
        del_r = run_sql(del_sql, f"清理 {table} 重复")
        if del_r:
            # 通过再次计数估算删除条数
            r2 = run_sql(
                f"SELECT COUNT(*) FROM `{table}` WHERE unique_id LIKE '%\\_1'",
                f"统计 {table} 后缀"
            )
            if r2:
                count = int(r2.stdout.strip().split('\n')[1])
                if count:
                    print(f"  🧹 {table}: 发现重复实例，已清理（剩余 _1 后缀 {count} 条）")
                    total_deleted += count
    print(f"\n✅ 完成，共涉及 {total_deleted} 条潜在重复记录")


if __name__ == '__main__':
    main()
