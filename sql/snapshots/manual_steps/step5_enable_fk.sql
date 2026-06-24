-- 最后：恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- 确认导入后的数量
SELECT 'object_types' AS tbl, COUNT(*) AS cnt FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__'
UNION ALL
SELECT 'link_types', COUNT(*) FROM link_types WHERE project_id = '__TARGET_PROJECT_ID__'
UNION ALL
SELECT 'properties', COUNT(*) FROM properties WHERE object_type_id IN (
  SELECT id FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__'
);
