#!/bin/bash
# 导入半导体项目元数据（OT / LT / 属性），会先清理目标项目旧元数据
# 用法: ./import_semiconductor_metadata.sh <sql文件> [数据库名] [mysql用户] [mysql密码] [项目ID]
#
# 示例:
#   ./import_semiconductor_metadata.sh ../../semiconductor_metadata_project_1780997325389.sql
#   ./import_semiconductor_metadata.sh ./semiconductor_metadata_project_1780997325389.sql ontology root 12345678 project_1780997325389

set -euo pipefail

SQL_FILE="${1:?请指定要导入的 SQL 文件路径}"
DB="${2:-ontology}"
USER="${3:-root}"
PASS="${4:-12345678}"
PROJECT_ID="${5:-project_1780997325389}"

if [[ ! -f "$SQL_FILE" ]]; then
  echo "❌ 文件不存在: $SQL_FILE"
  exit 1
fi

echo "准备导入 ${SQL_FILE} 到数据库 ${DB} 的项目 ${PROJECT_ID} ..."
echo ""

# 可选：先备份（取消注释可启用）
# BACKUP_FILE="backup_before_import_$(date +%Y%m%d_%H%M%S).sql"
# echo "正在备份数据库到 ${BACKUP_FILE} ..."
# mysqldump -u "$USER" -p"$PASS" "$DB" > "$BACKUP_FILE"
# echo "✅ 备份完成"

# 清理旧半导体项目元数据（保留其他项目）
echo "正在清理项目 ${PROJECT_ID} 的旧元数据..."
mysql -u "$USER" -p"$PASS" "$DB" <<SQL
SET FOREIGN_KEY_CHECKS = 0;

-- 清理与 link_types 相关的映射和实例（避免外键冲突）
DELETE FROM interface_link_type_constraint_mapping
WHERE link_type_id IN (SELECT id FROM link_types WHERE project_id = '${PROJECT_ID}');

DELETE FROM link_instance_data
WHERE link_type_id IN (SELECT id FROM link_types WHERE project_id = '${PROJECT_ID}');

DELETE FROM link_types WHERE project_id = '${PROJECT_ID}';

-- 清理与 object_types 相关的映射和属性
DELETE FROM object_type_interfaces_mapping
WHERE object_type_id IN (SELECT id FROM object_types WHERE project_id = '${PROJECT_ID}');

DELETE FROM properties
WHERE object_type_id IN (SELECT id FROM object_types WHERE project_id = '${PROJECT_ID}');

DELETE FROM object_types WHERE project_id = '${PROJECT_ID}';

-- 清理项目记录（SQL 文件中会重新插入）
DELETE FROM projects WHERE id = '${PROJECT_ID}';

SET FOREIGN_KEY_CHECKS = 1;
SQL

echo "✅ 旧元数据清理完成"
echo ""

# 导入新元数据
echo "正在导入新元数据..."
mysql -u "$USER" -p"$PASS" "$DB" < "$SQL_FILE"

echo "✅ 导入完成"
echo ""
echo "导入后统计:"
mysql -u "$USER" -p"$PASS" "$DB" -e "
SELECT 'projects' as table_name, COUNT(*) as cnt FROM projects WHERE id='${PROJECT_ID}'
UNION ALL SELECT 'object_types', COUNT(*) FROM object_types WHERE project_id='${PROJECT_ID}'
UNION ALL SELECT 'link_types', COUNT(*) FROM link_types WHERE project_id='${PROJECT_ID}'
UNION ALL SELECT 'properties', COUNT(*) FROM properties WHERE project_id='${PROJECT_ID}';
" 2>/dev/null
