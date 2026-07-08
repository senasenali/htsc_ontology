-- Blackwell demo v2 import for company DB
-- Scope: company DB already has object_types/link_types/properties metadata, but has no instance tables.
-- Modeling rule: intrinsic attributes stay on OT tables; cross-object facts are represented by link_instance_data.
SET @project_id := 'project_1780997325389';

-- 1. Create instance tables and bind object_types.backing_dataset.
CREATE TABLE IF NOT EXISTS `company` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `company_category` text NULL,
  `country_region` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `graphics_processing_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `compute_die_count` text NULL,
  `transistor_count_billion` text NULL,
  `die_to_die_bandwidth_tbps` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `training_accelerator` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `gpu_count` text NULL,
  `cpu_count` text NULL,
  `memory_capacity_gb` text NULL,
  `memory_bandwidth_tbps` text NULL,
  `interconnect_bandwidth_tbps` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `central_processing_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `processor_family` text NULL,
  `processor_role` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `interconnect_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `technology_family` text NULL,
  `technology_role` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gpu_architecture_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `release_date` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `process_platform` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `process_node_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `generation` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `high_bandwidth_memory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `stack_height` text NULL,
  `capacity_per_stack_gb` text NULL,
  `pin_speed_gbps` text NULL,
  `bandwidth_per_stack_tbps` text NULL,
  `io_width_bits` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `hbm_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `generation_name` text NULL,
  `typical_stack_height` text NULL,
  `typical_capacity_per_stack_gb` text NULL,
  `typical_bandwidth_per_stack_tbps` text NULL,
  `technology_significance` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `packaging_technology_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `advanced_packaging_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `technology_family` text NULL,
  `integration_mode` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `packaging_solution` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `interposer_type` text NULL,
  `local_silicon_interconnect` text NULL,
  `hbm_support` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `assembly_test_service` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `service_type` text NULL,
  `capacity_status` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `backend_facility` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `country_region` text NULL,
  `city_or_site` text NULL,
  `facility_type` text NULL,
  `status` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `abf_substrate` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dielectric_material` text NULL,
  `demand_driver` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `flip_chip_bonding_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `equipment_category` text NULL,
  `supported_process` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `hybrid_bonding_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `equipment_category` text NULL,
  `supported_process` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `wafer_thinning_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `equipment_category` text NULL,
  `supported_process` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `capital_expenditure` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `capex_amount` text NULL,
  `currency` text NULL,
  `period` text NULL,
  `capex_category` text NULL,
  `region` text NULL,
  `capacity_or_technology_purpose` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `ai_server_application` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `application_scenario` text NULL,
  `compute_requirement` text NULL,
  `source_url` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 1a. Align display names for reused process OTs.
UPDATE object_types SET name = '制程工艺' WHERE project_id = @project_id AND id = 'process_platform';
UPDATE object_types SET name = '制程节点' WHERE project_id = @project_id AND id = 'process_node_generation';

UPDATE object_types SET backing_dataset = 'company' WHERE project_id = @project_id AND id = 'company';
UPDATE object_types SET backing_dataset = 'graphics_processing_unit' WHERE project_id = @project_id AND id = 'graphics_processing_unit';
UPDATE object_types SET backing_dataset = 'training_accelerator' WHERE project_id = @project_id AND id = 'training_accelerator';
UPDATE object_types SET backing_dataset = 'central_processing_unit' WHERE project_id = @project_id AND id = 'central_processing_unit';
UPDATE object_types SET backing_dataset = 'interconnect_technology' WHERE project_id = @project_id AND id = 'interconnect_technology';
UPDATE object_types SET backing_dataset = 'gpu_architecture_generation' WHERE project_id = @project_id AND id = 'gpu_architecture_generation';
UPDATE object_types SET backing_dataset = 'process_platform' WHERE project_id = @project_id AND id = 'process_platform';
UPDATE object_types SET backing_dataset = 'process_node_generation' WHERE project_id = @project_id AND id = 'process_node_generation';
UPDATE object_types SET backing_dataset = 'high_bandwidth_memory' WHERE project_id = @project_id AND id = 'high_bandwidth_memory';
UPDATE object_types SET backing_dataset = 'hbm_generation' WHERE project_id = @project_id AND id = 'hbm_generation';
UPDATE object_types SET backing_dataset = 'packaging_technology_generation' WHERE project_id = @project_id AND id = 'packaging_technology_generation';
UPDATE object_types SET backing_dataset = 'advanced_packaging_technology' WHERE project_id = @project_id AND id = 'advanced_packaging_technology';
UPDATE object_types SET backing_dataset = 'packaging_solution' WHERE project_id = @project_id AND id = 'packaging_solution';
UPDATE object_types SET backing_dataset = 'assembly_test_service' WHERE project_id = @project_id AND id = 'assembly_test_service';
UPDATE object_types SET backing_dataset = 'backend_facility' WHERE project_id = @project_id AND id = 'backend_facility';
UPDATE object_types SET backing_dataset = 'abf_substrate' WHERE project_id = @project_id AND id = 'abf_substrate';
UPDATE object_types SET backing_dataset = 'flip_chip_bonding_equipment' WHERE project_id = @project_id AND id = 'flip_chip_bonding_equipment';
UPDATE object_types SET backing_dataset = 'hybrid_bonding_equipment' WHERE project_id = @project_id AND id = 'hybrid_bonding_equipment';
UPDATE object_types SET backing_dataset = 'wafer_thinning_equipment' WHERE project_id = @project_id AND id = 'wafer_thinning_equipment';
UPDATE object_types SET backing_dataset = 'capital_expenditure' WHERE project_id = @project_id AND id = 'capital_expenditure';
UPDATE object_types SET backing_dataset = 'ai_server_application' WHERE project_id = @project_id AND id = 'ai_server_application';

-- 2. Upsert object instances.
INSERT INTO `company` (`unique_id`, `name`, `description`, `company_category`, `country_region`, `source_url`) VALUES
('obj_company_nvidia', '英伟达', 'Blackwell GPU and GB200/NVL72 supplier.', 'Fabless GPU/AI accelerator vendor', 'United States', 'https://www.nvidia.com/en-us/data-center/technologies/blackwell-architecture/'),
('obj_company_tsmc', '台积电', 'Foundry and CoWoS advanced packaging provider for leading AI chips.', 'Foundry and advanced packaging provider', 'Taiwan, China', 'https://www.tsmc.com/english/dedicatedFoundry/technology/logic/l_3dfabric'),
('obj_company_skhynix', 'SK海力士', 'HBM3E supplier.', 'Memory supplier', 'Korea', 'https://www.skhynix.com/product/hbm3e.go'),
('obj_company_micron', '美光科技', 'HBM3E supplier.', 'Memory supplier', 'United States', 'https://www.micron.com/products/memory/hbm/hbm3e'),
('obj_company_samsung_electronics', '三星电子', 'HBM supplier candidate.', 'Memory supplier', 'Korea', 'https://www.skhynix.com/product/hbm3e.go'),
('obj_company_ibiden', '揖斐电', 'ABF substrate supplier.', 'IC substrate supplier', 'Japan', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/'),
('obj_company_unimicron', '欣兴电子', 'ABF substrate supplier.', 'IC substrate supplier', 'Taiwan, China', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/'),
('obj_company_shinko', '新光电气', 'ABF substrate supplier.', 'IC substrate supplier', 'Japan', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/'),
('obj_company_besi', 'BESI', 'Advanced bonding equipment supplier.', 'Semiconductor equipment supplier', 'Netherlands', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/'),
('obj_company_asmpt', 'ASMPT', 'Advanced bonding equipment supplier.', 'Semiconductor equipment supplier', 'Hong Kong, China', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/'),
('obj_company_kulicke_soffa', 'K&S', 'Bonding equipment supplier.', 'Semiconductor equipment supplier', 'United States', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/'),
('obj_company_disco', 'DISCO', 'Wafer thinning and dicing equipment supplier.', 'Semiconductor equipment supplier', 'Japan', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `company_category` = VALUES(`company_category`), `country_region` = VALUES(`country_region`), `source_url` = VALUES(`source_url`);

INSERT INTO `graphics_processing_unit` (`unique_id`, `name`, `description`, `compute_die_count`, `transistor_count_billion`, `die_to_die_bandwidth_tbps`, `source_url`) VALUES
('obj_gpu_nvidia_b200', 'NVIDIA B200 Tensor Core GPU', 'Blackwell-generation Tensor Core GPU used in GB200 Grace Blackwell Superchip and HGX B200 platforms.', '2', '208', '10', 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `compute_die_count` = VALUES(`compute_die_count`), `transistor_count_billion` = VALUES(`transistor_count_billion`), `die_to_die_bandwidth_tbps` = VALUES(`die_to_die_bandwidth_tbps`), `source_url` = VALUES(`source_url`);

INSERT INTO `training_accelerator` (`unique_id`, `name`, `description`, `gpu_count`, `cpu_count`, `memory_capacity_gb`, `memory_bandwidth_tbps`, `interconnect_bandwidth_tbps`, `source_url`) VALUES
('obj_training_accelerator_gb200', 'NVIDIA GB200 Grace Blackwell Superchip', 'Training accelerator module combining one Grace CPU and two Blackwell GPUs.', '2', '1', '372', '16', '3.6', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `gpu_count` = VALUES(`gpu_count`), `cpu_count` = VALUES(`cpu_count`), `memory_capacity_gb` = VALUES(`memory_capacity_gb`), `memory_bandwidth_tbps` = VALUES(`memory_bandwidth_tbps`), `interconnect_bandwidth_tbps` = VALUES(`interconnect_bandwidth_tbps`), `source_url` = VALUES(`source_url`);

INSERT INTO `central_processing_unit` (`unique_id`, `name`, `description`, `processor_family`, `processor_role`, `source_url`) VALUES
('obj_cpu_nvidia_grace', 'NVIDIA Grace CPU', 'CPU used with Blackwell GPUs in the GB200 Grace Blackwell Superchip.', 'NVIDIA Grace', 'host CPU for Grace Blackwell Superchip', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `processor_family` = VALUES(`processor_family`), `processor_role` = VALUES(`processor_role`), `source_url` = VALUES(`source_url`);

INSERT INTO `interconnect_technology` (`unique_id`, `name`, `description`, `technology_family`, `technology_role`, `source_url`) VALUES
('obj_interconnect_nvlink', 'NVIDIA NVLink', 'High-speed interconnect technology used by NVIDIA AI accelerator platforms.', 'NVLink', 'GPU and system interconnect', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/'),
('obj_interconnect_nvlink_c2c', 'NVIDIA NVLink-C2C', 'Chip-to-chip interconnect technology used between Grace CPU and Blackwell GPUs.', 'NVLink-C2C', 'CPU-GPU chip-to-chip interconnect', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `technology_family` = VALUES(`technology_family`), `technology_role` = VALUES(`technology_role`), `source_url` = VALUES(`source_url`);

INSERT INTO `gpu_architecture_generation` (`unique_id`, `name`, `description`, `release_date`, `source_url`) VALUES
('obj_gpu_arch_blackwell', 'NVIDIA Blackwell架构', 'GPU architecture generation centered on AI training and inference scaling.', '2024-03-18', 'https://www.nvidia.com/en-us/data-center/technologies/blackwell-architecture/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `release_date` = VALUES(`release_date`), `source_url` = VALUES(`source_url`);

INSERT INTO `process_platform` (`unique_id`, `name`, `description`, `source_url`) VALUES
('obj_process_platform_tsmc_4np', 'TSMC 4NP', 'Custom-built TSMC process disclosed by NVIDIA for Blackwell-architecture GPUs; scope is expressed through GPU and architecture link instances.', 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `source_url` = VALUES(`source_url`);

INSERT INTO `process_node_generation` (`unique_id`, `name`, `description`, `generation`, `source_url`) VALUES
('obj_process_node_4nm_class', '4nm-class制程节点', 'Industry node class used to group TSMC 4nm-class process variants; not a literal physical feature size.', '4nm', 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `generation` = VALUES(`generation`), `source_url` = VALUES(`source_url`);

INSERT INTO `high_bandwidth_memory` (`unique_id`, `name`, `description`, `stack_height`, `capacity_per_stack_gb`, `pin_speed_gbps`, `bandwidth_per_stack_tbps`, `io_width_bits`, `source_url`) VALUES
('obj_hbm_skhynix_hbm3e', 'SK海力士HBM3E 12Hi', '12-high HBM3E product relevant to AI accelerator memory capacity growth.', '12Hi', '36', '9.2', '1.18', '1024', 'https://www.skhynix.com/product/hbm3e.go'),
('obj_hbm_micron_hbm3e', '美光HBM3E 24GB', '24GB HBM3E product relevant to AI accelerator memory bandwidth.', '8Hi', '24', '9.2', '1.2', '1024', 'https://www.micron.com/products/memory/hbm/hbm3e'),
('obj_hbm_samsung_hbm3e', '三星HBM3E', 'Samsung HBM3E product family.', '8Hi/12Hi', '24-36', '9.2+', '1.2+', '1024', 'https://www.skhynix.com/product/hbm3e.go')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `stack_height` = VALUES(`stack_height`), `capacity_per_stack_gb` = VALUES(`capacity_per_stack_gb`), `pin_speed_gbps` = VALUES(`pin_speed_gbps`), `bandwidth_per_stack_tbps` = VALUES(`bandwidth_per_stack_tbps`), `io_width_bits` = VALUES(`io_width_bits`), `source_url` = VALUES(`source_url`);

INSERT INTO `hbm_generation` (`unique_id`, `name`, `description`, `generation_name`, `typical_stack_height`, `typical_capacity_per_stack_gb`, `typical_bandwidth_per_stack_tbps`, `technology_significance`, `source_url`) VALUES
('obj_hbm_generation_hbm3e', 'HBM3E世代', 'Enhanced HBM3 generation used in advanced AI accelerator products.', 'HBM3E', '8Hi/12Hi', '24-36', '1.2+', 'raises memory bandwidth and capacity for AI accelerators', 'https://www.skhynix.com/product/hbm3e.go')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `generation_name` = VALUES(`generation_name`), `typical_stack_height` = VALUES(`typical_stack_height`), `typical_capacity_per_stack_gb` = VALUES(`typical_capacity_per_stack_gb`), `typical_bandwidth_per_stack_tbps` = VALUES(`typical_bandwidth_per_stack_tbps`), `technology_significance` = VALUES(`technology_significance`), `source_url` = VALUES(`source_url`);

INSERT INTO `packaging_technology_generation` (`unique_id`, `name`, `description`, `source_url`) VALUES
('obj_packaging_generation_2_5d', '2.5D先进封装', 'Advanced packaging class represented by interposer, RDL or substrate-based multi-die integration.', 'https://www.tsmc.com/english/dedicatedFoundry/technology/logic/l_3dfabric')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `source_url` = VALUES(`source_url`);

INSERT INTO `advanced_packaging_technology` (`unique_id`, `name`, `description`, `technology_family`, `integration_mode`, `source_url`) VALUES
('obj_advanced_packaging_cowos', 'CoWoS', 'Chip-on-wafer-on-substrate advanced packaging technology platform for high-end AI accelerators.', 'CoWoS', '2.5D multi-die and HBM integration', 'https://www.tsmc.com/english/dedicatedFoundry/technology/logic/l_3dfabric')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `technology_family` = VALUES(`technology_family`), `integration_mode` = VALUES(`integration_mode`), `source_url` = VALUES(`source_url`);

INSERT INTO `packaging_solution` (`unique_id`, `name`, `description`, `interposer_type`, `local_silicon_interconnect`, `hbm_support`, `source_url`) VALUES
('obj_packaging_solution_tsmc_cowos_l', 'TSMC CoWoS-L', 'Concrete CoWoS solution variant using local silicon interconnect bridges for large multi-die AI packages.', 'RDL interposer plus local silicon interconnect', 'LSI bridge', 'supports multiple HBM stacks', 'https://www.tsmc.com/english/dedicatedFoundry/technology/logic/l_3dfabric')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `interposer_type` = VALUES(`interposer_type`), `local_silicon_interconnect` = VALUES(`local_silicon_interconnect`), `hbm_support` = VALUES(`hbm_support`), `source_url` = VALUES(`source_url`);

INSERT INTO `assembly_test_service` (`unique_id`, `name`, `description`, `service_type`, `capacity_status`, `source_url`) VALUES
('obj_service_tsmc_cowos', '台积电CoWoS封装测试服务', 'Commercial packaging and testing service capacity required to manufacture CoWoS-based AI accelerator products.', 'advanced packaging and test', 'tight capacity / expansion demand', 'https://www.semi.org/en/blogs/technology-trends/tsmc-cowos-advanced-packaging')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `service_type` = VALUES(`service_type`), `capacity_status` = VALUES(`capacity_status`), `source_url` = VALUES(`source_url`);

INSERT INTO `backend_facility` (`unique_id`, `name`, `description`, `country_region`, `city_or_site`, `facility_type`, `status`, `source_url`) VALUES
('obj_facility_tsmc_ap6', '台积电CoWoS后道产能', 'TSMC backend capacity associated with CoWoS advanced packaging expansion.', 'Taiwan, China', 'Taiwan sites', 'advanced packaging backend facility', 'capacity expansion', 'https://www.semi.org/en/blogs/technology-trends/tsmc-cowos-advanced-packaging')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `country_region` = VALUES(`country_region`), `city_or_site` = VALUES(`city_or_site`), `facility_type` = VALUES(`facility_type`), `status` = VALUES(`status`), `source_url` = VALUES(`source_url`);

INSERT INTO `abf_substrate` (`unique_id`, `name`, `description`, `dielectric_material`, `demand_driver`, `source_url`) VALUES
('obj_abf_substrate', 'AI加速器ABF载板', 'Large-size ABF substrate used by high-end AI accelerator packages.', 'Ajinomoto build-up film', 'larger package size and advanced packaging demand', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `dielectric_material` = VALUES(`dielectric_material`), `demand_driver` = VALUES(`demand_driver`), `source_url` = VALUES(`source_url`);

INSERT INTO `flip_chip_bonding_equipment` (`unique_id`, `name`, `description`, `equipment_category`, `supported_process`, `source_url`) VALUES
('obj_equipment_flip_chip_bonder', 'AI封装倒装键合机', 'Flip-chip bonding equipment used in advanced packaging assembly.', 'flip-chip bonding', 'die attach / chip placement for advanced package', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `equipment_category` = VALUES(`equipment_category`), `supported_process` = VALUES(`supported_process`), `source_url` = VALUES(`source_url`);

INSERT INTO `hybrid_bonding_equipment` (`unique_id`, `name`, `description`, `equipment_category`, `supported_process`, `source_url`) VALUES
('obj_equipment_hybrid_bonder', '先进封装混合键合机', 'Hybrid bonding equipment relevant to advanced interconnect density.', 'hybrid bonding', 'wafer-to-wafer / die-to-wafer bonding', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `equipment_category` = VALUES(`equipment_category`), `supported_process` = VALUES(`supported_process`), `source_url` = VALUES(`source_url`);

INSERT INTO `wafer_thinning_equipment` (`unique_id`, `name`, `description`, `equipment_category`, `supported_process`, `source_url`) VALUES
('obj_equipment_wafer_thinning', 'HBM/先进封装晶圆减薄机', 'Wafer thinning equipment used in HBM and advanced packaging process flows.', 'wafer thinning', 'backgrind / thinning for stacked memory and packaging', 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `equipment_category` = VALUES(`equipment_category`), `supported_process` = VALUES(`supported_process`), `source_url` = VALUES(`source_url`);

INSERT INTO `capital_expenditure` (`unique_id`, `name`, `description`, `capex_amount`, `currency`, `period`, `capex_category`, `region`, `capacity_or_technology_purpose`, `source_url`) VALUES
('obj_metric_tsmc_adv_packaging_capex', '台积电先进封装扩产资本开支', 'Capital expenditure associated with advanced packaging and CoWoS capacity expansion.', 'not specified', 'USD/TWD', '2024-2026', 'advanced packaging capacity expansion', 'Taiwan, China', 'CoWoS and AI accelerator package capacity', 'https://www.semi.org/en/blogs/technology-trends/tsmc-cowos-advanced-packaging')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `capex_amount` = VALUES(`capex_amount`), `currency` = VALUES(`currency`), `period` = VALUES(`period`), `capex_category` = VALUES(`capex_category`), `region` = VALUES(`region`), `capacity_or_technology_purpose` = VALUES(`capacity_or_technology_purpose`), `source_url` = VALUES(`source_url`);

INSERT INTO `ai_server_application` (`unique_id`, `name`, `description`, `application_scenario`, `compute_requirement`, `source_url`) VALUES
('obj_app_ai_server_training', '数据中心AI训练与推理', 'Demand scenario driving Blackwell GPU, HBM and advanced packaging requirements.', 'large-scale AI training and inference', 'high FLOPS, high memory bandwidth, high cluster interconnect bandwidth', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `application_scenario` = VALUES(`application_scenario`), `compute_requirement` = VALUES(`compute_requirement`), `source_url` = VALUES(`source_url`);

-- 3. Ensure link types required by the v2 mounting plan exist.
INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_graphics_processing_unit_adopts_gpu_architecture_generation', 'GPU采用GPU架构世代', 'graphics_processing_unit', 'gpu_architecture_generation', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_training_accelerator_adopts_gpu_architecture_generation', '训练加速器采用GPU架构世代', 'training_accelerator', 'gpu_architecture_generation', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_training_accelerator_contains_central_processing_unit', '训练加速器搭载CPU', 'training_accelerator', 'central_processing_unit', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_training_accelerator_adopts_hbm_generation', '训练加速器采用HBM世代', 'training_accelerator', 'hbm_generation', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_training_accelerator_adopts_interconnect_technology', '训练加速器采用互联技术', 'training_accelerator', 'interconnect_technology', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_graphics_processing_unit_relation_ai_server_application', 'GPU下游应用数据中心计算应用', 'graphics_processing_unit', 'ai_server_application', 'M:N', '下游应用', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_training_accelerator_relation_ai_server_application', '训练加速器下游应用数据中心计算应用', 'training_accelerator', 'ai_server_application', 'M:N', '下游应用', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_graphics_processing_unit_adopts_process_platform', 'GPU采用制程工艺', 'graphics_processing_unit', 'process_platform', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_gpu_architecture_generation_corresponds_to_process_platform', 'GPU架构世代对应制程工艺', 'gpu_architecture_generation', 'process_platform', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_process_platform_relation_process_node_generation', '制程工艺对应制程节点', 'process_platform', 'process_node_generation', 'M:N', '技术关联', 'Blackwell demo v2: 已有/改名复用', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_process_platform', '公司生产供给制程工艺', 'company', 'process_platform', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_gpu_architecture_generation_drives_advanced_packaging_technology', 'GPU架构世代驱动先进封装技术', 'gpu_architecture_generation', 'advanced_packaging_technology', 'M:N', '技术驱动', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_packaging_technology_generation_corresponds_to_advanced_packaging_technology', '封装技术世代对应先进封装技术', 'packaging_technology_generation', 'advanced_packaging_technology', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_advanced_packaging_technology_corresponds_to_packaging_solution', '先进封装技术对应封装方案', 'advanced_packaging_technology', 'packaging_solution', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_graphics_processing_unit_adopts_packaging_solution', 'GPU采用封装方案', 'graphics_processing_unit', 'packaging_solution', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_high_bandwidth_memory_adopts_hbm_generation', 'HBM采用HBM世代', 'high_bandwidth_memory', 'hbm_generation', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_high_bandwidth_memory', '公司生产供给HBM', 'company', 'high_bandwidth_memory', 'M:N', '技术关联', 'Blackwell demo v2: 新增/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_packaging_solution', '公司生产供给封装方案', 'company', 'packaging_solution', 'M:N', '技术关联', 'Blackwell demo v2: 新增', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_assembly_test_service', '公司生产供给封装测试服务', 'company', 'assembly_test_service', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_assembly_test_service_supports_capability_of_graphics_processing_unit', '封装测试服务能力支撑GPU', 'assembly_test_service', 'graphics_processing_unit', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_backend_facility_belongs_to_company', '后道工厂所属公司', 'backend_facility', 'company', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_backend_facility_produces_for_assembly_test_service', '后道工厂生产供给封装测试服务', 'backend_facility', 'assembly_test_service', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_abf_substrate_supplies_to_graphics_processing_unit', 'ABF载板供给于GPU', 'abf_substrate', 'graphics_processing_unit', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_abf_substrate', '公司生产供给ABF载板', 'company', 'abf_substrate', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_flip_chip_bonding_equipment', '公司生产供给倒装键合机', 'company', 'flip_chip_bonding_equipment', 'M:N', '技术关联', 'Blackwell demo v2: 新增/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_hybrid_bonding_equipment', '公司生产供给混合键合机', 'company', 'hybrid_bonding_equipment', 'M:N', '技术关联', 'Blackwell demo v2: 新增/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_company_produces_for_wafer_thinning_equipment', '公司生产供给晶圆减薄机', 'company', 'wafer_thinning_equipment', 'M:N', '技术关联', 'Blackwell demo v2: 新增/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_flip_chip_bonding_equipment_supports_capability_of_assembly_test_service', '倒装键合机能力支撑封装测试服务', 'flip_chip_bonding_equipment', 'assembly_test_service', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_hybrid_bonding_equipment_supports_capability_of_assembly_test_service', '混合键合机能力支撑封装测试服务', 'hybrid_bonding_equipment', 'assembly_test_service', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_wafer_thinning_equipment_supports_capability_of_assembly_test_service', '晶圆减薄机能力支撑封装测试服务', 'wafer_thinning_equipment', 'assembly_test_service', 'M:N', '技术关联', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_capital_expenditure_measures_for_assembly_test_service', '资本开支统计对象封装测试服务', 'capital_expenditure', 'assembly_test_service', 'M:N', '统计对象', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES ('lt_capital_expenditure_measures_for_backend_facility', '资本开支统计对象后道工厂', 'capital_expenditure', 'backend_facility', 'M:N', '统计对象', 'Blackwell demo v2: 已有/确保存在', NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;

-- 4. Upsert link instances.
CREATE TABLE IF NOT EXISTS link_instance_data (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `link_type_id` varchar(100) NOT NULL COMMENT '链接类型ID',
  `source_instance_id` varchar(100) NOT NULL COMMENT '源对象实例唯一标识',
  `target_instance_id` varchar(100) NOT NULL COMMENT '目标对象实例唯一标识',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_link_type` (`link_type_id`),
  KEY `idx_source_instance` (`source_instance_id`),
  KEY `idx_target_instance` (`target_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='链接实例数据表';

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_graphics_processing_unit_adopts_gpu_architecture_generation', 'obj_gpu_nvidia_b200', 'obj_gpu_arch_blackwell'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_graphics_processing_unit_adopts_gpu_architecture_generation' AND source_instance_id='obj_gpu_nvidia_b200' AND target_instance_id='obj_gpu_arch_blackwell'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_training_accelerator_adopts_gpu_architecture_generation', 'obj_training_accelerator_gb200', 'obj_gpu_arch_blackwell'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_training_accelerator_adopts_gpu_architecture_generation' AND source_instance_id='obj_training_accelerator_gb200' AND target_instance_id='obj_gpu_arch_blackwell'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_training_accelerator_contains_central_processing_unit', 'obj_training_accelerator_gb200', 'obj_cpu_nvidia_grace'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_training_accelerator_contains_central_processing_unit' AND source_instance_id='obj_training_accelerator_gb200' AND target_instance_id='obj_cpu_nvidia_grace'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_training_accelerator_adopts_hbm_generation', 'obj_training_accelerator_gb200', 'obj_hbm_generation_hbm3e'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_training_accelerator_adopts_hbm_generation' AND source_instance_id='obj_training_accelerator_gb200' AND target_instance_id='obj_hbm_generation_hbm3e'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_training_accelerator_adopts_interconnect_technology', 'obj_training_accelerator_gb200', 'obj_interconnect_nvlink'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_training_accelerator_adopts_interconnect_technology' AND source_instance_id='obj_training_accelerator_gb200' AND target_instance_id='obj_interconnect_nvlink'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_training_accelerator_adopts_interconnect_technology', 'obj_training_accelerator_gb200', 'obj_interconnect_nvlink_c2c'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_training_accelerator_adopts_interconnect_technology' AND source_instance_id='obj_training_accelerator_gb200' AND target_instance_id='obj_interconnect_nvlink_c2c'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_graphics_processing_unit_relation_ai_server_application', 'obj_gpu_nvidia_b200', 'obj_app_ai_server_training'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_graphics_processing_unit_relation_ai_server_application' AND source_instance_id='obj_gpu_nvidia_b200' AND target_instance_id='obj_app_ai_server_training'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_training_accelerator_relation_ai_server_application', 'obj_training_accelerator_gb200', 'obj_app_ai_server_training'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_training_accelerator_relation_ai_server_application' AND source_instance_id='obj_training_accelerator_gb200' AND target_instance_id='obj_app_ai_server_training'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_graphics_processing_unit_adopts_process_platform', 'obj_gpu_nvidia_b200', 'obj_process_platform_tsmc_4np'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_graphics_processing_unit_adopts_process_platform' AND source_instance_id='obj_gpu_nvidia_b200' AND target_instance_id='obj_process_platform_tsmc_4np'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_gpu_architecture_generation_corresponds_to_process_platform', 'obj_gpu_arch_blackwell', 'obj_process_platform_tsmc_4np'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_gpu_architecture_generation_corresponds_to_process_platform' AND source_instance_id='obj_gpu_arch_blackwell' AND target_instance_id='obj_process_platform_tsmc_4np'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_process_platform_relation_process_node_generation', 'obj_process_platform_tsmc_4np', 'obj_process_node_4nm_class'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_process_platform_relation_process_node_generation' AND source_instance_id='obj_process_platform_tsmc_4np' AND target_instance_id='obj_process_node_4nm_class'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_process_platform', 'obj_company_tsmc', 'obj_process_platform_tsmc_4np'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_process_platform' AND source_instance_id='obj_company_tsmc' AND target_instance_id='obj_process_platform_tsmc_4np'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_gpu_architecture_generation_drives_advanced_packaging_technology', 'obj_gpu_arch_blackwell', 'obj_advanced_packaging_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_gpu_architecture_generation_drives_advanced_packaging_technology' AND source_instance_id='obj_gpu_arch_blackwell' AND target_instance_id='obj_advanced_packaging_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_packaging_technology_generation_corresponds_to_advanced_packaging_technology', 'obj_packaging_generation_2_5d', 'obj_advanced_packaging_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_packaging_technology_generation_corresponds_to_advanced_packaging_technology' AND source_instance_id='obj_packaging_generation_2_5d' AND target_instance_id='obj_advanced_packaging_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_advanced_packaging_technology_corresponds_to_packaging_solution', 'obj_advanced_packaging_cowos', 'obj_packaging_solution_tsmc_cowos_l'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_advanced_packaging_technology_corresponds_to_packaging_solution' AND source_instance_id='obj_advanced_packaging_cowos' AND target_instance_id='obj_packaging_solution_tsmc_cowos_l'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_graphics_processing_unit_adopts_packaging_solution', 'obj_gpu_nvidia_b200', 'obj_packaging_solution_tsmc_cowos_l'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_graphics_processing_unit_adopts_packaging_solution' AND source_instance_id='obj_gpu_nvidia_b200' AND target_instance_id='obj_packaging_solution_tsmc_cowos_l'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_high_bandwidth_memory_adopts_hbm_generation', 'obj_hbm_skhynix_hbm3e', 'obj_hbm_generation_hbm3e'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_high_bandwidth_memory_adopts_hbm_generation' AND source_instance_id='obj_hbm_skhynix_hbm3e' AND target_instance_id='obj_hbm_generation_hbm3e'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_high_bandwidth_memory_adopts_hbm_generation', 'obj_hbm_micron_hbm3e', 'obj_hbm_generation_hbm3e'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_high_bandwidth_memory_adopts_hbm_generation' AND source_instance_id='obj_hbm_micron_hbm3e' AND target_instance_id='obj_hbm_generation_hbm3e'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_high_bandwidth_memory_adopts_hbm_generation', 'obj_hbm_samsung_hbm3e', 'obj_hbm_generation_hbm3e'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_high_bandwidth_memory_adopts_hbm_generation' AND source_instance_id='obj_hbm_samsung_hbm3e' AND target_instance_id='obj_hbm_generation_hbm3e'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_high_bandwidth_memory', 'obj_company_skhynix', 'obj_hbm_skhynix_hbm3e'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_high_bandwidth_memory' AND source_instance_id='obj_company_skhynix' AND target_instance_id='obj_hbm_skhynix_hbm3e'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_high_bandwidth_memory', 'obj_company_micron', 'obj_hbm_micron_hbm3e'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_high_bandwidth_memory' AND source_instance_id='obj_company_micron' AND target_instance_id='obj_hbm_micron_hbm3e'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_high_bandwidth_memory', 'obj_company_samsung_electronics', 'obj_hbm_samsung_hbm3e'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_high_bandwidth_memory' AND source_instance_id='obj_company_samsung_electronics' AND target_instance_id='obj_hbm_samsung_hbm3e'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_packaging_solution', 'obj_company_tsmc', 'obj_packaging_solution_tsmc_cowos_l'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_packaging_solution' AND source_instance_id='obj_company_tsmc' AND target_instance_id='obj_packaging_solution_tsmc_cowos_l'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_assembly_test_service', 'obj_company_tsmc', 'obj_service_tsmc_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_assembly_test_service' AND source_instance_id='obj_company_tsmc' AND target_instance_id='obj_service_tsmc_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_assembly_test_service_supports_capability_of_graphics_processing_unit', 'obj_service_tsmc_cowos', 'obj_gpu_nvidia_b200'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_assembly_test_service_supports_capability_of_graphics_processing_unit' AND source_instance_id='obj_service_tsmc_cowos' AND target_instance_id='obj_gpu_nvidia_b200'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_backend_facility_belongs_to_company', 'obj_facility_tsmc_ap6', 'obj_company_tsmc'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_backend_facility_belongs_to_company' AND source_instance_id='obj_facility_tsmc_ap6' AND target_instance_id='obj_company_tsmc'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_backend_facility_produces_for_assembly_test_service', 'obj_facility_tsmc_ap6', 'obj_service_tsmc_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_backend_facility_produces_for_assembly_test_service' AND source_instance_id='obj_facility_tsmc_ap6' AND target_instance_id='obj_service_tsmc_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_abf_substrate_supplies_to_graphics_processing_unit', 'obj_abf_substrate', 'obj_gpu_nvidia_b200'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_abf_substrate_supplies_to_graphics_processing_unit' AND source_instance_id='obj_abf_substrate' AND target_instance_id='obj_gpu_nvidia_b200'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_abf_substrate', 'obj_company_ibiden', 'obj_abf_substrate'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_abf_substrate' AND source_instance_id='obj_company_ibiden' AND target_instance_id='obj_abf_substrate'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_abf_substrate', 'obj_company_unimicron', 'obj_abf_substrate'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_abf_substrate' AND source_instance_id='obj_company_unimicron' AND target_instance_id='obj_abf_substrate'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_abf_substrate', 'obj_company_shinko', 'obj_abf_substrate'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_abf_substrate' AND source_instance_id='obj_company_shinko' AND target_instance_id='obj_abf_substrate'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_flip_chip_bonding_equipment', 'obj_company_besi', 'obj_equipment_flip_chip_bonder'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_flip_chip_bonding_equipment' AND source_instance_id='obj_company_besi' AND target_instance_id='obj_equipment_flip_chip_bonder'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_flip_chip_bonding_equipment', 'obj_company_asmpt', 'obj_equipment_flip_chip_bonder'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_flip_chip_bonding_equipment' AND source_instance_id='obj_company_asmpt' AND target_instance_id='obj_equipment_flip_chip_bonder'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_flip_chip_bonding_equipment', 'obj_company_kulicke_soffa', 'obj_equipment_flip_chip_bonder'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_flip_chip_bonding_equipment' AND source_instance_id='obj_company_kulicke_soffa' AND target_instance_id='obj_equipment_flip_chip_bonder'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_hybrid_bonding_equipment', 'obj_company_besi', 'obj_equipment_hybrid_bonder'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_hybrid_bonding_equipment' AND source_instance_id='obj_company_besi' AND target_instance_id='obj_equipment_hybrid_bonder'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_hybrid_bonding_equipment', 'obj_company_asmpt', 'obj_equipment_hybrid_bonder'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_hybrid_bonding_equipment' AND source_instance_id='obj_company_asmpt' AND target_instance_id='obj_equipment_hybrid_bonder'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_company_produces_for_wafer_thinning_equipment', 'obj_company_disco', 'obj_equipment_wafer_thinning'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_company_produces_for_wafer_thinning_equipment' AND source_instance_id='obj_company_disco' AND target_instance_id='obj_equipment_wafer_thinning'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_flip_chip_bonding_equipment_supports_capability_of_assembly_test_service', 'obj_equipment_flip_chip_bonder', 'obj_service_tsmc_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_flip_chip_bonding_equipment_supports_capability_of_assembly_test_service' AND source_instance_id='obj_equipment_flip_chip_bonder' AND target_instance_id='obj_service_tsmc_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_hybrid_bonding_equipment_supports_capability_of_assembly_test_service', 'obj_equipment_hybrid_bonder', 'obj_service_tsmc_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_hybrid_bonding_equipment_supports_capability_of_assembly_test_service' AND source_instance_id='obj_equipment_hybrid_bonder' AND target_instance_id='obj_service_tsmc_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_wafer_thinning_equipment_supports_capability_of_assembly_test_service', 'obj_equipment_wafer_thinning', 'obj_service_tsmc_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_wafer_thinning_equipment_supports_capability_of_assembly_test_service' AND source_instance_id='obj_equipment_wafer_thinning' AND target_instance_id='obj_service_tsmc_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_capital_expenditure_measures_for_assembly_test_service', 'obj_metric_tsmc_adv_packaging_capex', 'obj_service_tsmc_cowos'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_capital_expenditure_measures_for_assembly_test_service' AND source_instance_id='obj_metric_tsmc_adv_packaging_capex' AND target_instance_id='obj_service_tsmc_cowos'
);

INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT 'lt_capital_expenditure_measures_for_backend_facility', 'obj_metric_tsmc_adv_packaging_capex', 'obj_facility_tsmc_ap6'
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id='lt_capital_expenditure_measures_for_backend_facility' AND source_instance_id='obj_metric_tsmc_adv_packaging_capex' AND target_instance_id='obj_facility_tsmc_ap6'
);

-- 5. Upsert property-level evidence for audited specs.
CREATE TABLE IF NOT EXISTS instance_property_evidence (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `evidence_id` varchar(160) NOT NULL COMMENT '证据唯一标识',
  `object_type_name` varchar(100) NOT NULL COMMENT '对象类型中文名',
  `instance_id` varchar(160) NOT NULL COMMENT '实例唯一标识',
  `property_name` varchar(160) NOT NULL COMMENT '属性名或规格名',
  `property_value` text NULL COMMENT '属性值',
  `value_unit` varchar(100) DEFAULT NULL COMMENT '值单位',
  `source_url` text NULL COMMENT '来源链接',
  `source_title` varchar(500) DEFAULT NULL COMMENT '来源标题',
  `evidence_text` text NULL COMMENT '证据摘述',
  `confidence` varchar(50) DEFAULT NULL COMMENT '证据可信度',
  `evidence_date` varchar(50) DEFAULT NULL COMMENT '证据日期',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_evidence_id` (`evidence_id`),
  KEY `idx_instance_property` (`instance_id`, `property_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='实例属性级证据表';

INSERT INTO instance_property_evidence (`evidence_id`, `object_type_name`, `instance_id`, `property_name`, `property_value`, `value_unit`, `source_url`, `source_title`, `evidence_text`, `confidence`, `evidence_date`) VALUES
('evi_b200_compute_die_count', 'GPU', 'obj_gpu_nvidia_b200', 'compute_die_count', '2', 'number', 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing', 'NVIDIA Blackwell Platform Arrives to Power a New Era of Computing', 'Official NVIDIA release describes Blackwell GPUs as using two reticle-limit dies connected as one unified GPU.', 'official', '2024-03-18'),
('evi_b200_transistor_count', 'GPU', 'obj_gpu_nvidia_b200', 'transistor_count_billion', '208', 'billion transistors', 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing', 'NVIDIA Blackwell Platform Arrives to Power a New Era of Computing', 'Official NVIDIA release states Blackwell-architecture GPUs contain 208 billion transistors.', 'official', '2024-03-18'),
('evi_b200_die_to_die_bandwidth', 'GPU', 'obj_gpu_nvidia_b200', 'die_to_die_bandwidth_tbps', '10', 'TB/s', 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing', 'NVIDIA Blackwell Platform Arrives to Power a New Era of Computing', 'Official NVIDIA release states the two GPU dies are connected by a 10TB/s chip-to-chip link.', 'official', '2024-03-18'),
('evi_gb200_gpu_count', '训练加速器', 'obj_training_accelerator_gb200', 'gpu_count', '2', 'GPU', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list one Grace CPU and two Blackwell GPUs per GB200 Superchip.', 'official', ''),
('evi_gb200_cpu_count', '训练加速器', 'obj_training_accelerator_gb200', 'cpu_count', '1', 'CPU', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list one Grace CPU in the GB200 Superchip configuration.', 'official', ''),
('evi_gb200_memory_capacity', '训练加速器', 'obj_training_accelerator_gb200', 'memory_capacity_gb', '372', 'GB HBM3E', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list 372GB HBM3E GPU memory for the GB200 Superchip.', 'official', ''),
('evi_gb200_memory_bandwidth', '训练加速器', 'obj_training_accelerator_gb200', 'memory_bandwidth_tbps', '16', 'TB/s', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list 16TB/s HBM3E bandwidth for the GB200 Superchip.', 'official', ''),
('evi_gb200_interconnect_bandwidth', '训练加速器', 'obj_training_accelerator_gb200', 'interconnect_bandwidth_tbps', '3.6', 'TB/s', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list 3.6TB/s NVLink bandwidth.', 'official', ''),
('evi_gb200_nvfp4_sparse_dense', '训练加速器', 'obj_training_accelerator_gb200', 'nvfp4_tensor_core_pflops_sparse_dense', '40 | 20', 'PFLOPS sparse | dense', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list NVFP4 Tensor Core throughput as sparse and dense values.', 'official', ''),
('evi_gb200_fp8_fp6', '训练加速器', 'obj_training_accelerator_gb200', 'fp8_fp6_tensor_core_pflops', '20', 'PFLOPS', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP8/FP6 Tensor Core throughput.', 'official', ''),
('evi_gb200_int8', '训练加速器', 'obj_training_accelerator_gb200', 'int8_tensor_core_pops', '20', 'POPS', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list INT8 Tensor Core throughput.', 'official', ''),
('evi_gb200_fp16_bf16', '训练加速器', 'obj_training_accelerator_gb200', 'fp16_bf16_tensor_core_pflops', '10', 'PFLOPS', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP16/BF16 Tensor Core throughput.', 'official', ''),
('evi_gb200_tf32', '训练加速器', 'obj_training_accelerator_gb200', 'tf32_tensor_core_pflops', '5', 'PFLOPS', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list TF32 Tensor Core throughput.', 'official', ''),
('evi_gb200_fp32', '训练加速器', 'obj_training_accelerator_gb200', 'fp32_tflops', '160', 'TFLOPS', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP32 throughput.', 'official', ''),
('evi_gb200_fp64', '训练加速器', 'obj_training_accelerator_gb200', 'fp64_tflops', '80', 'TFLOPS', 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/', 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP64 throughput.', 'official', '')
ON DUPLICATE KEY UPDATE `object_type_name` = VALUES(`object_type_name`), `instance_id` = VALUES(`instance_id`), `property_name` = VALUES(`property_name`), `property_value` = VALUES(`property_value`), `value_unit` = VALUES(`value_unit`), `source_url` = VALUES(`source_url`), `source_title` = VALUES(`source_title`), `evidence_text` = VALUES(`evidence_text`), `confidence` = VALUES(`confidence`), `evidence_date` = VALUES(`evidence_date`);
