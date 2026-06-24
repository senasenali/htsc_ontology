#!/bin/bash
# 导出半导体项目元数据（OT / LT / 属性），不含实例数据
# 用法: ./export_semiconductor_metadata.sh [数据库名] [mysql用户] [mysql密码] [项目ID] [输出文件]
#
# 示例:
#   ./export_semiconductor_metadata.sh
#   ./export_semiconductor_metadata.sh ontology root 12345678 project_1780997325389 ./semiconductor_metadata.sql

set -euo pipefail

DB="${1:-ontology}"
USER="${2:-root}"
PASS="${3:-12345678}"
PROJECT_ID="${4:-project_1780997325389}"
OUT_FILE="${5:-./semiconductor_metadata_${PROJECT_ID}.sql}"

echo "正在导出项目 ${PROJECT_ID} 的元数据到 ${OUT_FILE} ..."

rm -f "$OUT_FILE"

{
  echo "-- ============================================================"
  echo "-- 半导体项目元数据导出脚本"
  echo "-- 数据库: ${DB}"
  echo "-- 项目ID: ${PROJECT_ID}"
  echo "-- 包含表: projects, object_types, link_types, properties"
  echo "-- 不包含: 实例数据、link_instance_data、object_type_layouts、各 OT backing 表"
  echo "-- 生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "-- ============================================================"
  echo "SET FOREIGN_KEY_CHECKS = 0;"
  echo "SET UNIQUE_CHECKS = 0;"
} > "$OUT_FILE"

# 1. 项目记录
mysqldump -u "$USER" -p"$PASS" "$DB" projects \
  --no-create-info --set-gtid-purged=OFF \
  --where="id='${PROJECT_ID}'" >> "$OUT_FILE"

# 2. 对象类型（OT）
mysqldump -u "$USER" -p"$PASS" "$DB" object_types \
  --no-create-info --set-gtid-purged=OFF \
  --where="project_id='${PROJECT_ID}'" >> "$OUT_FILE"

# 3. 关系类型（LT）
mysqldump -u "$USER" -p"$PASS" "$DB" link_types \
  --no-create-info --set-gtid-purged=OFF \
  --where="project_id='${PROJECT_ID}'" >> "$OUT_FILE"

# 4. 属性（Properties）
mysqldump -u "$USER" -p"$PASS" "$DB" properties \
  --no-create-info --set-gtid-purged=OFF \
  --where="project_id='${PROJECT_ID}'" >> "$OUT_FILE"

{
  echo "SET UNIQUE_CHECKS = 1;"
  echo "SET FOREIGN_KEY_CHECKS = 1;"
} >> "$OUT_FILE"

echo "✅ 导出完成: ${OUT_FILE}"
echo ""
echo "导出内容统计（目标项目 ${PROJECT_ID}）:"
mysql -u "$USER" -p"$PASS" "$DB" -e "
SELECT 'projects' as table_name, COUNT(*) as cnt FROM projects WHERE id='${PROJECT_ID}'
UNION ALL SELECT 'object_types', COUNT(*) FROM object_types WHERE project_id='${PROJECT_ID}'
UNION ALL SELECT 'link_types', COUNT(*) FROM link_types WHERE project_id='${PROJECT_ID}'
UNION ALL SELECT 'properties', COUNT(*) FROM properties WHERE project_id='${PROJECT_ID}';
" 2>/dev/null
