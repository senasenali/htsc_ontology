-- 第一步：关闭外键检查
SET FOREIGN_KEY_CHECKS = 0;

-- 1.1 删除旧项目的 link-instance 约束映射
DELETE FROM interface_link_type_constraint_mapping
WHERE link_type_id IN (
  SELECT id FROM link_types WHERE project_id = '__TARGET_PROJECT_ID__'
);

-- 1.2 删除旧项目的链接实例（避免 LT 删除后留下脏链接）
DELETE FROM link_instance_data
WHERE link_type_id IN (
  SELECT id FROM link_types WHERE project_id = '__TARGET_PROJECT_ID__'
);

-- 1.3 删除旧项目的 Link Type
DELETE FROM link_types WHERE project_id = '__TARGET_PROJECT_ID__';

-- 1.4 删除旧项目的 OT-interface 映射
DELETE FROM object_type_interfaces_mapping
WHERE object_type_id IN (
  SELECT id FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__'
);

-- 1.5 删除旧项目的 Property
DELETE FROM properties
WHERE object_type_id IN (
  SELECT id FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__'
);

-- 1.6 删除旧项目的 Object Type
DELETE FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__';

-- 确认删除后的数量（可选）
SELECT 'after_delete_object_types' AS chk, COUNT(*) AS cnt FROM object_types WHERE project_id = '__TARGET_PROJECT_ID__'
UNION ALL
SELECT 'after_delete_link_types', COUNT(*) FROM link_types WHERE project_id = '__TARGET_PROJECT_ID__';
