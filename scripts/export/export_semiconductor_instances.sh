#!/bin/bash
# 导出半导体项目实例数据
# 包含：所有 backing_dataset 实例表 + 该项目相关的 link_instance_data
# 不含：OT/LT/属性等元数据
#
# 用法: ./export_semiconductor_instances.sh [数据库名] [mysql用户] [mysql密码] [项目ID] [输出文件]
#
# 示例:
#   ./export_semiconductor_instances.sh
#   ./export_semiconductor_instances.sh ontology root 12345678 project_1780997325389 ./semiconductor_instances.sql

set -euo pipefail

DB="${1:-ontology}"
USER="${2:-root}"
PASS="${3:-12345678}"
PROJECT_ID="${4:-project_1780997325389}"
OUT_FILE="${5:-./semiconductor_instances_${PROJECT_ID}.sql}"

echo "正在导出项目 ${PROJECT_ID} 的实例数据到 ${OUT_FILE} ..."

rm -f "$OUT_FILE"

{
  echo "-- ============================================================"
  echo "-- 半导体项目实例数据导出脚本"
  echo "-- 数据库: ${DB}"
  echo "-- 项目ID: ${PROJECT_ID}"
  echo "-- 包含: 各 OT backing_dataset 实例表 + link_instance_data"
  echo "-- 不包含: projects/object_types/link_types/properties 等元数据"
  echo "-- 生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "-- ============================================================"
  echo "SET FOREIGN_KEY_CHECKS = 0;"
  echo "SET UNIQUE_CHECKS = 0;"
} > "$OUT_FILE"

# 获取该项目下所有需要导出的 backing_dataset 表名
BACKING_TABLES=$(mysql -u "$USER" -p"$PASS" -N -B -e "
  SELECT DISTINCT backing_dataset
  FROM ${DB}.object_types
  WHERE project_id='${PROJECT_ID}' AND backing_dataset != ''
  ORDER BY backing_dataset;
" 2>/dev/null)

if [[ -z "$BACKING_TABLES" ]]; then
  echo "⚠️  未找到该项目下的实例表（backing_dataset 为空）"
else
  echo "发现以下实例表:"
  echo "$BACKING_TABLES"
  echo ""

  for tbl in $BACKING_TABLES; do
    echo "导出实例表: ${tbl}"
    mysqldump -u "$USER" -p"$PASS" "$DB" "$tbl" \
      --set-gtid-purged=OFF \
      --single-transaction >> "$OUT_FILE"
  done
fi

# 导出 link_instance_data 中属于该项目的行
# 注意：link_instance_data 与 link_types 的字符集/排序规则可能不同，需要 COLLATE 转换
echo ""
echo "导出 link_instance_data 中项目 ${PROJECT_ID} 相关的数据..."
mysqldump -u "$USER" -p"$PASS" "$DB" link_instance_data \
  --no-create-info --set-gtid-purged=OFF --single-transaction \
  --where="link_type_id COLLATE utf8mb4_unicode_ci IN (SELECT id FROM ${DB}.link_types WHERE project_id='${PROJECT_ID}')" >> "$OUT_FILE"

{
  echo "SET UNIQUE_CHECKS = 1;"
  echo "SET FOREIGN_KEY_CHECKS = 1;"
} >> "$OUT_FILE"

echo "✅ 导出完成: ${OUT_FILE}"
echo ""
echo "导出内容统计:"

# 统计 backing 表行数
STATS_SQL="SELECT 'link_instance_data' as table_name, COUNT(*) as cnt FROM ${DB}.link_instance_data WHERE link_type_id COLLATE utf8mb4_unicode_ci IN (SELECT id FROM ${DB}.link_types WHERE project_id='${PROJECT_ID}')"
for tbl in $BACKING_TABLES; do
  STATS_SQL="${STATS_SQL} UNION ALL SELECT '${tbl}', COUNT(*) FROM ${DB}.${tbl}"
done
STATS_SQL="${STATS_SQL};"

mysql -u "$USER" -p"$PASS" "$DB" -e "$STATS_SQL" 2>/dev/null | sort -t$'\t' -k2 -nr
