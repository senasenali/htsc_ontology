#!/usr/bin/env python3
"""
通过 SQL 批量插入剩余的 link types。
每秒约 100 条，比 API 快得多。
"""
import json
import subprocess
import sys
import time

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"
JSON_PATH = "semiconductor_ontology.json"

# 读取现有 LTs
result = subprocess.run(
    f'{MYSQL_CMD} -e "SELECT id FROM link_types WHERE project_id=\'{PROJECT_ID}\'"',
    shell=True, capture_output=True, text=True
)
existing_lts = set()
for line in result.stdout.strip().split('\n')[1:]:
    if line.strip():
        existing_lts.add(line.strip())
print(f"现有 LT: {len(existing_lts)} 条")

# 读取 JSON
with open(JSON_PATH, 'r') as f:
    data = json.load(f)

# 构建中文名 → nameEn 映射
cn_to_en = {ot["nameCn"]: ot["nameEn"] for ot in data["objectType"]}
cn_to_en["DRAM"] = "memory_dram"

card_map = {"一对多（1:N）": "1:N", "多对多（M:N）": "M:N", "一对一（1:1）": "1:1"}

# 过滤出未导入的 LT
pending = []
for lt in data["linkType"]:
    source_cn = lt["sourceObjectType"]
    target_cn = lt["targetObjectType"]
    source_en = cn_to_en.get(source_cn)
    target_en = cn_to_en.get(target_cn)
    if not source_en or not target_en:
        continue
    lt_id = f"lt_{source_en}_to_{target_en}"
    if lt_id not in existing_lts:
        pending.append(lt)

print(f"待导入: {len(pending)} 条")

if not pending:
    print("✅ 全部已完成")
    sys.exit(0)

# 批量 SQL 插入
now = time.strftime('%Y-%m-%d %H:%M:%S')
BATCH_SIZE = 200

for i in range(0, len(pending), BATCH_SIZE):
    batch = pending[i:i + BATCH_SIZE]
    values = []
    for lt in batch:
        source_en = cn_to_en[lt["sourceObjectType"]]
        target_en = cn_to_en[lt["targetObjectType"]]
        lt_id = f"lt_{source_en}_to_{target_en}"
        name = lt["name"].replace("'", "\\'")
        category = lt.get("linkTypeCategory", "")
        cardinality = card_map.get(lt.get("radix", ""), "N:N")
        desc = lt.get("description", "").replace("'", "\\'")

        values.append(
            f"('{lt_id}','{name}','{source_en}','{target_en}',"
            f"'{cardinality}','{category}','{desc}','{PROJECT_ID}',"
            f"'active','{now}','{now}')"
        )

    sql = (
        f"INSERT INTO link_types (id, name, source_object_id, target_object_id, "
        f"cardinality, link_category, description, project_id, "
        f"status, created_at, updated_at) VALUES "
        + ",".join(values)
    )

    result = subprocess.run(
        f'{MYSQL_CMD} -e "{sql}"',
        shell=True, capture_output=True, text=True
    )

    if result.returncode == 0:
        done = min(i + BATCH_SIZE, len(pending))
        print(f"  ✅ {done}/{len(pending)} ({done*100//len(pending)}%)")
    else:
        error = result.stderr[:200]
        print(f"  ❌ batch {i//BATCH_SIZE+1}: {error}")

    time.sleep(0.1)

# 验证
result = subprocess.run(
    f'{MYSQL_CMD} -e "SELECT COUNT(*) AS total FROM link_types WHERE project_id=\'{PROJECT_ID}\'"',
    shell=True, capture_output=True, text=True
)
total = result.stdout.strip().split('\n')[-1]
print(f"\n✅ 导入完成! 总计 {total} 条 link types")
