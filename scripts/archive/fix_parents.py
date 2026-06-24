#!/usr/bin/env python3
"""
修复 177 个新 OTs 的 parentObjectType 引用。
"""
import json
import subprocess
import sys

MYSQL_CMD = "mysql -u root -p12345678 ontology"
PROJECT_ID = "project_1780997325389"
JSON_PATH = "semiconductor_ontology.json"

with open(JSON_PATH, 'r') as f:
    data = json.load(f)

# 中文名 → nameEn 映射
cn_to_en = {}
for ot in data["objectType"]:
    cn_to_en[ot["nameCn"]] = ot["nameEn"]
cn_to_en["DRAM"] = "memory_dram"

# 为每个 OT 生成 SQL UPDATE
updates = []
for ot in data["objectType"]:
    parent_cn = ot.get("parentObjectTypeName")
    if not parent_cn:
        continue
    parent_en = cn_to_en.get(parent_cn)
    if not parent_en:
        continue
    child_id = ot["nameEn"]
    if child_id == "dram":
        child_id = "memory_dram"
    updates.append((child_id, parent_en))

print(f"需要修复父节点的 OT: {len(updates)} 个")

# 分批执行
BATCH_SIZE = 50
for i in range(0, len(updates), BATCH_SIZE):
    batch = updates[i:i+BATCH_SIZE]
    cases = " ".join(f"WHEN '{child}' THEN '{parent}'" for child, parent in batch)
    ids = ", ".join(f"'{child}'" for child, parent in batch)
    sql = f"UPDATE object_types SET parent_object_type = CASE id {cases} END WHERE id IN ({ids}) AND project_id='{PROJECT_ID}'"
    result = subprocess.run(f'{MYSQL_CMD} -e "{sql}"', shell=True, capture_output=True, text=True)
    if result.returncode == 0:
        print(f"  ✅ batch {i//BATCH_SIZE+1}: {len(batch)} OT")
    else:
        print(f"  ❌ batch {i//BATCH_SIZE+1}: {result.stderr[:200]}")

# 验证
result = subprocess.run(
    f'{MYSQL_CMD} -e "SELECT CASE WHEN parent_object_type IS NULL OR parent_object_type=\'\' THEN \'no_parent\' ELSE \'has_parent\' END AS status, COUNT(*) AS cnt FROM object_types WHERE project_id=\'{PROJECT_ID}\' GROUP BY 1"',
    shell=True, capture_output=True, text=True
)
print(f"\n验证结果:")
print(result.stdout)
