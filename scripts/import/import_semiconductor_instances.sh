#!/bin/bash
# 导入半导体项目实例数据
# 会先清理该项目在 link_instance_data 中的旧数据，然后导入 backing 表和 link_instance_data
#
# 用法: ./import_semiconductor_instances.sh <sql文件> [数据库名] [mysql用户] [mysql密码] [项目ID]
#
# 示例:
#   ./import_semiconductor_instances.sh ../../semiconductor_instances_project_1780997325389.sql
#   ./import_semiconductor_instances.sh ./semiconductor_instances_project_1780997325389.sql ontology root 12345678 project_1780997325389

set -euo pipefail

SQL_FILE="${1:?请指定要导入的实例 SQL 文件路径}"
DB="${2:-ontology}"
USER="${3:-root}"
PASS="${4:-12345678}"
PROJECT_ID="${5:-project_1780997325389}"

if [[ ! -f "$SQL_FILE" ]]; then
  echo "❌ 文件不存在: $SQL_FILE"
  exit 1
fi

echo "准备导入实例数据 ${SQL_FILE} 到数据库 ${DB} 的项目 ${PROJECT_ID} ..."
echo ""

# 清理该项目在 link_instance_data 中的旧数据
# backing 表会在 SQL 中通过 DROP TABLE IF EXISTS + CREATE TABLE 自动重建
echo "正在清理项目 ${PROJECT_ID} 在 link_instance_data 中的旧数据..."
mysql -u "$USER" -p"$PASS" "$DB" <<SQL
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM link_instance_data
WHERE link_type_id COLLATE utf8mb4_unicode_ci IN (
  SELECT id FROM link_types WHERE project_id = '${PROJECT_ID}'
);

SET FOREIGN_KEY_CHECKS = 1;
SQL

echo "✅ link_instance_data 旧数据清理完成"
echo ""

# 导入实例数据 SQL（包含 backing 表重建 + link_instance_data 插入）
echo "正在导入实例数据..."
mysql -u "$USER" -p"$PASS" "$DB" < "$SQL_FILE"

echo "✅ 实例数据导入完成"
echo ""
echo "导入后统计:"

STATS_SQL="SELECT 'link_instance_data' as table_name, COUNT(*) as cnt FROM ${DB}.link_instance_data WHERE link_type_id COLLATE utf8mb4_unicode_ci IN (SELECT id FROM ${DB}.link_types WHERE project_id='${PROJECT_ID}')"

BACKING_TABLES=$(mysql -u "$USER" -p"$PASS" -N -B -e "
  SELECT DISTINCT backing_dataset
  FROM ${DB}.object_types
  WHERE project_id='${PROJECT_ID}' AND backing_dataset != ''
  ORDER BY backing_dataset;
" 2>/dev/null)

for tbl in $BACKING_TABLES; do
  STATS_SQL="${STATS_SQL} UNION ALL SELECT '${tbl}', COUNT(*) FROM ${DB}.${tbl}"
done
STATS_SQL="${STATS_SQL};"

mysql -u "$USER" -p"$PASS" "$DB" -e "$STATS_SQL" 2>/dev/null | sort -t$'\t' -k2 -nr
