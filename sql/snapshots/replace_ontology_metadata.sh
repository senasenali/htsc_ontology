#!/bin/bash
# 用法: ./replace_ontology_metadata.sh <目标项目ID> [目标数据库名] [mysql用户] [mysql密码]
# 示例: ./replace_ontology_metadata.sh project_1780997325389 ontology root 12345678
set -e
TARGET_PROJECT_ID=${1:-project_1780997325389}
DB=${2:-ontology}
USER=${3:-root}
PASS=${4:-12345678}
SRC_PROJECT_ID=project_1780997325389

SCRIPT_FILE=$(mktemp)
cat > "$SCRIPT_FILE" <<SQL
SET FOREIGN_KEY_CHECKS = 0;

-- 先清理目标项目旧的 ontology 元数据
DELETE FROM interface_link_type_constraint_mapping
WHERE link_type_id IN (SELECT id FROM link_types WHERE project_id = '${TARGET_PROJECT_ID}');

DELETE FROM link_instance_data
WHERE link_type_id IN (SELECT id FROM link_types WHERE project_id = '${TARGET_PROJECT_ID}');

DELETE FROM link_types WHERE project_id = '${TARGET_PROJECT_ID}';

DELETE FROM object_type_interfaces_mapping
WHERE object_type_id IN (SELECT id FROM object_types WHERE project_id = '${TARGET_PROJECT_ID}');

DELETE FROM properties
WHERE object_type_id IN (SELECT id FROM object_types WHERE project_id = '${TARGET_PROJECT_ID}');

DELETE FROM object_types WHERE project_id = '${TARGET_PROJECT_ID}';

SQL

# 把源 dump 里的 project_id 替换成目标 project_id，并追加到脚本
sed "s/${SRC_PROJECT_ID}/${TARGET_PROJECT_ID}/g" "$(dirname "$0")/ontology_metadata_project_1780997325389.sql" >> "$SCRIPT_FILE"

cat >> "$SCRIPT_FILE" <<SQL
SET FOREIGN_KEY_CHECKS = 1;
SQL

echo "-- 生成替换脚本: $SCRIPT_FILE"
mysql -u "$USER" -p"$PASS" "$DB" < "$SCRIPT_FILE"
echo "✅ 已把项目 ${SRC_PROJECT_ID} 的 OT/LT/Property 元数据替换到 ${TARGET_PROJECT_ID}"
rm -f "$SCRIPT_FILE"
