-- 替换 __TARGET_PROJECT_ID__ 后执行，查看旧项目当前元数据数量
SELECT 'object_types' AS tbl, COUNT(*) AS cnt FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__'
UNION ALL
SELECT 'link_types', COUNT(*) FROM link_types WHERE project_id = '__TARGET_PROJECT_ID__'
UNION ALL
SELECT 'properties', COUNT(*) FROM properties WHERE object_type_id IN (
  SELECT id FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__'
);
