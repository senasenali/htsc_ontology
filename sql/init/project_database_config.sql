-- HTSC Ontology project database configuration
-- Usage:
--   mysql -uroot -p < sql/init/project_database_config.sql
--   mysql -uroot -p ontology < sql/snapshots/ontology20260520.sql
--
-- The application defaults in this repository use:
--   host: localhost
--   port: 3306
--   database: ontology
--   username: root
--   password: 12345678

CREATE DATABASE IF NOT EXISTS `ontology`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `ontology`;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET time_zone = '+08:00';

-- Optional non-root application user.
-- Uncomment and adjust the password if the deployment environment should not use root.
--
-- CREATE USER IF NOT EXISTS 'ontology_app'@'localhost' IDENTIFIED BY 'change_me_strong_password';
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP
--   ON `ontology`.*
--   TO 'ontology_app'@'localhost';
-- FLUSH PRIVILEGES;

SELECT 'ontology database configuration is ready' AS status;
