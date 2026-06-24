-- ============================================================
-- 半导体项目实例数据导出脚本
-- 数据库: ontology
-- 项目ID: project_1780997325389
-- 包含: 各 OT backing_dataset 实例表 + link_instance_data
-- 不包含: projects/object_types/link_types/properties 等元数据
-- 生成时间: 2026-06-23 21:55:10
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abf_substrate`
--

DROP TABLE IF EXISTS `abf_substrate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abf_substrate` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `build_up_layer_count` bigint DEFAULT NULL,
  `line_width_spacing` varchar(500) DEFAULT NULL,
  `substrate_thickness` double DEFAULT NULL,
  `dielectric_material` varchar(500) DEFAULT NULL,
  `thermal_stability_grade` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abf_substrate`
--

LOCK TABLES `abf_substrate` WRITE;
/*!40000 ALTER TABLE `abf_substrate` DISABLE KEYS */;
INSERT INTO `abf_substrate` VALUES (1,'AT&S high-performance IC substrates','at_s_high-performance_ic_substrates','AT&S high-performance IC substrates for AI, data center and automotive electronics.','2026-06-17 08:28:50','2026-06-17 08:28:50',NULL,NULL,NULL,NULL,NULL),(2,'Ibiden flip-chip IC package substrate','ibiden_flip-chip_ic_package_substrate','Ibiden flip-chip package substrate for advanced IC packages.','2026-06-17 08:28:50','2026-06-17 08:28:50',NULL,NULL,NULL,NULL,NULL),(3,'Nan Ya advanced IC substrate','nan_ya_advanced_ic_substrate','Nan Ya PCB advanced IC substrate technology.','2026-06-17 08:28:50','2026-06-17 08:28:50',NULL,NULL,NULL,NULL,NULL),(4,'Shinko flip-chip package substrate','shinko_flip-chip_package_substrate','Shinko flip-chip package substrate and semiconductor package substrate lineup.','2026-06-17 08:28:50','2026-06-17 08:28:50',NULL,NULL,NULL,NULL,NULL),(9,'net_sales','net_sales','','2026-06-18 03:05:29','2026-06-18 03:05:29',NULL,NULL,NULL,NULL,NULL),(10,'operating_profit','operating_profit','','2026-06-18 03:05:29','2026-06-18 03:05:29',NULL,NULL,NULL,NULL,NULL),(11,'profit_attributable','profit_attributable','','2026-06-18 03:05:34','2026-06-18 03:05:34',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `abf_substrate` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accelerometer`
--

DROP TABLE IF EXISTS `accelerometer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accelerometer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `measurement_range` double DEFAULT NULL,
  `sensitivity` double DEFAULT NULL,
  `noise_density` double DEFAULT NULL,
  `output_data_rate` double DEFAULT NULL,
  `current_consumption` double DEFAULT NULL,
  `package_size` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accelerometer`
--

LOCK TABLES `accelerometer` WRITE;
/*!40000 ALTER TABLE `accelerometer` DISABLE KEYS */;
INSERT INTO `accelerometer` VALUES (1,'Bosch Sensortec 3-axis accelerometers','bosch_sensortec_3-axis_accelerometers','Bosch MEMS triaxial accelerometer sensors.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL,NULL),(2,'ST MEMS accelerometers','st_mems_accelerometers','STMicroelectronics MEMS accelerometer products.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `accelerometer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `advanced_packaging_technology`
--

DROP TABLE IF EXISTS `advanced_packaging_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `advanced_packaging_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `packaging_type` varchar(500) DEFAULT NULL,
  `integration_dimension` varchar(500) DEFAULT NULL,
  `max_die_count` double DEFAULT NULL,
  `bandwidth_scaling_factor` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `advanced_packaging_technology`
--

LOCK TABLES `advanced_packaging_technology` WRITE;
/*!40000 ALTER TABLE `advanced_packaging_technology` DISABLE KEYS */;
INSERT INTO `advanced_packaging_technology` VALUES (1,'2.5D封装','2_5d_interposer','通过中介层实现水平互连的2.5D集成','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(2,'2.5D硅中介层','2_5d_silicon_interposer','通过硅中介层实现多芯片水平互连，I/O密度20-100 I/O per mm²，I/O间距100-200μm','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(3,'3D堆叠TSV+μBump','3d_stacking_tsv_micro-bumps','通过硅通孔(TSV)和微凸块(μBump)实现芯片垂直堆叠，I/O密度100-300 I/O per mm²，I/O间距50-100μm','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(4,'3D封装','3d_stacking','通过TSV实现垂直堆叠的3D集成','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(5,'FOPLP','fan-out_plp','扇出型面板级封装','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(6,'FOWLP','fan-out_wlp','扇出型晶圆级封装','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(7,'倒装芯片','flip_chip','通过焊球/凸点将芯片倒装贴装于基板，I/O密度10-15 I/O per mm²，I/O间距>600μm','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(8,'晶圆级封装','wafer_level_packaging','在晶圆上直接完成封装','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(9,'混合键合','hybrid_bonding','无Bump的铜-铜直接键合互连技术，I/O密度>10,000 I/O per mm²，I/O间距<5μm','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(10,'超高密度扇出','ultra_high-density_fan-out','超高密度扇出型封装，I/O密度15-20 I/O per mm²，I/O间距200-300μm','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(11,'面板级封装','panel_level_packaging','在大面板上实现封装，提升面积利用率','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(45,'2.5D封装','2_5d_interposer_1','通过中介层实现水平互连的2.5D集成','2026-06-17 09:47:45','2026-06-17 09:47:45','','',NULL,NULL),(46,'3D封装','3d_stacking_1','通过TSV实现垂直堆叠的3D集成','2026-06-17 09:47:45','2026-06-17 09:47:45','','',NULL,NULL),(47,'面板级封装','panel_level_packaging_1','在大面板上实现封装，提升面积利用率','2026-06-17 09:47:45','2026-06-17 09:47:45','','',NULL,NULL),(48,'晶圆级封装','wafer_level_packaging_1','在晶圆上直接完成封装','2026-06-17 09:47:45','2026-06-17 09:47:45','','',NULL,NULL),(49,'FOWLP','fan-out_wlp_1','扇出型晶圆级封装','2026-06-17 09:47:45','2026-06-17 09:47:45','','',NULL,NULL),(50,'FOPLP','fan-out_plp_1','扇出型面板级封装','2026-06-17 09:47:45','2026-06-17 09:47:45','','',NULL,NULL),(51,'倒装芯片','flip_chip_1','通过焊球/凸点将芯片倒装贴装于基板，I/O密度10-15 I/O per mm²，I/O间距>600μm','2026-06-17 09:47:45','2026-06-17 09:47:45','Flip Chip','2D',1,1),(52,'超高密度扇出','ultra_high-density_fan-out_1','超高密度扇出型封装，I/O密度15-20 I/O per mm²，I/O间距200-300μm','2026-06-17 09:47:45','2026-06-17 09:47:45','Fan-Out','2D',4,2),(53,'2.5D硅中介层','2_5d_silicon_interposer_1','通过硅中介层实现多芯片水平互连，I/O密度20-100 I/O per mm²，I/O间距100-200μm','2026-06-17 09:47:45','2026-06-17 09:47:45','2.5D Interposer','2.5D',8,3),(54,'3D堆叠TSV+μBump','3d_stacking_tsv_micro-bumps_1','通过硅通孔(TSV)和微凸块(μBump)实现芯片垂直堆叠，I/O密度100-300 I/O per mm²，I/O间距50-100μm','2026-06-17 09:47:45','2026-06-17 09:47:45','3D Stacking','3D',16,10),(55,'混合键合','hybrid_bonding_1','无Bump的铜-铜直接键合互连技术，I/O密度>10,000 I/O per mm²，I/O间距<5μm','2026-06-17 09:47:45','2026-06-17 09:47:45','Hybrid Bonding','3D',16,20),(56,'2.5D封装','2_5d_interposer_2','通过中介层实现水平互连的2.5D集成','2026-06-17 09:48:42','2026-06-17 09:48:42','','',NULL,NULL),(57,'3D封装','3d_stacking_2','通过TSV实现垂直堆叠的3D集成','2026-06-17 09:48:42','2026-06-17 09:48:42','','',NULL,NULL),(58,'面板级封装','panel_level_packaging_2','在大面板上实现封装，提升面积利用率','2026-06-17 09:48:42','2026-06-17 09:48:42','','',NULL,NULL),(59,'晶圆级封装','wafer_level_packaging_2','在晶圆上直接完成封装','2026-06-17 09:48:42','2026-06-17 09:48:42','','',NULL,NULL),(60,'FOWLP','fan-out_wlp_2','扇出型晶圆级封装','2026-06-17 09:48:42','2026-06-17 09:48:42','','',NULL,NULL),(61,'FOPLP','fan-out_plp_2','扇出型面板级封装','2026-06-17 09:48:42','2026-06-17 09:48:42','','',NULL,NULL),(62,'倒装芯片','flip_chip_2','通过焊球/凸点将芯片倒装贴装于基板，I/O密度10-15 I/O per mm²，I/O间距>600μm','2026-06-17 09:48:42','2026-06-17 09:48:42','Flip Chip','2D',1,1),(63,'超高密度扇出','ultra_high-density_fan-out_2','超高密度扇出型封装，I/O密度15-20 I/O per mm²，I/O间距200-300μm','2026-06-17 09:48:42','2026-06-17 09:48:42','Fan-Out','2D',4,2),(64,'2.5D硅中介层','2_5d_silicon_interposer_2','通过硅中介层实现多芯片水平互连，I/O密度20-100 I/O per mm²，I/O间距100-200μm','2026-06-17 09:48:42','2026-06-17 09:48:42','2.5D Interposer','2.5D',8,3),(65,'3D堆叠TSV+μBump','3d_stacking_tsv_micro-bumps_2','通过硅通孔(TSV)和微凸块(μBump)实现芯片垂直堆叠，I/O密度100-300 I/O per mm²，I/O间距50-100μm','2026-06-17 09:48:42','2026-06-17 09:48:42','3D Stacking','3D',16,10),(66,'混合键合','hybrid_bonding_2','无Bump的铜-铜直接键合互连技术，I/O密度>10,000 I/O per mm²，I/O间距<5μm','2026-06-17 09:48:42','2026-06-17 09:48:42','Hybrid Bonding','3D',16,20);
/*!40000 ALTER TABLE `advanced_packaging_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assembly_test_service`
--

DROP TABLE IF EXISTS `assembly_test_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assembly_test_service` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `minimum_bump_pitch` double DEFAULT NULL,
  `supported_package_size` varchar(500) DEFAULT NULL,
  `maximum_die_stack_count` bigint DEFAULT NULL,
  `test_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assembly_test_service`
--

LOCK TABLES `assembly_test_service` WRITE;
/*!40000 ALTER TABLE `assembly_test_service` DISABLE KEYS */;
INSERT INTO `assembly_test_service` VALUES (1,'ASE semiconductor assembly and test services','ase_semiconductor_assembly_and_test_services','ASE assembly, advanced packaging and semiconductor test services.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL),(2,'Amkor semiconductor packaging and test services','amkor_semiconductor_packaging_and_test_services','Amkor outsourced semiconductor packaging, design and test services.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL),(3,'JCET turnkey packaging and test services','jcet_turnkey_packaging_and_test_services','JCET package integration, wafer probe, wafer bumping, assembly and final test services.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL),(4,'PTI chip probing packaging and testing services','pti_chip_probing_packaging_and_testing_services','Powertech chip probing, packaging, final testing, burn-in and system-level assembly services.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL),(9,'ASE Technology Holding','ase_technology_holding','','2026-06-18 02:52:45','2026-06-18 02:52:45',NULL,NULL,NULL,NULL),(10,'net_sales','net_sales','','2026-06-18 03:05:23','2026-06-18 03:05:23',NULL,NULL,NULL,NULL),(11,'net_income','net_income','','2026-06-18 03:05:23','2026-06-18 03:05:23',NULL,NULL,NULL,NULL),(12,'gross_margin','gross_margin','','2026-06-18 03:05:24','2026-06-18 03:05:24',NULL,NULL,NULL,NULL),(13,'revenue','revenue','','2026-06-18 03:05:30','2026-06-18 03:05:30',NULL,NULL,NULL,NULL),(14,'profit_before_tax','profit_before_tax','','2026-06-18 03:05:30','2026-06-18 03:05:30',NULL,NULL,NULL,NULL),(15,'net_profit_attributable','net_profit_attributable','','2026-06-18 03:05:30','2026-06-18 03:05:30',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `assembly_test_service` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `automatic_test_equipment`
--

DROP TABLE IF EXISTS `automatic_test_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `automatic_test_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `channel_count` bigint DEFAULT NULL,
  `maximum_data_rate` double DEFAULT NULL,
  `test_frequency` double DEFAULT NULL,
  `voltage_range` varchar(500) DEFAULT NULL,
  `parallel_site_count` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automatic_test_equipment`
--

LOCK TABLES `automatic_test_equipment` WRITE;
/*!40000 ALTER TABLE `automatic_test_equipment` DISABLE KEYS */;
INSERT INTO `automatic_test_equipment` VALUES (1,'Advantest automated test equipment','advantest_automated_test_equipment','Advantest automated semiconductor test equipment.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL),(2,'Teradyne semiconductor test systems','teradyne_semiconductor_test_systems','Teradyne semiconductor automated test equipment.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `automatic_test_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cleaning_technology`
--

DROP TABLE IF EXISTS `cleaning_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cleaning_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cleaning_method` varchar(500) DEFAULT NULL,
  `mechanism` varchar(500) DEFAULT NULL,
  `throughput_characteristic` varchar(500) DEFAULT NULL,
  `cleaning_precision` varchar(500) DEFAULT NULL,
  `cross_contamination_risk` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cleaning_technology`
--

LOCK TABLES `cleaning_technology` WRITE;
/*!40000 ALTER TABLE `cleaning_technology` DISABLE KEYS */;
INSERT INTO `cleaning_technology` VALUES (1,'湿法清洗','wet_cleaning','使用化学药液与晶圆表面杂质发生化学反应，生成溶于水的物质后再用高纯水冲洗（占90%以上清洗步骤）','2026-06-17 09:48:43','2026-06-17 09:48:43','湿法（化学药液）','化学反应溶解','视设备类型而定（单片/槽式）','高（单片）/ 一般（槽式）','低（单片）/ 高（槽式）'),(2,'干法清洗','dry_cleaning','不采用溶液的清洗技术，通过等离子体清洗、气相清洗或束流清洗去除晶圆表面杂质，一般用于去除氧化物、环氧树脂溢出或微颗粒污染物','2026-06-17 09:48:43','2026-06-17 09:48:43','干法（等离子体/气相/束流）','等离子化学反应/气相反应/束流物理去除','中等','高','低'),(3,'单片清洗','single-wafer_cleaning','一次清洗一片晶圆，具有较高的工艺环境控制能力与微粒去除能力，有效解决交叉污染，在先进工艺中成为主流（占比74.6%）','2026-06-17 09:48:43','2026-06-17 09:48:43','旋转喷淋/兆声波/二流体/机械刷洗','物理喷射+化学清洗','低（单片处理）','高','低'),(4,'槽式清洗','batch_cleaning','一批次同时清洗多片晶圆，清洗产能高，适合大批量生产（占比18.1%）','2026-06-17 09:48:43','2026-06-17 09:48:43','溶液浸泡/兆声波','化学浸泡+辅助物理','高（批量处理）','一般','大');
/*!40000 ALTER TABLE `cleaning_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cmos_image_sensor`
--

DROP TABLE IF EXISTS `cmos_image_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cmos_image_sensor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `resolution` double DEFAULT NULL,
  `pixel_size` double DEFAULT NULL,
  `frame_rate` double DEFAULT NULL,
  `optical_format` varchar(500) DEFAULT NULL,
  `dynamic_range` double DEFAULT NULL,
  `output_interface` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cmos_image_sensor`
--

LOCK TABLES `cmos_image_sensor` WRITE;
/*!40000 ALTER TABLE `cmos_image_sensor` DISABLE KEYS */;
INSERT INTO `cmos_image_sensor` VALUES (1,'OMNIVISION CMOS image sensors','omnivision_cmos_image_sensors','OmniVision CMOS image sensor product portfolio.','2026-06-17 08:28:50','2026-06-17 08:28:50',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Sony Semiconductor image sensors','sony_semiconductor_image_sensors','Sony Semiconductor image sensor product portfolio.','2026-06-17 08:28:50','2026-06-17 08:28:50',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `cmos_image_sensor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cmp_equipment`
--

DROP TABLE IF EXISTS `cmp_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cmp_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `supported_wafer_diameter` double DEFAULT NULL,
  `platen_speed` double DEFAULT NULL,
  `downforce` double DEFAULT NULL,
  `removal_rate` double DEFAULT NULL,
  `non_uniformity` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cmp_equipment`
--

LOCK TABLES `cmp_equipment` WRITE;
/*!40000 ALTER TABLE `cmp_equipment` DISABLE KEYS */;
INSERT INTO `cmp_equipment` VALUES (1,'Applied Materials CMP systems','applied_materials_cmp_systems','Applied Materials CMP equipment/process solutions for wafer planarization.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `cmp_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cmp_technology`
--

DROP TABLE IF EXISTS `cmp_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cmp_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cmp_category` varchar(500) DEFAULT NULL,
  `specific_process` varchar(500) DEFAULT NULL,
  `primary_application` varchar(500) DEFAULT NULL,
  `key_material` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cmp_technology`
--

LOCK TABLES `cmp_technology` WRITE;
/*!40000 ALTER TABLE `cmp_technology` DISABLE KEYS */;
INSERT INTO `cmp_technology` VALUES (1,'金属薄膜CMP','metal_film_cmp','针对金属薄膜的化学机械抛光，包括钨/钨阻挡层、铜/铜阻挡层、铝等工艺','2026-06-17 09:48:42','2026-06-17 09:48:42','金属薄膜','钨&钨阻挡层 / 铜&铜阻挡层 / 铝','3D NAND / DRAM / 逻辑 / Metal Gate（28nm及以下）','W, Cu, Al'),(2,'氧化硅薄膜CMP','oxide_film_cmp','针对氧化硅薄膜的化学机械抛光，包括层间介质层（ILD）和浅沟槽隔离层（STI）','2026-06-17 09:48:42','2026-06-17 09:48:42','氧化硅薄膜','层间介质层ILD / 浅沟槽隔离层STI','逻辑 / 3D NAND / DRAM','SiO₂, SiN'),(3,'硅薄膜CMP','silicon_film_cmp','针对硅薄膜的化学机械抛光，包括晶圆表面和多晶硅','2026-06-17 09:48:42','2026-06-17 09:48:42','硅薄膜','晶圆表面 / 多晶硅','3D NAND / DRAM / 逻辑 / 硅片加工','Si, Poly-Si');
/*!40000 ALTER TABLE `cmp_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=644 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'AGY Holding Corp.','agy_holding_corp','Official AGY materials pages confirm L Glass/E-glass fiber yarn for PCB fabrics.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(2,'ASE Technology Holding Co., Ltd.','ase_technology_holding_co_ltd','Official ASE pages confirm semiconductor assembly and test services.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(3,'ASML Holding N.V.','asml_holding_n_v','Official ASML product pages confirm EUV and DUV lithography systems.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(4,'AT&S Austria Technologie & Systemtechnik AG','at_s_austria_technologie_systemtechnik_ag','Official AT&S pages confirm high-end PCBs and IC substrates.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(5,'Advanced Micro Devices Inc.','advanced_micro_devices_inc','Official company/product sources confirm AMD Instinct GPU accelerator products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(6,'Advantest Corporation','advantest_corporation','Official Advantest pages confirm SoC and memory automated test systems.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(7,'Amkor Technology Inc.','amkor_technology_inc','Official Amkor pages confirm semiconductor packaging and test services.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(8,'Applied Materials Inc.','applied_materials_inc','Official Applied Materials pages confirm semiconductor deposition, etch, CMP and other manufacturing equipment.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(9,'Arm Holdings plc','arm_holdings_plc','Official Arm pages confirm processor IP portfolio.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(10,'Bosch Sensortec GmbH','bosch_sensortec_gmbh','Official Bosch Sensortec pages confirm MEMS accelerometers, gyroscopes, magnetometers, pressure, humidity and gas sensors.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(11,'Cadence Design Systems, Inc.','cadence_design_systems_inc','Official Cadence pages confirm EDA software and IP.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(12,'Cambricon Technologies Corporation Limited','cambricon_technologies_corporation_limited','Official Cambricon sources confirm MLU370 and Siyuan AI accelerator products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(13,'ChangXin Memory Technologies Inc.','changxin_memory_technologies_inc','Official CXMT sources confirm DRAM products including DDR5 and LPDDR5/5X; SEMI WFF lists CXMT memory capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(14,'Episil-Precision Inc.','episil-precision_inc','SEMI WFF lists Episil-Precision foundry capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(15,'FormFactor, Inc.','formfactor_inc','Official FormFactor pages confirm probe cards and probe systems.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(16,'GigaDevice Semiconductor Inc.','gigadevice_semiconductor_inc','Official GigaDevice sources confirm SPI NOR, SPI NAND and DRAM products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(17,'GlobalFoundries Inc.','globalfoundries_inc','SEMI WFF lists GlobalFoundries capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(18,'GlobalWafers Co., Ltd.','globalwafers_co_ltd','Official GlobalWafers pages confirm silicon wafer products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(19,'Hua Hong Semiconductor Limited','hua_hong_semiconductor_limited','SEMI WFF lists Hua Hong Semiconductor capacity/spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(20,'Hua Li Microelectronics Corporation','hua_li_microelectronics_corporation','SEMI WFF lists Hua Li Microelectronics capacity/spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(21,'Huawei Technologies Co., Ltd.','huawei_technologies_co_ltd','Official Huawei sources confirm Ascend/Atlas AI computing products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(22,'IBIDEN Co., Ltd.','ibiden_co_ltd','Official Ibiden pages confirm flip-chip IC package substrates.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(23,'Infineon Technologies AG','infineon_technologies_ag','Official Infineon sources confirm SEMPER NOR flash products; SEMI WFF lists Infineon capacity/spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(24,'Intel Corporation','intel_corporation','Official company/product sources confirm Intel Gaudi AI accelerator products; SEMI WFF also lists Intel capacity/spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(25,'Isola Group','isola_group','Official Isola pages confirm PCB laminate and prepreg materials.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(26,'JCET Group Co., Ltd.','jcet_group_co_ltd','Official/company-profile sources confirm semiconductor packaging and test services.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(27,'KIOXIA Corporation','kioxia_corporation','Official Kioxia sources confirm BiCS FLASH and NAND flash products; SEMI WFF lists Kioxia/WD flash capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(28,'KLA Corporation','kla_corporation','Official KLA pages confirm process control, inspection and metrology systems.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(29,'Kingboard Laminates Holdings Ltd.','kingboard_laminates_holdings_ltd','Official Kingboard Laminates site confirms laminate products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(30,'Lam Research Corporation','lam_research_corporation','Official Lam Research pages confirm etch, deposition, strip and clean semiconductor equipment.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(31,'Macronix International Co., Ltd.','macronix_international_co_ltd','Official Macronix sources confirm serial and parallel NOR flash products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(32,'MetaX Integrated Circuits (Shanghai) Co., Ltd.','metax_integrated_circuits_shanghai_co_ltd','Official MetaX sources confirm GPU chips and accelerator card products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(33,'Micron Technology Inc.','micron_technology_inc','Official Micron sources confirm DDR5, HBM3E, GDDR7 and NAND portfolio; SEMI WFF lists Micron memory capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(34,'Mitsui Mining & Smelting Co., Ltd.','mitsui_mining_smelting_co_ltd','Official Mitsui Kinzoku engineered materials page confirms electrolytic copper foil.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(35,'Murata Manufacturing Co., Ltd.','murata_manufacturing_co_ltd','Official Murata pages confirm ceramic capacitor / MLCC products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(36,'NVIDIA Corporation','nvidia_corporation','Official company/product sources confirm NVIDIA data-center GPU and AI accelerator products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(37,'Nan Ya Plastics Corporation','nan_ya_plastics_corporation','Official Nan Ya Plastics electronic materials page confirms copper foils and electronic materials.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(38,'Nan Ya Printed Circuit Board Corporation','nan_ya_printed_circuit_board_corporation','Official Nan Ya PCB site confirms advanced IC substrate and PCB technology.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(39,'Nanya Technology Corporation','nanya_technology_corporation','Official Nanya sources confirm DDR5 and LPDDR5/5X DRAM products; SEMI WFF lists Nanya spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(40,'Navitas Semiconductor Corporation','navitas_semiconductor_corporation','Official Navitas pages confirm GaNFast power ICs/GaNFET products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(41,'Nexchip Semiconductor Corporation','nexchip_semiconductor_corporation','SEMI WFF lists Nexchip foundry capacity; public company references identify it as a foundry.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(42,'Nitto Boseki Co., Ltd.','nitto_boseki_co_ltd','Official Nittobo pages confirm electronic materials glass cloth and NE-glass.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(43,'OMNIVISION Technologies, Inc.','omnivision_technologies_inc','Official OmniVision pages confirm CMOS image sensor products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(44,'Powerchip Semiconductor Manufacturing Corporation','powerchip_semiconductor_manufacturing_corporation','SEMI WFF lists PSMC foundry capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(45,'Powertech Technology Inc.','powertech_technology_inc','Official PTI pages confirm chip probing, packaging and testing services.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(46,'ROHM Co., Ltd.','rohm_co_ltd','Official ROHM pages confirm SiC MOSFET, SiC Schottky barrier diode and GaN HEMT products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(48,'Renesas Electronics Corporation','renesas_electronics_corporation','Official Renesas pages confirm GaN power discrete products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(49,'SEH America Inc.','seh_america_inc','Official SEH America pages confirm silicon wafer products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(50,'SHINKO ELECTRIC INDUSTRIES CO., LTD.','shinko_electric_industries_co_ltd','Official Shinko pages confirm semiconductor package substrates and IC assembly.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(51,'SK hynix Inc.','sk_hynix_inc','Official SK hynix sources confirm DRAM, HBM3E/HBM4 and NAND-storage product portfolio; SEMI WFF lists SK Hynix memory capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(52,'STMicroelectronics N.V.','stmicroelectronics_n_v','SEMI WFF lists STMicroelectronics capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(53,'SUMCO Corporation','sumco_corporation','Official SUMCO pages confirm silicon wafer products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(54,'Samsung Electro-Mechanics Co., Ltd.','samsung_electro-mechanics_co_ltd','Official Samsung Electro-Mechanics pages confirm MLCC and package substrate products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(55,'Samsung Electronics Co. Ltd.','samsung_electronics_co_ltd','Official Samsung Semiconductor sources confirm DRAM, HBM and NAND/V-NAND products; SEMI WFF lists Samsung memory capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(56,'Semiconductor Manufacturing International Corporation','semiconductor_manufacturing_international_corporation','SEMI WFF lists SMIC capacity/spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(57,'Shin-Etsu Chemical Co., Ltd.','shin-etsu_chemical_co_ltd','Official Shin-Etsu pages confirm semiconductor-grade silicon wafers and SOI wafers.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(58,'Siemens EDA','siemens_eda','Official Siemens pages confirm IC design and verification EDA portfolio.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(59,'Siltronic AG','siltronic_ag','Official Siltronic pages confirm silicon wafer products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(60,'Sony Semiconductor Solutions Corporation','sony_semiconductor_solutions_corporation','SEMI WFF lists Sony semiconductor spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(61,'Sumitomo Metal Mining Co., Ltd.','sumitomo_metal_mining_co_ltd','Official SMM page confirms rolled copper foil.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(62,'Synopsys, Inc.','synopsys_inc','Official Synopsys pages confirm EDA and semiconductor IP products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(63,'TDK Corporation','tdk_corporation','Official TDK product pages confirm MLCC products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(64,'TDK InvenSense','tdk_invensense','Official TDK InvenSense pages confirm 6-axis motion sensors and MEMS microphones.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(65,'Taiwan Glass Industry Corporation','taiwan_glass_industry_corporation','Official Taiwan Glass pages confirm glass fibers for electronic application.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(66,'Taiwan Semiconductor Manufacturing Company Limited','taiwan_semiconductor_manufacturing_company_limited','SEMI WFF lists TSMC as a leading capacity/spending company.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(67,'Teradyne, Inc.','teradyne_inc','Official Teradyne pages confirm semiconductor test systems.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(68,'Texas Instruments Incorporated','texas_instruments_incorporated','SEMI WFF lists Texas Instruments capacity/spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(69,'Tokyo Electron Limited','tokyo_electron_limited','Official TEL pages confirm wafer probers.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(70,'United Microelectronics Corporation','united_microelectronics_corporation','SEMI WFF lists UMC capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(71,'Vishay Intertechnology, Inc.','vishay_intertechnology_inc','Official Vishay pages confirm Schottky rectifiers and TVS protection diodes.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(72,'Western Digital Corporation','western_digital_corporation','Official Western Digital sources confirm BiCS 3D NAND collaboration/products; SEMI WFF lists Kioxia/WD flash capacity.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(73,'Winbond Electronics Corporation','winbond_electronics_corporation','Official Winbond sources confirm QSPI NOR and code-storage flash products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(74,'Wolfspeed, Inc.','wolfspeed_inc','Official Wolfspeed pages confirm SiC MOSFET and power products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(75,'YAGEO Corporation','yageo_corporation','Official YAGEO pages confirm multilayer ceramic capacitor products.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(76,'Yangtze Memory Technologies Co., Ltd.','yangtze_memory_technologies_co_ltd','Official YMTC sources confirm Xtacking 3D NAND flash technology/products; SEMI WFF lists YMTC spending.','2026-06-17 08:28:55','2026-06-17 08:28:55'),(77,'onsemi','onsemi','Official onsemi pages confirm MOSFET, IGBT, SiC, diode and power module products.','2026-06-17 08:28:55','2026-06-17 08:28:55');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `copper_clad_laminate`
--

DROP TABLE IF EXISTS `copper_clad_laminate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `copper_clad_laminate` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `laminate_type` varchar(500) DEFAULT NULL,
  `laminate_thickness` double DEFAULT NULL,
  `copper_foil_thickness` double DEFAULT NULL,
  `glass_transition_temperature` double DEFAULT NULL,
  `dielectric_constant` double DEFAULT NULL,
  `dissipation_factor` double DEFAULT NULL,
  `peel_strength` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copper_clad_laminate`
--

LOCK TABLES `copper_clad_laminate` WRITE;
/*!40000 ALTER TABLE `copper_clad_laminate` DISABLE KEYS */;
INSERT INTO `copper_clad_laminate` VALUES (1,'Isola PCB laminates','isola_pcb_laminates','Isola high-performance PCB laminate products.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Kingboard copper clad laminates','kingboard_copper_clad_laminates','Kingboard laminate products for printed circuit board materials.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'Nan Ya copper clad laminates','nan_ya_copper_clad_laminates','Nan Ya copper clad laminate electronic materials.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'revenue','revenue','','2026-06-18 03:05:31','2026-06-18 03:05:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'underlying_net_profit_attributable','underlying_net_profit_attributable','','2026-06-18 03:05:31','2026-06-18 03:05:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `copper_clad_laminate` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cpu_microarchitecture_generation`
--

DROP TABLE IF EXISTS `cpu_microarchitecture_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cpu_microarchitecture_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `release_date` datetime DEFAULT NULL,
  `performance_generation` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cpu_microarchitecture_generation`
--

LOCK TABLES `cpu_microarchitecture_generation` WRITE;
/*!40000 ALTER TABLE `cpu_microarchitecture_generation` DISABLE KEYS */;
INSERT INTO `cpu_microarchitecture_generation` VALUES (1,'Zen 4','zen_4','AMD Zen 4 CPU微架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(2,'Zen 5','zen_5','AMD Zen 5 CPU微架构（最新）','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(11,'Zen 4','zen_4_1','AMD Zen 4 CPU微架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(12,'Zen 5','zen_5_1','AMD Zen 5 CPU微架构（最新）','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(13,'Zen 4','zen_4_2','AMD Zen 4 CPU微架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(14,'Zen 5','zen_5_2','AMD Zen 5 CPU微架构（最新）','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL);
/*!40000 ALTER TABLE `cpu_microarchitecture_generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dram`
--

DROP TABLE IF EXISTS `dram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dram` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `memory_density` double DEFAULT NULL,
  `data_rate` double DEFAULT NULL,
  `io_voltage` double DEFAULT NULL,
  `bus_width` bigint DEFAULT NULL,
  `operating_temperature_range` varchar(500) DEFAULT NULL,
  `dram_generation` varchar(500) DEFAULT NULL,
  `dram_type` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dram`
--

LOCK TABLES `dram` WRITE;
/*!40000 ALTER TABLE `dram` DISABLE KEYS */;
INSERT INTO `dram` VALUES (1,'CXMT DDR5','cxmt_ddr5','CXMT DDR5 chips and modules.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'CXMT LPDDR5/5X','cxmt_lpddr5_5x','CXMT LPDDR5/5X low-power DRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'GigaDevice DDR4 SDRAM','gigadevice_ddr4_sdram','GigaDevice DDR4 DRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'GigaDevice niche DRAM','gigadevice_niche_dram','GigaDevice specialty/niche DRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'Micron DDR5 SDRAM','micron_ddr5_sdram','Micron DDR5 SDRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'Micron DDR5 memory','micron_ddr5_memory','Micron DDR5 memory product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'Micron GDDR7 graphics memory','micron_gddr7_graphics_memory','Micron GDDR7 memory for graphics and AI workloads.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'Nanya DDR5 DRAM','nanya_ddr5_dram','Nanya standard DDR5 DRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,'Nanya LPDDR5/5X DRAM','nanya_lpddr5_5x_dram','Nanya low-power LPDDR5/5X DRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'SK hynix DDR5 DRAM','sk_hynix_ddr5_dram','SK hynix DDR5 DRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,'SK hynix LPDDR5T DRAM','sk_hynix_lpddr5t_dram','SK hynix low-power DRAM generation applied to high-end products.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,'Samsung DDR5 DRAM','samsung_ddr5_dram','Samsung DDR5 DRAM product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,'Samsung DRAM','samsung_dram','Samsung DRAM memory product family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,'Samsung GDDR7 DRAM','samsung_gddr7_dram','Samsung 24Gb GDDR7 DRAM product/technology generation.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(29,'sales_revenue','sales_revenue','','2026-06-18 03:05:22','2026-06-18 03:05:22',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(30,'net_income','net_income','','2026-06-18 03:05:22','2026-06-18 03:05:22',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(31,'gross_margin','gross_margin','','2026-06-18 03:05:22','2026-06-18 03:05:22',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `dram` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dram_generation`
--

DROP TABLE IF EXISTS `dram_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dram_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `data_rate` double DEFAULT NULL,
  `voltage` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dram_generation`
--

LOCK TABLES `dram_generation` WRITE;
/*!40000 ALTER TABLE `dram_generation` DISABLE KEYS */;
INSERT INTO `dram_generation` VALUES (1,'DDR3','ddr3','第三代DDR内存','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(2,'DDR4','ddr4','第四代DDR内存','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(3,'DDR5','ddr5','第五代DDR内存','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(4,'DDR6','ddr6','第六代DDR内存','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(5,'GDDR6','gddr6','图形用DDR6','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(6,'GDDR7','gddr7','图形用DDR7','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(7,'LPDDR5','lpddr5','低功耗DDR5','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(8,'LPDDR6','lpddr6','低功耗DDR6','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL),(41,'DDR3','ddr3_1','第三代DDR内存','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(42,'DDR4','ddr4_1','第四代DDR内存','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(43,'DDR5','ddr5_1','第五代DDR内存','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(44,'DDR6','ddr6_1','第六代DDR内存','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(45,'LPDDR5','lpddr5_1','低功耗DDR5','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(46,'LPDDR6','lpddr6_1','低功耗DDR6','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(47,'GDDR6','gddr6_1','图形用DDR6','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(48,'GDDR7','gddr7_1','图形用DDR7','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(49,'DDR3','ddr3_2','第三代DDR内存','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(50,'DDR4','ddr4_2','第四代DDR内存','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(51,'DDR5','ddr5_2','第五代DDR内存','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(52,'DDR6','ddr6_2','第六代DDR内存','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(53,'LPDDR5','lpddr5_2','低功耗DDR5','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(54,'LPDDR6','lpddr6_2','低功耗DDR6','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(55,'GDDR6','gddr6_2','图形用DDR6','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(56,'GDDR7','gddr7_2','图形用DDR7','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL);
/*!40000 ALTER TABLE `dram_generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `eda_tool`
--

DROP TABLE IF EXISTS `eda_tool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eda_tool` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `supported_process_node` varchar(500) DEFAULT NULL,
  `timing_optimization_target` varchar(500) DEFAULT NULL,
  `power_optimization_target` varchar(500) DEFAULT NULL,
  `area_optimization_target` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eda_tool`
--

LOCK TABLES `eda_tool` WRITE;
/*!40000 ALTER TABLE `eda_tool` DISABLE KEYS */;
INSERT INTO `eda_tool` VALUES (1,'Cadence EDA platform','cadence_eda_platform','Cadence EDA software for intelligent system and IC design.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL),(2,'Siemens EDA IC design and verification portfolio','siemens_eda_ic_design_and_verification_portfolio','Siemens EDA tool flow for IC design, verification and manufacturing.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL),(3,'Synopsys EDA tools','synopsys_eda_tools','Synopsys electronic design automation solutions and services.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `eda_tool` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `edge_ai_accelerator`
--

DROP TABLE IF EXISTS `edge_ai_accelerator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `edge_ai_accelerator` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ai_compute_performance` double DEFAULT NULL,
  `supported_precision_format` varchar(500) DEFAULT NULL,
  `memory_capacity` double DEFAULT NULL,
  `memory_bandwidth` double DEFAULT NULL,
  `thermal_design_power` double DEFAULT NULL,
  `host_interface` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `edge_ai_accelerator`
--

LOCK TABLES `edge_ai_accelerator` WRITE;
/*!40000 ALTER TABLE `edge_ai_accelerator` DISABLE KEYS */;
INSERT INTO `edge_ai_accelerator` VALUES (1,'Cambricon MLU220-M.2','cambricon_mlu220-m_2','Cambricon edge AI accelerator card.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Cambricon Siyuan 220 edge AI chip','cambricon_siyuan_220_edge_ai_chip','Cambricon edge AI chip.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `edge_ai_accelerator` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `electronic_glass_fiber_cloth`
--

DROP TABLE IF EXISTS `electronic_glass_fiber_cloth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `electronic_glass_fiber_cloth` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `glass_fabric_style` varchar(500) DEFAULT NULL,
  `thickness` double DEFAULT NULL,
  `areal_weight` double DEFAULT NULL,
  `weave_density` varchar(500) DEFAULT NULL,
  `weave_type` varchar(500) DEFAULT NULL,
  `dielectric_constant` double DEFAULT NULL,
  `dissipation_factor` double DEFAULT NULL,
  `coefficient_of_thermal_expansion` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `electronic_glass_fiber_cloth`
--

LOCK TABLES `electronic_glass_fiber_cloth` WRITE;
/*!40000 ALTER TABLE `electronic_glass_fiber_cloth` DISABLE KEYS */;
INSERT INTO `electronic_glass_fiber_cloth` VALUES (1,'Nittobo electronic materials glass cloth','nittobo_electronic_materials_glass_cloth','Nittobo glass cloth for printed wiring boards and electronic materials.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Taiwan Glass electronic glass fiber cloth','taiwan_glass_electronic_glass_fiber_cloth','Taiwan Glass glass fibers for electronic application.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `electronic_glass_fiber_cloth` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `electronic_glass_fiber_yarn`
--

DROP TABLE IF EXISTS `electronic_glass_fiber_yarn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `electronic_glass_fiber_yarn` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `filament_diameter` double DEFAULT NULL,
  `yarn_count` double DEFAULT NULL,
  `filament_count` bigint DEFAULT NULL,
  `sizing_type` varchar(500) DEFAULT NULL,
  `dielectric_constant` double DEFAULT NULL,
  `dissipation_factor` double DEFAULT NULL,
  `coefficient_of_thermal_expansion` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `electronic_glass_fiber_yarn`
--

LOCK TABLES `electronic_glass_fiber_yarn` WRITE;
/*!40000 ALTER TABLE `electronic_glass_fiber_yarn` DISABLE KEYS */;
INSERT INTO `electronic_glass_fiber_yarn` VALUES (1,'AGY L Glass fiber yarn','agy_l_glass_fiber_yarn','AGY low-Dk/low-Df glass fiber yarn for PCB fabrics.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Nittobo NE-glass yarn','nittobo_ne-glass_yarn','Nittobo low dielectric NE-glass material for electronic applications.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `electronic_glass_fiber_yarn` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `etch_equipment`
--

DROP TABLE IF EXISTS `etch_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etch_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `supported_wafer_diameter` double DEFAULT NULL,
  `etch_rate` double DEFAULT NULL,
  `etch_uniformity` double DEFAULT NULL,
  `etch_selectivity` varchar(500) DEFAULT NULL,
  `chamber_pressure` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etch_equipment`
--

LOCK TABLES `etch_equipment` WRITE;
/*!40000 ALTER TABLE `etch_equipment` DISABLE KEYS */;
INSERT INTO `etch_equipment` VALUES (1,'Applied Materials etch equipment','applied_materials_etch_equipment','Applied Materials equipment used to shape and remove materials with atomic precision.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL),(2,'Lam Research etch systems','lam_research_etch_systems','Lam Research etch equipment and processes for semiconductor manufacturing.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `etch_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `etching_technology`
--

DROP TABLE IF EXISTS `etching_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etching_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `plasma_generation` varchar(500) DEFAULT NULL,
  `plasma_density` varchar(500) DEFAULT NULL,
  `ion_energy` varchar(500) DEFAULT NULL,
  `target_material` varchar(500) DEFAULT NULL,
  `anisotropic_capability` varchar(500) DEFAULT NULL,
  `control_flexibility` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etching_technology`
--

LOCK TABLES `etching_technology` WRITE;
/*!40000 ALTER TABLE `etching_technology` DISABLE KEYS */;
INSERT INTO `etching_technology` VALUES (1,'CCP介质刻蚀','ccp_dielectric_etching','电容耦合等离子体刻蚀，利用电容耦合产生等离子体，密度较低但能量较高，适合刻蚀氧化物、氮化物等较硬介质材料','2026-06-17 09:48:42','2026-06-17 09:48:42','电容耦合 (CCP)','较低','高','氧化物、氮化物等硬介质材料/掩膜','优秀（可实现各向异性刻蚀）','一般'),(2,'ICP硅刻蚀','icp_silicon_etching','电感耦合等离子体刻蚀，利用电感耦合产生等离子体，密度高、能量较低，可独立控制离子密度和能量，适合刻蚀单晶硅、多晶硅、金属等','2026-06-17 09:48:42','2026-06-17 09:48:42','电感耦合 (ICP)','高','较低','单晶硅、多晶硅、金属等较软/较薄材料','优秀','高（可独立控制离子密度和能量）');
/*!40000 ALTER TABLE `etching_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `front_end_inspection_equipment`
--

DROP TABLE IF EXISTS `front_end_inspection_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_end_inspection_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `inspection_resolution` double DEFAULT NULL,
  `defect_sensitivity` double DEFAULT NULL,
  `throughput` double DEFAULT NULL,
  `wafer_size` double DEFAULT NULL,
  `inspection_mode` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `front_end_inspection_equipment`
--

LOCK TABLES `front_end_inspection_equipment` WRITE;
/*!40000 ALTER TABLE `front_end_inspection_equipment` DISABLE KEYS */;
INSERT INTO `front_end_inspection_equipment` VALUES (1,'KLA wafer inspection systems','kla_wafer_inspection_systems','KLA process-control and inspection systems for semiconductor manufacturing.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `front_end_inspection_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `front_end_metrology_equipment`
--

DROP TABLE IF EXISTS `front_end_metrology_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_end_metrology_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `metrology_accuracy` double DEFAULT NULL,
  `repeatability` double DEFAULT NULL,
  `wafer_size` double DEFAULT NULL,
  `measurement_item` varchar(500) DEFAULT NULL,
  `throughput` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `front_end_metrology_equipment`
--

LOCK TABLES `front_end_metrology_equipment` WRITE;
/*!40000 ALTER TABLE `front_end_metrology_equipment` DISABLE KEYS */;
INSERT INTO `front_end_metrology_equipment` VALUES (1,'KLA metrology systems','kla_metrology_systems','KLA process-control and metrology systems for semiconductor manufacturing.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `front_end_metrology_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gan_hemt`
--

DROP TABLE IF EXISTS `gan_hemt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gan_hemt` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `drain_source_voltage` double DEFAULT NULL,
  `continuous_drain_current` double DEFAULT NULL,
  `on_resistance` double DEFAULT NULL,
  `total_gate_charge` double DEFAULT NULL,
  `switching_frequency` double DEFAULT NULL,
  `junction_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gan_hemt`
--

LOCK TABLES `gan_hemt` WRITE;
/*!40000 ALTER TABLE `gan_hemt` DISABLE KEYS */;
INSERT INTO `gan_hemt` VALUES (1,'Infineon CoolGaN transistors','infineon_coolgan_transistors','Infineon CoolGaN transistor/GaN HEMT portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Navitas GaNFast power ICs','navitas_ganfast_power_ics','Navitas GaNFast and GaNSense GaN power IC product family.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(3,'ROHM EcoGaN HEMT','rohm_ecogan_hemt','ROHM 650V GaN HEMT / EcoGaN product family.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Renesas GaN power discretes','renesas_gan_power_discretes','Renesas gallium nitride power discrete products.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(9,'revenue','revenue','','2026-06-18 03:05:31','2026-06-18 03:05:31',NULL,NULL,NULL,NULL,NULL,NULL),(10,'gross_margin','gross_margin','','2026-06-18 03:05:31','2026-06-18 03:05:31',NULL,NULL,NULL,NULL,NULL,NULL),(11,'net_income','net_income','','2026-06-18 03:05:31','2026-06-18 03:05:31',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `gan_hemt` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gpu_architecture_generation`
--

DROP TABLE IF EXISTS `gpu_architecture_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpu_architecture_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `release_date` datetime DEFAULT NULL,
  `target_workload` varchar(500) DEFAULT NULL,
  `performance_generation` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpu_architecture_generation`
--

LOCK TABLES `gpu_architecture_generation` WRITE;
/*!40000 ALTER TABLE `gpu_architecture_generation` DISABLE KEYS */;
INSERT INTO `gpu_architecture_generation` VALUES (1,'Ada Lovelace','ada_lovelace','NVIDIA RTX 40系GPU架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(2,'Ampere','ampere','NVIDIA Ampere GPU架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(3,'Blackwell','blackwell','NVIDIA Blackwell GPU架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(4,'CDNA','cdna','AMD计算GPU架构系列','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(5,'CDNA 3','cdna_3','AMD CDNA 3代计算架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(6,'Hopper','hopper','NVIDIA Hopper GPU架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(7,'RDNA','rdna','AMD图形GPU架构系列','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(8,'Turing','turing','NVIDIA Turing GPU架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(9,'Volta','volta','NVIDIA Volta GPU架构','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL),(46,'Hopper','hopper_1','NVIDIA Hopper GPU架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(47,'Blackwell','blackwell_1','NVIDIA Blackwell GPU架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(48,'Ada Lovelace','ada_lovelace_1','NVIDIA RTX 40系GPU架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(49,'Volta','volta_1','NVIDIA Volta GPU架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(50,'Ampere','ampere_1','NVIDIA Ampere GPU架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(51,'Turing','turing_1','NVIDIA Turing GPU架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(52,'CDNA','cdna_1','AMD计算GPU架构系列','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(53,'CDNA 3','cdna_3_1','AMD CDNA 3代计算架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(54,'RDNA','rdna_1','AMD图形GPU架构系列','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(55,'Hopper','hopper_2','NVIDIA Hopper GPU架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(56,'Blackwell','blackwell_2','NVIDIA Blackwell GPU架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(57,'Ada Lovelace','ada_lovelace_2','NVIDIA RTX 40系GPU架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(58,'Volta','volta_2','NVIDIA Volta GPU架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(59,'Ampere','ampere_2','NVIDIA Ampere GPU架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(60,'Turing','turing_2','NVIDIA Turing GPU架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(61,'CDNA','cdna_2','AMD计算GPU架构系列','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(62,'CDNA 3','cdna_3_2','AMD CDNA 3代计算架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(63,'RDNA','rdna_2','AMD图形GPU架构系列','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL);
/*!40000 ALTER TABLE `gpu_architecture_generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:10
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `graphics_processing_unit`
--

DROP TABLE IF EXISTS `graphics_processing_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graphics_processing_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `shader_core_count` bigint DEFAULT NULL,
  `matrix_core_count` bigint DEFAULT NULL,
  `graphics_memory_capacity` double DEFAULT NULL,
  `memory_bandwidth` double DEFAULT NULL,
  `thermal_design_power` double DEFAULT NULL,
  `process_node` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graphics_processing_unit`
--

LOCK TABLES `graphics_processing_unit` WRITE;
/*!40000 ALTER TABLE `graphics_processing_unit` DISABLE KEYS */;
INSERT INTO `graphics_processing_unit` VALUES (1,'AMD Instinct MI300X','amd_instinct_mi300x','AMD Instinct data-center GPU accelerator for AI and HPC.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(2,'AMD Instinct MI325X','amd_instinct_mi325x','AMD Instinct MI300-series GPU accelerator.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(3,'AMD Instinct MI350 Series','amd_instinct_mi350_series','AMD CDNA 4 data-center GPU accelerator series for AI/HPC.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(4,'MetaX C500 GPU accelerator','metax_c500_gpu_accelerator','MetaX C-series GPU accelerator product.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(5,'MetaX N100 GPU accelerator','metax_n100_gpu_accelerator','MetaX N-series GPU accelerator product.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(6,'MetaX N260 GPU accelerator','metax_n260_gpu_accelerator','MetaX N-series GPU accelerator product.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(7,'NVIDIA B200 Tensor Core GPU','nvidia_b200_tensor_core_gpu','Blackwell-generation data-center GPU used in B200/DGX B200 systems.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(8,'NVIDIA Blackwell Ultra GPU','nvidia_blackwell_ultra_gpu','Blackwell Ultra architecture family GPU for AI factories.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(9,'NVIDIA H100 Tensor Core GPU','nvidia_h100_tensor_core_gpu','NVIDIA Hopper-generation data-center GPU for AI and HPC.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(10,'NVIDIA H200 Tensor Core GPU','nvidia_h200_tensor_core_gpu','Data-center GPU product in NVIDIA H200 family.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(11,'NVIDIA Rubin GPU','nvidia_rubin_gpu','Rubin-generation data-center GPU referenced by NVIDIA HGX platform.','2026-06-17 08:28:51','2026-06-17 08:28:51',NULL,NULL,NULL,NULL,NULL,NULL),(23,'NVIDIA B200 inference cost','nvidia_b200_inference_cost','','2026-06-18 02:52:38','2026-06-18 02:52:38',NULL,NULL,NULL,NULL,NULL,NULL),(24,'NVIDIA RTX PRO 6000 Blackwell Workstation Edition','nvidia_rtx_pro_6000_blackwell_workstation_edition','','2026-06-18 02:52:38','2026-06-18 02:52:38',NULL,NULL,NULL,NULL,NULL,NULL),(25,'Intel Arc B580 Limited Edition','intel_arc_b580_limited_edition','','2026-06-18 02:52:38','2026-06-18 02:52:38',NULL,NULL,NULL,NULL,NULL,NULL),(26,'gross_margin','gross_margin','','2026-06-18 03:05:17','2026-06-18 03:05:17',NULL,NULL,NULL,NULL,NULL,NULL),(27,'net_income','net_income','','2026-06-18 03:05:17','2026-06-18 03:05:17',NULL,NULL,NULL,NULL,NULL,NULL),(28,'operating_income','operating_income','','2026-06-18 03:05:17','2026-06-18 03:05:17',NULL,NULL,NULL,NULL,NULL,NULL),(29,'revenue','revenue','','2026-06-18 03:05:17','2026-06-18 03:05:17',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `graphics_processing_unit` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gyroscope`
--

DROP TABLE IF EXISTS `gyroscope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gyroscope` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `angular_rate_range` double DEFAULT NULL,
  `sensitivity` double DEFAULT NULL,
  `noise_density` double DEFAULT NULL,
  `output_data_rate` double DEFAULT NULL,
  `current_consumption` double DEFAULT NULL,
  `operating_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gyroscope`
--

LOCK TABLES `gyroscope` WRITE;
/*!40000 ALTER TABLE `gyroscope` DISABLE KEYS */;
INSERT INTO `gyroscope` VALUES (1,'Bosch Sensortec gyroscopes','bosch_sensortec_gyroscopes','Bosch gyroscope and motion sensor products.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(2,'TDK InvenSense gyroscope sensors','tdk_invensense_gyroscope_sensors','TDK InvenSense gyroscope and 6-axis motion sensor products.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `gyroscope` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `hbm_generation`
--

DROP TABLE IF EXISTS `hbm_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hbm_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `bandwidth` double DEFAULT NULL,
  `stack_layers` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hbm_generation`
--

LOCK TABLES `hbm_generation` WRITE;
/*!40000 ALTER TABLE `hbm_generation` DISABLE KEYS */;
INSERT INTO `hbm_generation` VALUES (1,'HBM2','hbm2','第二代HBM','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL),(2,'HBM2E','hbm2e','HBM2扩展版','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL),(3,'HBM3','hbm3','第三代HBM','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL),(4,'HBM3E','hbm3e','HBM3扩展版','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL),(5,'HBM4','hbm4','第四代HBM（预计2026年量产）','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL),(26,'HBM2','hbm2_1','第二代HBM','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(27,'HBM2E','hbm2e_1','HBM2扩展版','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(28,'HBM3','hbm3_1','第三代HBM','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(29,'HBM3E','hbm3e_1','HBM3扩展版','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(30,'HBM4','hbm4_1','第四代HBM（预计2026年量产）','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL),(31,'HBM2','hbm2_2','第二代HBM','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(32,'HBM2E','hbm2e_2','HBM2扩展版','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(33,'HBM3','hbm3_2','第三代HBM','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(34,'HBM3E','hbm3e_2','HBM3扩展版','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(35,'HBM4','hbm4_2','第四代HBM（预计2026年量产）','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL);
/*!40000 ALTER TABLE `hbm_generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `high_bandwidth_memory`
--

DROP TABLE IF EXISTS `high_bandwidth_memory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `high_bandwidth_memory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `generation` varchar(500) DEFAULT NULL,
  `stack_height` bigint DEFAULT NULL,
  `capacity_per_stack` double DEFAULT NULL,
  `pin_speed` double DEFAULT NULL,
  `bandwidth_per_stack` double DEFAULT NULL,
  `io_width` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `high_bandwidth_memory`
--

LOCK TABLES `high_bandwidth_memory` WRITE;
/*!40000 ALTER TABLE `high_bandwidth_memory` DISABLE KEYS */;
INSERT INTO `high_bandwidth_memory` VALUES (1,'Micron HBM3E','micron_hbm3e','Micron high-bandwidth memory generation HBM3E.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Micron HBM3E 12H 36GB','micron_hbm3e_12h_36gb','Micron 12-high 36GB HBM3E product.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(3,'Micron HBM3E 8H 24GB','micron_hbm3e_8h_24gb','Micron 8-high 24GB HBM3E product.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(4,'SK hynix HBM3E','sk_hynix_hbm3e','SK hynix high-bandwidth memory generation HBM3E.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(5,'SK hynix HBM4','sk_hynix_hbm4','SK hynix HBM4 high-bandwidth memory generation.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(6,'Samsung HBM3E','samsung_hbm3e','Samsung high-bandwidth memory generation HBM3E.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(7,'Samsung HBM3E 12H','samsung_hbm3e_12h','Samsung 12-stack HBM3E high-bandwidth memory.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(8,'Samsung HBM3E Shinebolt','samsung_hbm3e_shinebolt','Samsung HBM3E product announced as Shinebolt.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `high_bandwidth_memory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `idm`
--

DROP TABLE IF EXISTS `idm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `idm` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mass_production_node` double DEFAULT NULL,
  `max_wafer_diameter` double DEFAULT NULL,
  `monthly_wafer_capacity` double DEFAULT NULL,
  `product_voltage_rating` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `idm`
--

LOCK TABLES `idm` WRITE;
/*!40000 ALTER TABLE `idm` DISABLE KEYS */;
INSERT INTO `idm` VALUES (1,'Infineon power semiconductor IDM','infineon_power_semiconductor_idm','Infineon power semiconductor, microcontroller and system solution portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL),(2,'Intel IDM semiconductor manufacturing','intel_idm_semiconductor_manufacturing','Intel integrated device manufacturing and Intel Foundry strategy.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL),(3,'Micron memory IDM','micron_memory_idm','Micron memory and storage product manufacturing portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL),(4,'SK hynix memory IDM','sk_hynix_memory_idm','SK hynix memory design and manufacturing portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL),(5,'STMicroelectronics integrated semiconductor manufacturing','stmicroelectronics_integrated_semiconductor_manufacturing','ST semiconductor portfolio spanning MCU, analog, power and sensors.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL),(6,'Samsung memory and logic IDM','samsung_memory_and_logic_idm','Samsung integrated semiconductor manufacturing across memory and foundry/logic portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL),(7,'Sony Semiconductor image sensor manufacturing','sony_semiconductor_image_sensor_manufacturing','Sony semiconductor manufacturing capacity listed in SEMI WFF.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL),(8,'Texas Instruments analog and embedded IDM','texas_instruments_analog_and_embedded_idm','TI designs, manufactures, tests and sells analog and embedded processing chips.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `idm` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `igbt`
--

DROP TABLE IF EXISTS `igbt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `igbt` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `collector_emitter_voltage` double DEFAULT NULL,
  `collector_current` double DEFAULT NULL,
  `saturation_voltage` double DEFAULT NULL,
  `switching_frequency` double DEFAULT NULL,
  `short_circuit_withstand_time` double DEFAULT NULL,
  `junction_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `igbt`
--

LOCK TABLES `igbt` WRITE;
/*!40000 ALTER TABLE `igbt` DISABLE KEYS */;
INSERT INTO `igbt` VALUES (1,'Infineon IGBT products','infineon_igbt_products','Infineon IGBT power semiconductor product portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(2,'onsemi IGBT modules','onsemi_igbt_modules','onsemi power module portfolio including IGBT modules.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `igbt` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `inertial_measurement_unit`
--

DROP TABLE IF EXISTS `inertial_measurement_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inertial_measurement_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `acceleration_range` double DEFAULT NULL,
  `angular_rate_range` double DEFAULT NULL,
  `axis_count` bigint DEFAULT NULL,
  `output_data_rate` double DEFAULT NULL,
  `current_consumption` double DEFAULT NULL,
  `package_size` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inertial_measurement_unit`
--

LOCK TABLES `inertial_measurement_unit` WRITE;
/*!40000 ALTER TABLE `inertial_measurement_unit` DISABLE KEYS */;
INSERT INTO `inertial_measurement_unit` VALUES (1,'Bosch Sensortec IMUs','bosch_sensortec_imus','Bosch inertial measurement units integrating accelerometer and gyroscope.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(2,'TDK InvenSense ICM-45605 6-axis motion sensor','tdk_invensense_icm-45605_6-axis_motion_sensor','TDK InvenSense 6-axis MEMS motion sensor family.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `inertial_measurement_unit` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `inference_accelerator`
--

DROP TABLE IF EXISTS `inference_accelerator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inference_accelerator` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ai_compute_performance` double DEFAULT NULL,
  `supported_precision_format` varchar(500) DEFAULT NULL,
  `memory_capacity` double DEFAULT NULL,
  `memory_bandwidth` double DEFAULT NULL,
  `thermal_design_power` double DEFAULT NULL,
  `host_interface` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inference_accelerator`
--

LOCK TABLES `inference_accelerator` WRITE;
/*!40000 ALTER TABLE `inference_accelerator` DISABLE KEYS */;
INSERT INTO `inference_accelerator` VALUES (1,'AMD Instinct MI325X','amd_instinct_mi325x','AMD accelerator for training and inference.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(2,'AMD Instinct MI350 Series','amd_instinct_mi350_series','AMD accelerator series for generative AI and inference.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(3,'Cambricon MLU370-S4','cambricon_mlu370-s4','Cambricon cloud inference AI accelerator card.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Cambricon MLU370-S4 cloud inference AI accelerator','cambricon_mlu370-s4_cloud_inference_ai_accelerator','Cambricon MLU370-S4 cloud inference AI accelerator card.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(5,'Cambricon MLU370-X4','cambricon_mlu370-x4','Cambricon cloud AI accelerator card for training/inference.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(6,'Huawei Ascend 310 AI Processor','huawei_ascend_310_ai_processor','Huawei Ascend inference AI processor.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(7,'Huawei Ascend 910 AI Processor','huawei_ascend_910_ai_processor','Huawei Ascend AI processor used across training and inference systems.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(8,'Intel Gaudi 3 AI Accelerator','intel_gaudi_3_ai_accelerator','Intel AI accelerator for inference and training.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(9,'NVIDIA B200 Tensor Core GPU','nvidia_b200_tensor_core_gpu','Blackwell-generation accelerator for high-throughput inference.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL),(10,'NVIDIA H200 Tensor Core GPU','nvidia_h200_tensor_core_gpu','Data-center GPU used for AI inference and HPC.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `inference_accelerator` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `interconnect_architecture`
--

DROP TABLE IF EXISTS `interconnect_architecture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interconnect_architecture` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `scope` varchar(500) DEFAULT NULL,
  `bandwidth_level` varchar(500) DEFAULT NULL,
  `latency_characteristic` varchar(500) DEFAULT NULL,
  `topology` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interconnect_architecture`
--

LOCK TABLES `interconnect_architecture` WRITE;
/*!40000 ALTER TABLE `interconnect_architecture` DISABLE KEYS */;
INSERT INTO `interconnect_architecture` VALUES (1,'Infinity Fabric','infinity_fabric','AMD高速互连架构','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(2,'NVLink','nvlink','NVIDIA高速GPU互连','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(3,'Xe Link','xe_link','Intel GPU互连链路','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL),(16,'NVLink','nvlink_1','NVIDIA高速GPU互连','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(17,'Infinity Fabric','infinity_fabric_1','AMD高速互连架构','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(18,'Xe Link','xe_link_1','Intel GPU互连链路','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(19,'NVLink','nvlink_2','NVIDIA高速GPU互连','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(20,'Infinity Fabric','infinity_fabric_2','AMD高速互连架构','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(21,'Xe Link','xe_link_2','Intel GPU互连链路','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `interconnect_architecture` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `interconnect_standard`
--

DROP TABLE IF EXISTS `interconnect_standard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interconnect_standard` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `governing_body` varchar(500) DEFAULT NULL,
  `protocol_layer` varchar(500) DEFAULT NULL,
  `max_bandwidth` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interconnect_standard`
--

LOCK TABLES `interconnect_standard` WRITE;
/*!40000 ALTER TABLE `interconnect_standard` DISABLE KEYS */;
INSERT INTO `interconnect_standard` VALUES (1,'AIB','advanced_interface_bus','高级接口总线（Intel Die-to-Die）','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL),(2,'BoW','bridge_of_wires','简易桥接Die-to-Die标准','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL),(3,'CCIX','cache_coherent_interconnect_for_accelerators','加速器缓存一致性互连','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL),(4,'CXL','compute_express_link','计算快速链接，存算分离接口','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL),(5,'InfiniBand','infiniband','高性能计算互连网络','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL),(6,'PCIe','pci_express','通用外设互连标准','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL),(7,'UCIe','universal_chiplet_interconnect_express','通用芯粒互连标准','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL),(36,'PCIe','pci_express_1','通用外设互连标准','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(37,'CXL','compute_express_link_1','计算快速链接，存算分离接口','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(38,'UCIe','universal_chiplet_interconnect_express_1','通用芯粒互连标准','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(39,'BoW','bridge_of_wires_1','简易桥接Die-to-Die标准','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(40,'AIB','advanced_interface_bus_1','高级接口总线（Intel Die-to-Die）','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(41,'CCIX','cache_coherent_interconnect_for_accelerators_1','加速器缓存一致性互连','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(42,'InfiniBand','infiniband_1','高性能计算互连网络','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL),(43,'PCIe','pci_express_2','通用外设互连标准','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(44,'CXL','compute_express_link_2','计算快速链接，存算分离接口','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(45,'UCIe','universal_chiplet_interconnect_express_2','通用芯粒互连标准','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(46,'BoW','bridge_of_wires_2','简易桥接Die-to-Die标准','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(47,'AIB','advanced_interface_bus_2','高级接口总线（Intel Die-to-Die）','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(48,'CCIX','cache_coherent_interconnect_for_accelerators_2','加速器缓存一致性互连','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL),(49,'InfiniBand','infiniband_2','高性能计算互连网络','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL);
/*!40000 ALTER TABLE `interconnect_standard` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ion_implantation_technology`
--

DROP TABLE IF EXISTS `ion_implantation_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ion_implantation_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `energy_level` varchar(500) DEFAULT NULL,
  `energy_range` varchar(500) DEFAULT NULL,
  `beam_current_level` varchar(500) DEFAULT NULL,
  `beam_current_range` varchar(500) DEFAULT NULL,
  `target_application` varchar(500) DEFAULT NULL,
  `implantation_characteristic` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ion_implantation_technology`
--

LOCK TABLES `ion_implantation_technology` WRITE;
/*!40000 ALTER TABLE `ion_implantation_technology` DISABLE KEYS */;
INSERT INTO `ion_implantation_technology` VALUES (1,'低能大束流离子注入','low-energy_high-current_ion_implantation','能量<180keV、电流>10mA，应用于高端制程逻辑芯片(3-45nm)、FPGA、CPU、DRAM、3D存储器等','2026-06-17 09:48:43','2026-06-17 09:48:43','低能量','<180keV','大束流','>10mA（可达25mA）','高端逻辑芯片(3-45nm)、FPGA、CPU、DRAM、3D NAND','高剂量注入、束流固定扫描硅片'),(2,'高能离子注入','high-energy_ion_implantation','能量>200keV，量级最高可达MeV，应用于功率器件IGBT、5G射频、光通信芯片等深结结构','2026-06-17 09:48:43','2026-06-17 09:48:43','高能量','>200keV（最高MeV级）','视需求','视需求','IGBT功率器件、5G射频、光通信芯片、CIS','深结注入'),(3,'中低束流离子注入','medium-low_current_ion_implantation','电流<10mA，硅片固定、扫描离子束，用于中等剂量注入需求','2026-06-17 09:48:43','2026-06-17 09:48:43','视需求','视需求','中低束流','<10mA','一般IC制造','中等剂量、扫描离子束');
/*!40000 ALTER TABLE `ion_implantation_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `isa_generation`
--

DROP TABLE IF EXISTS `isa_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `isa_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `architecture_type` varchar(500) DEFAULT NULL,
  `maintainer` varchar(500) DEFAULT NULL,
  `openness` varchar(500) DEFAULT NULL,
  `ecosystem_maturity` varchar(500) DEFAULT NULL,
  `target_market` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `isa_generation`
--

LOCK TABLES `isa_generation` WRITE;
/*!40000 ALTER TABLE `isa_generation` DISABLE KEYS */;
INSERT INTO `isa_generation` VALUES (1,'ARMv8','armv8','ARM 64位架构','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL),(2,'ARMv9','armv9','ARM新一代架构','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL),(3,'RISC-V','risc-v','开源精简指令集架构','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL),(4,'x86','x86','Intel/AMD 复杂指令集架构','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL),(21,'ARMv8','armv8_1','ARM 64位架构','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(22,'ARMv9','armv9_1','ARM新一代架构','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(23,'RISC-V','risc-v_1','开源精简指令集架构','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(24,'x86','x86_1','Intel/AMD 复杂指令集架构','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(25,'ARMv8','armv8_2','ARM 64位架构','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL,NULL),(26,'ARMv9','armv9_2','ARM新一代架构','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL,NULL),(27,'RISC-V','risc-v_2','开源精简指令集架构','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL,NULL),(28,'x86','x86_2','Intel/AMD 复杂指令集架构','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `isa_generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `lithography_expose_and_write_equipment`
--

DROP TABLE IF EXISTS `lithography_expose_and_write_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lithography_expose_and_write_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `exposure_wavelength` double DEFAULT NULL,
  `numerical_aperture` double DEFAULT NULL,
  `overlay_accuracy` double DEFAULT NULL,
  `throughput` double DEFAULT NULL,
  `supported_wafer_diameter` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lithography_expose_and_write_equipment`
--

LOCK TABLES `lithography_expose_and_write_equipment` WRITE;
/*!40000 ALTER TABLE `lithography_expose_and_write_equipment` DISABLE KEYS */;
INSERT INTO `lithography_expose_and_write_equipment` VALUES (1,'ASML DUV lithography systems','asml_duv_lithography_systems','ASML DUV lithography systems for high-volume chip manufacturing.','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(2,'ASML EUV lithography systems','asml_euv_lithography_systems','ASML EUV lithography systems for advanced logic and memory manufacturing.','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(5,'gross_margin','gross_margin','','2026-06-18 03:05:16','2026-06-18 03:05:16',NULL,NULL,NULL,NULL,NULL),(6,'net_income','net_income','','2026-06-18 03:05:16','2026-06-18 03:05:16',NULL,NULL,NULL,NULL,NULL),(7,'net_sales','net_sales','','2026-06-18 03:05:16','2026-06-18 03:05:16',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `lithography_expose_and_write_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `lithography_technology`
--

DROP TABLE IF EXISTS `lithography_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lithography_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `wavelength` double DEFAULT NULL,
  `resolution_limit` double DEFAULT NULL,
  `wafer_cost_impact` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lithography_technology`
--

LOCK TABLES `lithography_technology` WRITE;
/*!40000 ALTER TABLE `lithography_technology` DISABLE KEYS */;
INSERT INTO `lithography_technology` VALUES (1,'ArF','arf','第四代深紫外光源光刻技术，准分子激光ArF（193nm），步进扫描投影式/浸没式曝光，制程130-14nm，目前最主流的量产光刻技术','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL),(2,'DUV','duv','深紫外光刻','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL),(3,'EUV','euv','极紫外光刻，7nm及以下制程关键','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL),(4,'G-line','g-line','第一代紫外光源光刻技术，采用汞灯的G线（438nm），接触式/接近式曝光','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL),(5,'High-NA EUV','high-na_euv','高数值孔径EUV，3nm以下制程关键','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL),(6,'I-line','i-line','第二代紫外光源光刻技术，采用汞灯的I线（365nm），接触式/接近式曝光，制程800-250nm','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL),(7,'KrF','krf','第三代深紫外光源光刻技术，准分子激光KrF（248nm），扫描投影式曝光，制程180-130nm','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL),(29,'DUV','duv_1','深紫外光刻','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,''),(30,'EUV','euv_1','极紫外光刻，7nm及以下制程关键','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,''),(31,'High-NA EUV','high-na_euv_1','高数值孔径EUV，3nm以下制程关键','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,''),(32,'G-line','g-line_1','第一代紫外光源光刻技术，采用汞灯的G线（438nm），接触式/接近式曝光','2026-06-17 09:47:46','2026-06-17 09:47:46',438,800,'低端已淘汰'),(33,'I-line','i-line_1','第二代紫外光源光刻技术，采用汞灯的I线（365nm），接触式/接近式曝光，制程800-250nm','2026-06-17 09:47:46','2026-06-17 09:47:46',365,250,'低端'),(34,'KrF','krf_1','第三代深紫外光源光刻技术，准分子激光KrF（248nm），扫描投影式曝光，制程180-130nm','2026-06-17 09:47:46','2026-06-17 09:47:46',248,130,'成熟，成本适中'),(35,'ArF','arf_1','第四代深紫外光源光刻技术，准分子激光ArF（193nm），步进扫描投影式/浸没式曝光，制程130-14nm，目前最主流的量产光刻技术','2026-06-17 09:47:46','2026-06-17 09:47:46',193,14,'高（先进制程主力）'),(36,'DUV','duv_2','深紫外光刻','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,''),(37,'EUV','euv_2','极紫外光刻，7nm及以下制程关键','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,''),(38,'High-NA EUV','high-na_euv_2','高数值孔径EUV，3nm以下制程关键','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,''),(39,'G-line','g-line_2','第一代紫外光源光刻技术，采用汞灯的G线（438nm），接触式/接近式曝光','2026-06-17 09:48:42','2026-06-17 09:48:42',438,800,'低端已淘汰'),(40,'I-line','i-line_2','第二代紫外光源光刻技术，采用汞灯的I线（365nm），接触式/接近式曝光，制程800-250nm','2026-06-17 09:48:42','2026-06-17 09:48:42',365,250,'低端'),(41,'KrF','krf_2','第三代深紫外光源光刻技术，准分子激光KrF（248nm），扫描投影式曝光，制程180-130nm','2026-06-17 09:48:42','2026-06-17 09:48:42',248,130,'成熟，成本适中'),(42,'ArF','arf_2','第四代深紫外光源光刻技术，准分子激光ArF（193nm），步进扫描投影式/浸没式曝光，制程130-14nm，目前最主流的量产光刻技术','2026-06-17 09:48:42','2026-06-17 09:48:42',193,14,'高（先进制程主力）');
/*!40000 ALTER TABLE `lithography_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `magnetic_sensor`
--

DROP TABLE IF EXISTS `magnetic_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `magnetic_sensor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `magnetic_field_range` double DEFAULT NULL,
  `sensitivity` double DEFAULT NULL,
  `resolution` double DEFAULT NULL,
  `output_data_rate` double DEFAULT NULL,
  `current_consumption` double DEFAULT NULL,
  `operating_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `magnetic_sensor`
--

LOCK TABLES `magnetic_sensor` WRITE;
/*!40000 ALTER TABLE `magnetic_sensor` DISABLE KEYS */;
INSERT INTO `magnetic_sensor` VALUES (1,'Bosch Sensortec magnetometers','bosch_sensortec_magnetometers','Bosch magnetometer and geomagnetic MEMS sensor products.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `magnetic_sensor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `memory_test_equipment`
--

DROP TABLE IF EXISTS `memory_test_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `memory_test_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pin_count` bigint DEFAULT NULL,
  `data_rate` double DEFAULT NULL,
  `voltage_range` varchar(500) DEFAULT NULL,
  `parallel_test_sites` bigint DEFAULT NULL,
  `test_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `memory_test_equipment`
--

LOCK TABLES `memory_test_equipment` WRITE;
/*!40000 ALTER TABLE `memory_test_equipment` DISABLE KEYS */;
INSERT INTO `memory_test_equipment` VALUES (1,'Advantest T5800 memory test systems','advantest_t5800_memory_test_systems','Advantest memory test systems optimized for volume production of memory semiconductors.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL),(2,'Teradyne memory test systems','teradyne_memory_test_systems','Teradyne semiconductor test equipment for memory and mixed device portfolios.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `memory_test_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `mems_microphone`
--

DROP TABLE IF EXISTS `mems_microphone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mems_microphone` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sensitivity` double DEFAULT NULL,
  `signal_to_noise_ratio` double DEFAULT NULL,
  `acoustic_overload_point` double DEFAULT NULL,
  `frequency_range` varchar(500) DEFAULT NULL,
  `current_consumption` double DEFAULT NULL,
  `output_interface` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mems_microphone`
--

LOCK TABLES `mems_microphone` WRITE;
/*!40000 ALTER TABLE `mems_microphone` DISABLE KEYS */;
INSERT INTO `mems_microphone` VALUES (1,'TDK InvenSense SmartSound MEMS microphones','tdk_invensense_smartsound_mems_microphones','TDK InvenSense analog/digital MEMS microphone product family.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `mems_microphone` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `mlcc`
--

DROP TABLE IF EXISTS `mlcc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mlcc` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `capacitance` double DEFAULT NULL,
  `rated_voltage` double DEFAULT NULL,
  `case_size` varchar(500) DEFAULT NULL,
  `dielectric_type` varchar(500) DEFAULT NULL,
  `operating_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mlcc`
--

LOCK TABLES `mlcc` WRITE;
/*!40000 ALTER TABLE `mlcc` DISABLE KEYS */;
INSERT INTO `mlcc` VALUES (1,'Murata multilayer ceramic capacitors','murata_multilayer_ceramic_capacitors','Murata ceramic capacitor / MLCC product lineup.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL),(2,'Samsung Electro-Mechanics MLCC','samsung_electro-mechanics_mlcc','Samsung Electro-Mechanics multilayer ceramic capacitor products.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL),(3,'TDK multilayer ceramic chip capacitors','tdk_multilayer_ceramic_chip_capacitors','TDK multilayer ceramic chip capacitor product lineup.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL),(4,'YAGEO multilayer ceramic capacitors','yageo_multilayer_ceramic_capacitors','YAGEO Group MLCC product portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL),(9,'revenue','revenue','','2026-06-18 03:05:27','2026-06-18 03:05:27',NULL,NULL,NULL,NULL,NULL),(10,'operating_profit','operating_profit','','2026-06-18 03:05:27','2026-06-18 03:05:27',NULL,NULL,NULL,NULL,NULL),(11,'profit_before_tax','profit_before_tax','','2026-06-18 03:05:27','2026-06-18 03:05:27',NULL,NULL,NULL,NULL,NULL),(12,'profit_attributable','profit_attributable','','2026-06-18 03:05:27','2026-06-18 03:05:27',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `mlcc` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `mosfet`
--

DROP TABLE IF EXISTS `mosfet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mosfet` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `drain_source_voltage` double DEFAULT NULL,
  `continuous_drain_current` double DEFAULT NULL,
  `on_resistance` double DEFAULT NULL,
  `total_gate_charge` double DEFAULT NULL,
  `threshold_voltage` double DEFAULT NULL,
  `power_dissipation` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mosfet`
--

LOCK TABLES `mosfet` WRITE;
/*!40000 ALTER TABLE `mosfet` DISABLE KEYS */;
INSERT INTO `mosfet` VALUES (1,'Infineon MOSFET portfolio','infineon_mosfet_portfolio','Infineon power MOSFET product portfolio.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL),(2,'onsemi MOSFET portfolio','onsemi_mosfet_portfolio','onsemi discrete and power module portfolio including MOSFET products.','2026-06-17 08:28:52','2026-06-17 08:28:52',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `mosfet` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `nand_flash`
--

DROP TABLE IF EXISTS `nand_flash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nand_flash` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `storage_capacity` double DEFAULT NULL,
  `interface_speed` double DEFAULT NULL,
  `page_size` double DEFAULT NULL,
  `program_erase_cycles` bigint DEFAULT NULL,
  `operating_temperature_range` varchar(500) DEFAULT NULL,
  `cell_level_type` varchar(500) DEFAULT NULL,
  `bits_per_cell` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nand_flash`
--

LOCK TABLES `nand_flash` WRITE;
/*!40000 ALTER TABLE `nand_flash` DISABLE KEYS */;
INSERT INTO `nand_flash` VALUES (1,'GigaDevice SPI NAND Flash','gigadevice_spi_nand_flash','GigaDevice SPI NAND Flash product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'KIOXIA BiCS FLASH','kioxia_bics_flash','Kioxia 3D NAND flash technology/product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'KIOXIA SLC NAND Flash','kioxia_slc_nand_flash','Kioxia raw SLC NAND flash product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'Micron NAND flash memory','micron_nand_flash_memory','Micron NAND flash memory product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'Samsung V-NAND','samsung_v-nand','Samsung vertical NAND flash product/technology family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'Western Digital BiCS5 3D NAND','western_digital_bics5_3d_nand','Western Digital fifth-generation BiCS 3D NAND technology.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'YMTC Gen5 3D NAND X4-6080','ymtc_gen5_3d_nand_x4-6080','YMTC Gen5 3D NAND QLC product powered by Xtacking 4.0.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'YMTC Gen5 3D NAND X4-9070','ymtc_gen5_3d_nand_x4-9070','YMTC Gen5 3D NAND TLC product powered by Xtacking 4.0.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,'YMTC Xtacking 3D NAND','ymtc_xtacking_3d_nand','YMTC 3D NAND flash products based on Xtacking architecture.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,'Micron 9400 PRO 15.36TB NVMe SSD','micron_9400_pro_15_36tb_nvme_ssd','','2026-06-18 02:52:39','2026-06-18 02:52:39',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,'Samsung 990 PRO 4TB SSD','samsung_990_pro_4tb_ssd','','2026-06-18 02:52:39','2026-06-18 02:52:39',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,'revenue','revenue','','2026-06-18 03:05:24','2026-06-18 03:05:24',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,'profit_attributable','profit_attributable','','2026-06-18 03:05:24','2026-06-18 03:05:24',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,'non_gaap_operating_profit','non_gaap_operating_profit','','2026-06-18 03:05:24','2026-06-18 03:05:24',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `nand_flash` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `nor_flash`
--

DROP TABLE IF EXISTS `nor_flash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nor_flash` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `storage_capacity` double DEFAULT NULL,
  `read_speed` double DEFAULT NULL,
  `program_erase_cycles` bigint DEFAULT NULL,
  `operating_voltage_range` varchar(500) DEFAULT NULL,
  `package_pin_count` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nor_flash`
--

LOCK TABLES `nor_flash` WRITE;
/*!40000 ALTER TABLE `nor_flash` DISABLE KEYS */;
INSERT INTO `nor_flash` VALUES (1,'GigaDevice SPI NOR Flash','gigadevice_spi_nor_flash','GigaDevice SPI NOR Flash product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL),(2,'Infineon SEMPER NOR Flash','infineon_semper_nor_flash','Infineon SEMPER NOR flash family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL),(3,'Infineon SEMPER X1 LPDDR Flash','infineon_semper_x1_lpddr_flash','Infineon LPDDR-interface NOR flash product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL),(4,'Macronix Parallel NOR Flash','macronix_parallel_nor_flash','Macronix parallel NOR flash product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL),(5,'Macronix Serial NOR Flash','macronix_serial_nor_flash','Macronix serial NOR flash product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL),(6,'Winbond W25Q QSPI NOR Flash','winbond_w25q_qspi_nor_flash','Winbond W25Q/W25H QSPI NOR product family.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL),(13,'net_sales','net_sales','','2026-06-18 03:05:22','2026-06-18 03:05:22',NULL,NULL,NULL,NULL,NULL),(14,'gross_profit','gross_profit','','2026-06-18 03:05:22','2026-06-18 03:05:22',NULL,NULL,NULL,NULL,NULL),(15,'gross_margin','gross_margin','','2026-06-18 03:05:22','2026-06-18 03:05:22',NULL,NULL,NULL,NULL,NULL),(16,'revenue','revenue','','2026-06-18 03:05:32','2026-06-18 03:05:32',NULL,NULL,NULL,NULL,NULL),(17,'net_profit_attributable','net_profit_attributable','','2026-06-18 03:05:32','2026-06-18 03:05:32',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `nor_flash` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `optical_interconnect_technology`
--

DROP TABLE IF EXISTS `optical_interconnect_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `optical_interconnect_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `integration_approach` varchar(500) DEFAULT NULL,
  `waveguide_material` varchar(500) DEFAULT NULL,
  `per_lane_data_rate` double DEFAULT NULL,
  `power_efficiency` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optical_interconnect_technology`
--

LOCK TABLES `optical_interconnect_technology` WRITE;
/*!40000 ALTER TABLE `optical_interconnect_technology` DISABLE KEYS */;
INSERT INTO `optical_interconnect_technology` VALUES (1,'APD','avalanche_photodiode','雪崩光电探测器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(2,'AWG','arrayed_waveguide_grating','阵列波导光栅','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(3,'CPO','co-packaged_optics','共封装光学，将光引擎与交换芯片共封装','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(4,'DFB','distributed_feedback_laser','分布式反馈激光器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(5,'DWDM','dense_wdm','密集波分复用','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(6,'EDFA','erbium-doped_fiber_amplifier','掺铒光纤放大器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(7,'EML','electro-absorption_modulated_laser','电吸收调制激光器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(8,'LWDM','lan-wdm','局域网波分复用','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(9,'NPO','near-package_optics','近封装光学','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(10,'PLC','planar_lightwave_circuit','平面光波回路','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(11,'SPAD','single-photon_avalanche_diode','单光子雪崩二极管','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(12,'SiPM','silicon_photomultiplier','硅光电倍增器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(13,'VCSEL','vertical-cavity_surface-emitting_laser','垂直腔面发射激光器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(14,'WDM','wavelength_division_multiplexing','波分复用','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(15,'光互连','optical_interconnect','光信号互连','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(16,'光引擎','optical_engine','CPO中的光收发引擎','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(17,'微环','microring','微环谐振器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(18,'硅光','silicon_photonics','硅基光电子集成','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(19,'调制器','modulator','光调制器','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(96,'CPO','co-packaged_optics_1','共封装光学，将光引擎与交换芯片共封装','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(97,'NPO','near-package_optics_1','近封装光学','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(98,'光引擎','optical_engine_1','CPO中的光收发引擎','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(99,'硅光','silicon_photonics_1','硅基光电子集成','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(100,'光互连','optical_interconnect_1','光信号互连','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(101,'VCSEL','vertical-cavity_surface-emitting_laser_1','垂直腔面发射激光器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(102,'DFB','distributed_feedback_laser_1','分布式反馈激光器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(103,'EML','electro-absorption_modulated_laser_1','电吸收调制激光器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(104,'APD','avalanche_photodiode_1','雪崩光电探测器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(105,'SPAD','single-photon_avalanche_diode_1','单光子雪崩二极管','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(106,'SiPM','silicon_photomultiplier_1','硅光电倍增器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(107,'调制器','modulator_1','光调制器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(108,'微环','microring_1','微环谐振器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(109,'AWG','arrayed_waveguide_grating_1','阵列波导光栅','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(110,'PLC','planar_lightwave_circuit_1','平面光波回路','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(111,'WDM','wavelength_division_multiplexing_1','波分复用','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(112,'DWDM','dense_wdm_1','密集波分复用','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(113,'LWDM','lan-wdm_1','局域网波分复用','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(114,'EDFA','erbium-doped_fiber_amplifier_1','掺铒光纤放大器','2026-06-17 09:47:45','2026-06-17 09:47:45',NULL,NULL,NULL,NULL),(115,'CPO','co-packaged_optics_2','共封装光学，将光引擎与交换芯片共封装','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(116,'NPO','near-package_optics_2','近封装光学','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(117,'光引擎','optical_engine_2','CPO中的光收发引擎','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(118,'硅光','silicon_photonics_2','硅基光电子集成','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(119,'光互连','optical_interconnect_2','光信号互连','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(120,'VCSEL','vertical-cavity_surface-emitting_laser_2','垂直腔面发射激光器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(121,'DFB','distributed_feedback_laser_2','分布式反馈激光器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(122,'EML','electro-absorption_modulated_laser_2','电吸收调制激光器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(123,'APD','avalanche_photodiode_2','雪崩光电探测器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(124,'SPAD','single-photon_avalanche_diode_2','单光子雪崩二极管','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(125,'SiPM','silicon_photomultiplier_2','硅光电倍增器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(126,'调制器','modulator_2','光调制器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(127,'微环','microring_2','微环谐振器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(128,'AWG','arrayed_waveguide_grating_2','阵列波导光栅','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(129,'PLC','planar_lightwave_circuit_2','平面光波回路','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(130,'WDM','wavelength_division_multiplexing_2','波分复用','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(131,'DWDM','dense_wdm_2','密集波分复用','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(132,'LWDM','lan-wdm_2','局域网波分复用','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL),(133,'EDFA','erbium-doped_fiber_amplifier_2','掺铒光纤放大器','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `optical_interconnect_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `other_thin_film_deposition_equipment`
--

DROP TABLE IF EXISTS `other_thin_film_deposition_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `other_thin_film_deposition_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `supported_wafer_diameter` double DEFAULT NULL,
  `process_temperature` double DEFAULT NULL,
  `deposition_rate` double DEFAULT NULL,
  `film_uniformity` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_thin_film_deposition_equipment`
--

LOCK TABLES `other_thin_film_deposition_equipment` WRITE;
/*!40000 ALTER TABLE `other_thin_film_deposition_equipment` DISABLE KEYS */;
INSERT INTO `other_thin_film_deposition_equipment` VALUES (1,'Applied Materials deposition equipment','applied_materials_deposition_equipment','Applied Materials semiconductor equipment for depositing material layers on wafers.','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL),(2,'Lam Research deposition systems','lam_research_deposition_systems','Lam Research thin film deposition product portfolio.','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `other_thin_film_deposition_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `packaging_solution`
--

DROP TABLE IF EXISTS `packaging_solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packaging_solution` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `technology_type` varchar(500) DEFAULT NULL,
  `integration_density` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packaging_solution`
--

LOCK TABLES `packaging_solution` WRITE;
/*!40000 ALTER TABLE `packaging_solution` DISABLE KEYS */;
INSERT INTO `packaging_solution` VALUES (1,'Amkor Advanced Packaging','amkor_advanced_packaging','Amkor先进封装方案','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(2,'CoWoS-S/L','cowos-s_l','台积电2.5D封装（硅中介层/大尺寸）','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(3,'EMIB','embedded_multi-die_interconnect_bridge','Intel嵌入式多晶粒互连桥接','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(4,'FC-BGA','flip_chip_bga','倒装芯片球栅阵列封装','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(5,'FC-CSP','flip_chip_csp','倒装芯片级封装','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(6,'FOCoS-Bridge','focos-bridge','ASE扇出型桥接封装','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(7,'Foveros','foveros','Intel 3D堆叠封装','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(8,'InFO','integrated_fan-out','台积电集成扇出封装','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(9,'SiP','system_in_package','系统级封装','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(10,'SoIC','system_on_integrated_chips','台积电3D堆叠技术','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(11,'VIPack','vipack','日月光先进封装平台','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL),(56,'CoWoS-S/L','cowos-s_l_1','台积电2.5D封装（硅中介层/大尺寸）','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(57,'InFO','integrated_fan-out_1','台积电集成扇出封装','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(58,'SoIC','system_on_integrated_chips_1','台积电3D堆叠技术','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(59,'Foveros','foveros_1','Intel 3D堆叠封装','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(60,'EMIB','embedded_multi-die_interconnect_bridge_1','Intel嵌入式多晶粒互连桥接','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(61,'VIPack','vipack_1','日月光先进封装平台','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(62,'FOCoS-Bridge','focos-bridge_1','ASE扇出型桥接封装','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(63,'Amkor Advanced Packaging','amkor_advanced_packaging_1','Amkor先进封装方案','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(64,'FC-BGA','flip_chip_bga_1','倒装芯片球栅阵列封装','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(65,'FC-CSP','flip_chip_csp_1','倒装芯片级封装','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(66,'SiP','system_in_package_1','系统级封装','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(67,'CoWoS-S/L','cowos-s_l_2','台积电2.5D封装（硅中介层/大尺寸）','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(68,'InFO','integrated_fan-out_2','台积电集成扇出封装','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(69,'SoIC','system_on_integrated_chips_2','台积电3D堆叠技术','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(70,'Foveros','foveros_2','Intel 3D堆叠封装','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(71,'EMIB','embedded_multi-die_interconnect_bridge_2','Intel嵌入式多晶粒互连桥接','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(72,'VIPack','vipack_2','日月光先进封装平台','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(73,'FOCoS-Bridge','focos-bridge_2','ASE扇出型桥接封装','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(74,'Amkor Advanced Packaging','amkor_advanced_packaging_2','Amkor先进封装方案','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(75,'FC-BGA','flip_chip_bga_2','倒装芯片球栅阵列封装','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(76,'FC-CSP','flip_chip_csp_2','倒装芯片级封装','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL),(77,'SiP','system_in_package_2','系统级封装','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL);
/*!40000 ALTER TABLE `packaging_solution` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `packaging_substrate_technology`
--

DROP TABLE IF EXISTS `packaging_substrate_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packaging_substrate_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `substrate_material` varchar(500) DEFAULT NULL,
  `line_width_spacing` double DEFAULT NULL,
  `max_substrate_size` double DEFAULT NULL,
  `cte` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packaging_substrate_technology`
--

LOCK TABLES `packaging_substrate_technology` WRITE;
/*!40000 ALTER TABLE `packaging_substrate_technology` DISABLE KEYS */;
INSERT INTO `packaging_substrate_technology` VALUES (1,'TGV','through_glass_via','玻璃通孔技术','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL),(2,'玻璃基板','glass_substrate','下一代封装基板材料','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL),(11,'玻璃基板','glass_substrate_1','下一代封装基板材料','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(12,'TGV','through_glass_via_1','玻璃通孔技术','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(13,'玻璃基板','glass_substrate_2','下一代封装基板材料','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(14,'TGV','through_glass_via_2','玻璃通孔技术','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `packaging_substrate_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `packaging_technology_generation`
--

DROP TABLE IF EXISTS `packaging_technology_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packaging_technology_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `generation_name` varchar(500) DEFAULT NULL,
  `era` varchar(500) DEFAULT NULL,
  `packaging_dimension` varchar(500) DEFAULT NULL,
  `io_density` varchar(500) DEFAULT NULL,
  `representative_technology` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packaging_technology_generation`
--

LOCK TABLES `packaging_technology_generation` WRITE;
/*!40000 ALTER TABLE `packaging_technology_generation` DISABLE KEYS */;
INSERT INTO `packaging_technology_generation` VALUES (1,'THT通孔插装','tht_through-hole_technology','通孔插装技术：将元器件引脚插入PCB预钻通孔并焊接固定，最大安装密度约10引脚/cm²','2026-06-17 09:48:43','2026-06-17 09:48:43','THT','20世纪70年代','2D','~10引脚/cm²','TO（金属圆形封装）、DIP（双列直插封装）'),(2,'SMT表面贴装','smt_surface-mount_technology','表面贴装技术：将电子元件直接贴装到PCB板表面，无需钻孔，可双面贴装，密度10-50引脚/cm²','2026-06-17 09:48:43','2026-06-17 09:48:43','SMT','20世纪80年代','2D','10-50引脚/cm²','SOP（小外形封装）、QFP（四边引脚扁平封装）'),(3,'BGA球栅阵列','bga_ball_grid_array','球栅阵列封装：通过底部焊球阵列实现芯片与PCB互连，焊球间距最小可达0.3mm，支持数百至上千引脚','2026-06-17 09:48:43','2026-06-17 09:48:43','BGA','20世纪90年代','2D（阵列式）','高（数百至上千引脚）','BGA焊球阵列、CSP（芯片级封装）'),(4,'MCM多芯片组装','mcm_multi-chip_module','多芯片模组：在一个封装内集成多个裸芯片，封装技术微缩至0级封装','2026-06-17 09:48:43','2026-06-17 09:48:43','MCM','2000年后','2D（平面多芯片）','高','FlipChip（倒装焊）、Bumping（凸点工艺）、WLCSP（晶圆级尺寸封装）'),(5,'2.5D/3D立体封装','2_5d_3d_stacking','三维立体封装：封装技术拓宽至三维立体结构，进一步提高单位面积内IO密度，代表技术包括CoWoS与SoIC等','2026-06-17 09:48:43','2026-06-17 09:48:43','2.5D/3D','2010年后','3D（垂直堆叠）','极高（>10,000 I/O per mm² via Hybrid Bonding）','CoWoS（2.5D）、SoIC（3D）、HBM堆叠、Hybrid Bonding');
/*!40000 ALTER TABLE `packaging_technology_generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `passive_component`
--

DROP TABLE IF EXISTS `passive_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passive_component` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passive_component`
--

LOCK TABLES `passive_component` WRITE;
/*!40000 ALTER TABLE `passive_component` DISABLE KEYS */;
INSERT INTO `passive_component` VALUES (1,'YAGEO','yageo','','2026-06-18 03:00:48','2026-06-18 03:00:48');
/*!40000 ALTER TABLE `passive_component` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pcb_copper_foil`
--

DROP TABLE IF EXISTS `pcb_copper_foil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcb_copper_foil` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `foil_type` varchar(500) DEFAULT NULL,
  `foil_thickness` double DEFAULT NULL,
  `copper_weight` double DEFAULT NULL,
  `surface_roughness` double DEFAULT NULL,
  `tensile_strength` double DEFAULT NULL,
  `elongation` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pcb_copper_foil`
--

LOCK TABLES `pcb_copper_foil` WRITE;
/*!40000 ALTER TABLE `pcb_copper_foil` DISABLE KEYS */;
INSERT INTO `pcb_copper_foil` VALUES (1,'Mitsui electrolytic copper foil','mitsui_electrolytic_copper_foil','Mitsui Kinzoku electrolytic copper foil for printed wiring boards.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Nan Ya copper foils for CCL and PCB','nan_ya_copper_foils_for_ccl_and_pcb','Nan Ya copper foils for CCL and PCB application.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL),(3,'Sumitomo rolled copper foil','sumitomo_rolled_copper_foil','Sumitomo rolled copper foil for high-density electronic device mounting.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL),(7,'net_sales','net_sales','','2026-06-18 03:05:33','2026-06-18 03:05:33',NULL,NULL,NULL,NULL,NULL,NULL),(8,'operating_profit','operating_profit','','2026-06-18 03:05:33','2026-06-18 03:05:33',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `pcb_copper_foil` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pcb_electronic_resin`
--

DROP TABLE IF EXISTS `pcb_electronic_resin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcb_electronic_resin` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `resin_system` varchar(500) DEFAULT NULL,
  `glass_transition_temperature` double DEFAULT NULL,
  `decomposition_temperature` double DEFAULT NULL,
  `dielectric_constant` double DEFAULT NULL,
  `dissipation_factor` double DEFAULT NULL,
  `flame_retardance_rating` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pcb_electronic_resin`
--

LOCK TABLES `pcb_electronic_resin` WRITE;
/*!40000 ALTER TABLE `pcb_electronic_resin` DISABLE KEYS */;
INSERT INTO `pcb_electronic_resin` VALUES (1,'Isola proprietary PCB resin systems','isola_proprietary_pcb_resin_systems','Isola laminate products use proprietary resin formulations engineered for PCB materials.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Nan Ya PCB ink and resin electronic materials','nan_ya_pcb_ink_and_resin_electronic_materials','Nan Ya electronic materials for PCB insulation/protection and laminate applications.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `pcb_electronic_resin` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `prepreg`
--

DROP TABLE IF EXISTS `prepreg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prepreg` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `glass_fabric_style` varchar(500) DEFAULT NULL,
  `resin_content` double DEFAULT NULL,
  `resin_flow` double DEFAULT NULL,
  `gel_time` double DEFAULT NULL,
  `volatile_content` double DEFAULT NULL,
  `thickness` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prepreg`
--

LOCK TABLES `prepreg` WRITE;
/*!40000 ALTER TABLE `prepreg` DISABLE KEYS */;
INSERT INTO `prepreg` VALUES (1,'Isola PCB prepreg materials','isola_pcb_prepreg_materials','Isola prepreg materials for PCB laminate stackups.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Nan Ya CCL prepreg materials','nan_ya_ccl_prepreg_materials','Nan Ya CCL/prepreg electronic materials.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `prepreg` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pressure_sensor`
--

DROP TABLE IF EXISTS `pressure_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pressure_sensor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pressure_range` varchar(500) DEFAULT NULL,
  `accuracy` double DEFAULT NULL,
  `resolution` double DEFAULT NULL,
  `supply_voltage_range` varchar(500) DEFAULT NULL,
  `current_consumption` double DEFAULT NULL,
  `operating_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pressure_sensor`
--

LOCK TABLES `pressure_sensor` WRITE;
/*!40000 ALTER TABLE `pressure_sensor` DISABLE KEYS */;
INSERT INTO `pressure_sensor` VALUES (1,'Bosch Sensortec pressure sensors','bosch_sensortec_pressure_sensors','Bosch environmental and pressure MEMS sensor products.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL,NULL),(2,'ST MEMS pressure sensors','st_mems_pressure_sensors','STMicroelectronics MEMS pressure sensor products.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `pressure_sensor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `printed_circuit_board`
--

DROP TABLE IF EXISTS `printed_circuit_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `printed_circuit_board` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `layer_count` bigint DEFAULT NULL,
  `line_width_spacing` varchar(500) DEFAULT NULL,
  `board_thickness` double DEFAULT NULL,
  `substrate_material` varchar(500) DEFAULT NULL,
  `surface_finish` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `printed_circuit_board`
--

LOCK TABLES `printed_circuit_board` WRITE;
/*!40000 ALTER TABLE `printed_circuit_board` DISABLE KEYS */;
INSERT INTO `printed_circuit_board` VALUES (1,'AT&S high-end PCBs','at_s_high-end_pcbs','AT&S high-end printed circuit boards for advanced electronics applications.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL),(2,'Nan Ya PCB printed circuit boards','nan_ya_pcb_printed_circuit_boards','Nan Ya PCB printed circuit board technology and products.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `printed_circuit_board` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `probe_card`
--

DROP TABLE IF EXISTS `probe_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `probe_card` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pin_count` bigint DEFAULT NULL,
  `probe_pitch` double DEFAULT NULL,
  `contact_resistance` double DEFAULT NULL,
  `maximum_frequency` double DEFAULT NULL,
  `parallel_dut_count` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `probe_card`
--

LOCK TABLES `probe_card` WRITE;
/*!40000 ALTER TABLE `probe_card` DISABLE KEYS */;
INSERT INTO `probe_card` VALUES (1,'FormFactor probe cards','formfactor_probe_cards','FormFactor probe cards for memory, RF, foundry and logic wafer test.','2026-06-17 08:28:57','2026-06-17 08:28:57',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `probe_card` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `process_node_generation`
--

DROP TABLE IF EXISTS `process_node_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `process_node_generation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `node_name` varchar(500) DEFAULT NULL,
  `generation` varchar(500) DEFAULT NULL,
  `transistor_density` double DEFAULT NULL,
  `lithography_requirement` varchar(500) DEFAULT NULL,
  `performance_power_characteristic` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_node_generation`
--

LOCK TABLES `process_node_generation` WRITE;
/*!40000 ALTER TABLE `process_node_generation` DISABLE KEYS */;
INSERT INTO `process_node_generation` VALUES (1,'10nm','10nm','先进逻辑制程节点','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(2,'12nm','12nm','先进逻辑制程节点，联电12nm FinFET计划2027年量产','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(3,'14nm','14nm','先进逻辑制程节点','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(4,'16nm','16nm','先进逻辑制程节点，台积电16nm FinFET（4Q15量产），三星14nm FinFET（1Q15量产）','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(5,'20nm','20nm','先进逻辑制程节点，台积电2014年量产，采用Planar晶体管最后一代','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(6,'22nm','22nm','先进逻辑制程节点，Intel 22nm（2012），三星/格芯22nm FD-SOI','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(7,'28nm','28nm','成熟逻辑制程节点','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(8,'2nm','2nm','先进逻辑制程节点（GAA时代）','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(9,'3nm','3nm','先进逻辑制程节点','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(10,'4nm','4nm','先进逻辑制程节点，三星4nm FinFET（2022年量产），台积电N4（2022年量产）','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(11,'5nm','5nm','先进逻辑制程节点','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(12,'6nm','6nm','先进逻辑制程节点，台积电6nm FinFET（3Q20量产），三星6nm LPP（4Q19量产）','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(13,'7nm','7nm','先进逻辑制程节点','2026-06-17 08:28:55','2026-06-17 08:28:55',NULL,NULL,NULL,NULL,NULL),(66,'3nm','3nm_1','先进逻辑制程节点','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(67,'5nm','5nm_1','先进逻辑制程节点','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(68,'7nm','7nm_1','先进逻辑制程节点','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(69,'10nm','10nm_1','先进逻辑制程节点','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(70,'14nm','14nm_1','先进逻辑制程节点','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(71,'28nm','28nm_1','成熟逻辑制程节点','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(72,'2nm','2nm_1','先进逻辑制程节点（GAA时代）','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(73,'20nm','20nm_1','先进逻辑制程节点，台积电2014年量产，采用Planar晶体管最后一代','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(74,'16nm','16nm_1','先进逻辑制程节点，台积电16nm FinFET（4Q15量产），三星14nm FinFET（1Q15量产）','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(75,'6nm','6nm_1','先进逻辑制程节点，台积电6nm FinFET（3Q20量产），三星6nm LPP（4Q19量产）','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(76,'4nm','4nm_1','先进逻辑制程节点，三星4nm FinFET（2022年量产），台积电N4（2022年量产）','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(77,'22nm','22nm_1','先进逻辑制程节点，Intel 22nm（2012），三星/格芯22nm FD-SOI','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(78,'12nm','12nm_1','先进逻辑制程节点，联电12nm FinFET计划2027年量产','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL,NULL),(79,'3nm','3nm_2','先进逻辑制程节点','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(80,'5nm','5nm_2','先进逻辑制程节点','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(81,'7nm','7nm_2','先进逻辑制程节点','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(82,'10nm','10nm_2','先进逻辑制程节点','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(83,'14nm','14nm_2','先进逻辑制程节点','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(84,'28nm','28nm_2','成熟逻辑制程节点','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(85,'2nm','2nm_2','先进逻辑制程节点（GAA时代）','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(86,'20nm','20nm_2','先进逻辑制程节点，台积电2014年量产，采用Planar晶体管最后一代','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(87,'16nm','16nm_2','先进逻辑制程节点，台积电16nm FinFET（4Q15量产），三星14nm FinFET（1Q15量产）','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(88,'6nm','6nm_2','先进逻辑制程节点，台积电6nm FinFET（3Q20量产），三星6nm LPP（4Q19量产）','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(89,'4nm','4nm_2','先进逻辑制程节点，三星4nm FinFET（2022年量产），台积电N4（2022年量产）','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(90,'22nm','22nm_2','先进逻辑制程节点，Intel 22nm（2012），三星/格芯22nm FD-SOI','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL),(91,'12nm','12nm_2','先进逻辑制程节点，联电12nm FinFET计划2027年量产','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `process_node_generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `process_platform`
--

DROP TABLE IF EXISTS `process_platform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `process_platform` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `company` varchar(500) DEFAULT NULL,
  `maturity` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_platform`
--

LOCK TABLES `process_platform` WRITE;
/*!40000 ALTER TABLE `process_platform` DISABLE KEYS */;
INSERT INTO `process_platform` VALUES (1,'Intel 18A','intel_18a','Intel 18Å制造工艺','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL),(2,'Samsung SF3','samsung_sf3','三星3nm GAA制造工艺','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL),(3,'TSMC N3E','tsmc_n3e','台积电3nm增强版制造工艺','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL),(16,'TSMC N3E','tsmc_n3e_1','台积电3nm增强版制造工艺','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(17,'Samsung SF3','samsung_sf3_1','三星3nm GAA制造工艺','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(18,'Intel 18A','intel_18a_1','Intel 18Å制造工艺','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL),(19,'TSMC N3E','tsmc_n3e_2','台积电3nm增强版制造工艺','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(20,'Samsung SF3','samsung_sf3_2','三星3nm GAA制造工艺','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL),(21,'Intel 18A','intel_18a_2','Intel 18Å制造工艺','2026-06-17 09:48:42','2026-06-17 09:48:42',NULL,NULL);
/*!40000 ALTER TABLE `process_platform` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `schottky_diode`
--

DROP TABLE IF EXISTS `schottky_diode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schottky_diode` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `repetitive_peak_reverse_voltage` double DEFAULT NULL,
  `average_forward_current` double DEFAULT NULL,
  `forward_voltage` double DEFAULT NULL,
  `reverse_leakage_current` double DEFAULT NULL,
  `junction_temperature_range` varchar(500) DEFAULT NULL,
  `junction_capacitance` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schottky_diode`
--

LOCK TABLES `schottky_diode` WRITE;
/*!40000 ALTER TABLE `schottky_diode` DISABLE KEYS */;
INSERT INTO `schottky_diode` VALUES (1,'ROHM Schottky barrier diodes','rohm_schottky_barrier_diodes','ROHM Schottky barrier diode product family.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Vishay Schottky rectifiers','vishay_schottky_rectifiers','Vishay Schottky rectifier product portfolio.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `schottky_diode` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `semiconductor_ip_core`
--

DROP TABLE IF EXISTS `semiconductor_ip_core`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `semiconductor_ip_core` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `gate_count` bigint DEFAULT NULL,
  `maximum_frequency` double DEFAULT NULL,
  `power_consumption` double DEFAULT NULL,
  `interface_width` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `semiconductor_ip_core`
--

LOCK TABLES `semiconductor_ip_core` WRITE;
/*!40000 ALTER TABLE `semiconductor_ip_core` DISABLE KEYS */;
INSERT INTO `semiconductor_ip_core` VALUES (1,'Arm processor IP','arm_processor_ip','Arm processor IP portfolio.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL),(2,'Cadence verification and design IP','cadence_verification_and_design_ip','Cadence IP products for chip and system design.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL),(3,'Synopsys semiconductor IP','synopsys_semiconductor_ip','Synopsys silicon IP portfolio.','2026-06-17 08:28:56','2026-06-17 08:28:56',NULL,NULL,NULL,NULL),(7,'revenue','revenue','','2026-06-18 03:05:24','2026-06-18 03:05:24',NULL,NULL,NULL,NULL),(8,'gross_profit','gross_profit','','2026-06-18 03:05:25','2026-06-18 03:05:25',NULL,NULL,NULL,NULL),(9,'gross_margin','gross_margin','','2026-06-18 03:05:25','2026-06-18 03:05:25',NULL,NULL,NULL,NULL),(10,'operating_income','operating_income','','2026-06-18 03:05:25','2026-06-18 03:05:25',NULL,NULL,NULL,NULL),(11,'net_income','net_income','','2026-06-18 03:05:25','2026-06-18 03:05:25',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `semiconductor_ip_core` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:11
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `sic_diode`
--

DROP TABLE IF EXISTS `sic_diode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sic_diode` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `repetitive_peak_reverse_voltage` double DEFAULT NULL,
  `average_forward_current` double DEFAULT NULL,
  `forward_voltage` double DEFAULT NULL,
  `reverse_leakage_current` double DEFAULT NULL,
  `junction_temperature_range` varchar(500) DEFAULT NULL,
  `reverse_recovery_charge` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sic_diode`
--

LOCK TABLES `sic_diode` WRITE;
/*!40000 ALTER TABLE `sic_diode` DISABLE KEYS */;
INSERT INTO `sic_diode` VALUES (1,'ROHM SiC Schottky barrier diodes','rohm_sic_schottky_barrier_diodes','ROHM SiC SBD product family.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Wolfspeed SiC Schottky diodes','wolfspeed_sic_schottky_diodes','Wolfspeed silicon carbide diode product family.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL,NULL),(3,'onsemi SiC diodes','onsemi_sic_diodes','onsemi SiC diode and SiC module products.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `sic_diode` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `sic_mosfet`
--

DROP TABLE IF EXISTS `sic_mosfet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sic_mosfet` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `drain_source_voltage` double DEFAULT NULL,
  `continuous_drain_current` double DEFAULT NULL,
  `on_resistance` double DEFAULT NULL,
  `total_gate_charge` double DEFAULT NULL,
  `switching_loss` double DEFAULT NULL,
  `junction_temperature_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sic_mosfet`
--

LOCK TABLES `sic_mosfet` WRITE;
/*!40000 ALTER TABLE `sic_mosfet` DISABLE KEYS */;
INSERT INTO `sic_mosfet` VALUES (1,'ROHM SiC MOSFETs','rohm_sic_mosfets','ROHM SiC MOSFET product family.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Wolfspeed discrete SiC MOSFETs','wolfspeed_discrete_sic_mosfets','Wolfspeed discrete silicon carbide MOSFET product family.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL,NULL),(3,'onsemi EliteSiC MOSFETs','onsemi_elitesic_mosfets','onsemi EliteSiC MOSFET and SiC module product family.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `sic_mosfet` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `silicon_wafer`
--

DROP TABLE IF EXISTS `silicon_wafer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `silicon_wafer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `wafer_diameter` double DEFAULT NULL,
  `thickness` double DEFAULT NULL,
  `total_thickness_variation` double DEFAULT NULL,
  `warp` double DEFAULT NULL,
  `resistivity` double DEFAULT NULL,
  `crystal_orientation` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `silicon_wafer`
--

LOCK TABLES `silicon_wafer` WRITE;
/*!40000 ALTER TABLE `silicon_wafer` DISABLE KEYS */;
INSERT INTO `silicon_wafer` VALUES (1,'GlobalWafers silicon wafers','globalwafers_silicon_wafers','Silicon wafers and related products from GlobalWafers.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL),(2,'SEH America silicon wafers','seh_america_silicon_wafers','CZ and FZ silicon wafers up to 300 mm from SEH America.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL),(3,'SUMCO silicon wafers','sumco_silicon_wafers','High-quality silicon wafers for semiconductors from SUMCO.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Shin-Etsu semiconductor silicon wafers','shin-etsu_semiconductor_silicon_wafers','Semiconductor-grade single-crystal silicon wafers from Shin-Etsu.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL),(5,'Siltronic silicon wafers','siltronic_silicon_wafers','Polished, epitaxial and specialty silicon wafer products from Siltronic.','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL,NULL,NULL),(11,'sales','sales','','2026-06-18 03:05:25','2026-06-18 03:05:25',NULL,NULL,NULL,NULL,NULL,NULL),(12,'EBITDA','ebitda','','2026-06-18 03:05:26','2026-06-18 03:05:26',NULL,NULL,NULL,NULL,NULL,NULL),(13,'gross_margin','gross_margin','','2026-06-18 03:05:26','2026-06-18 03:05:26',NULL,NULL,NULL,NULL,NULL,NULL),(14,'net_income','net_income','','2026-06-18 03:05:26','2026-06-18 03:05:26',NULL,NULL,NULL,NULL,NULL,NULL),(15,'operating_profit','operating_profit','','2026-06-18 03:05:26','2026-06-18 03:05:26',NULL,NULL,NULL,NULL,NULL,NULL),(16,'loss_attributable','loss_attributable','','2026-06-18 03:05:26','2026-06-18 03:05:26',NULL,NULL,NULL,NULL,NULL,NULL),(17,'revenue','revenue','','2026-06-18 03:05:27','2026-06-18 03:05:27',NULL,NULL,NULL,NULL,NULL,NULL),(18,'gross_profit','gross_profit','','2026-06-18 03:05:27','2026-06-18 03:05:27',NULL,NULL,NULL,NULL,NULL,NULL),(19,'operating_income','operating_income','','2026-06-18 03:05:28','2026-06-18 03:05:28',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `silicon_wafer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `soc_and_logic_test_equipment`
--

DROP TABLE IF EXISTS `soc_and_logic_test_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soc_and_logic_test_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `channel_count` bigint DEFAULT NULL,
  `data_rate` double DEFAULT NULL,
  `voltage_range` varchar(500) DEFAULT NULL,
  `timing_accuracy` double DEFAULT NULL,
  `parallel_test_sites` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soc_and_logic_test_equipment`
--

LOCK TABLES `soc_and_logic_test_equipment` WRITE;
/*!40000 ALTER TABLE `soc_and_logic_test_equipment` DISABLE KEYS */;
INSERT INTO `soc_and_logic_test_equipment` VALUES (1,'Advantest V93000 SoC test systems','advantest_v93000_soc_test_systems','Advantest SoC test systems for logic, analog, RF, DC and imagers.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL),(2,'Teradyne semiconductor SoC test systems','teradyne_semiconductor_soc_test_systems','Teradyne semiconductor test portfolio for complex digital, analog and RF devices.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `soc_and_logic_test_equipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `soi_material`
--

DROP TABLE IF EXISTS `soi_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soi_material` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `wafer_diameter` double DEFAULT NULL,
  `device_layer_thickness` double DEFAULT NULL,
  `buried_oxide_thickness` double DEFAULT NULL,
  `total_thickness_variation` double DEFAULT NULL,
  `resistivity` double DEFAULT NULL,
  `crystal_orientation` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soi_material`
--

LOCK TABLES `soi_material` WRITE;
/*!40000 ALTER TABLE `soi_material` DISABLE KEYS */;
INSERT INTO `soi_material` VALUES (1,'SEH America SOI wafers','seh_america_soi_wafers','SOI silicon wafer options supplied by SEH America.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL),(2,'Shin-Etsu SOI wafers','shin-etsu_soi_wafers','Silicon-on-insulator wafers supplied by Shin-Etsu Group.','2026-06-17 08:28:53','2026-06-17 08:28:53',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `soi_material` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `specialty_process_platform`
--

DROP TABLE IF EXISTS `specialty_process_platform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specialty_process_platform` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `platform_type` varchar(500) DEFAULT NULL,
  `min_feature_size` double DEFAULT NULL,
  `max_operating_voltage` double DEFAULT NULL,
  `target_application` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialty_process_platform`
--

LOCK TABLES `specialty_process_platform` WRITE;
/*!40000 ALTER TABLE `specialty_process_platform` DISABLE KEYS */;
INSERT INTO `specialty_process_platform` VALUES (1,'BCD','bipolar-cmos-dmos','功率集成电路特色工艺','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL),(2,'LDMOS','lateral_double-diffused_mosfet','横向扩散MOS，RF/功率器件工艺','2026-06-17 08:28:59','2026-06-17 08:28:59',NULL,NULL,NULL,NULL),(11,'BCD','bipolar-cmos-dmos_1','功率集成电路特色工艺','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(12,'LDMOS','lateral_double-diffused_mosfet_1','横向扩散MOS，RF/功率器件工艺','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(13,'BCD','bipolar-cmos-dmos_2','功率集成电路特色工艺','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(14,'LDMOS','lateral_double-diffused_mosfet_2','横向扩散MOS，RF/功率器件工艺','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `specialty_process_platform` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `temperature_humidity_sensor`
--

DROP TABLE IF EXISTS `temperature_humidity_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temperature_humidity_sensor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `temperature_range` varchar(500) DEFAULT NULL,
  `humidity_range` varchar(500) DEFAULT NULL,
  `temperature_accuracy` double DEFAULT NULL,
  `humidity_accuracy` double DEFAULT NULL,
  `supply_voltage_range` varchar(500) DEFAULT NULL,
  `response_time` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temperature_humidity_sensor`
--

LOCK TABLES `temperature_humidity_sensor` WRITE;
/*!40000 ALTER TABLE `temperature_humidity_sensor` DISABLE KEYS */;
INSERT INTO `temperature_humidity_sensor` VALUES (1,'Bosch Sensortec humidity and temperature sensors','bosch_sensortec_humidity_and_temperature_sensors','Bosch environmental sensors measuring humidity and temperature.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `temperature_humidity_sensor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `test_socket`
--

DROP TABLE IF EXISTS `test_socket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_socket` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pin_count` bigint DEFAULT NULL,
  `contact_resistance` double DEFAULT NULL,
  `maximum_frequency` double DEFAULT NULL,
  `temperature_range` varchar(500) DEFAULT NULL,
  `package_type` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_socket`
--

LOCK TABLES `test_socket` WRITE;
/*!40000 ALTER TABLE `test_socket` DISABLE KEYS */;
INSERT INTO `test_socket` VALUES (1,'FormFactor test sockets and probe interfaces','formfactor_test_sockets_and_probe_interfaces','FormFactor semiconductor test interface and probe solutions.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `test_socket` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `thin_film_deposition_technology`
--

DROP TABLE IF EXISTS `thin_film_deposition_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thin_film_deposition_technology` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deposition_principle` varchar(500) DEFAULT NULL,
  `step_coverage` varchar(500) DEFAULT NULL,
  `deposition_rate` varchar(500) DEFAULT NULL,
  `process_temperature` varchar(500) DEFAULT NULL,
  `uniformity` varchar(500) DEFAULT NULL,
  `thickness_control` varchar(500) DEFAULT NULL,
  `film_purity` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thin_film_deposition_technology`
--

LOCK TABLES `thin_film_deposition_technology` WRITE;
/*!40000 ALTER TABLE `thin_film_deposition_technology` DISABLE KEYS */;
INSERT INTO `thin_film_deposition_technology` VALUES (1,'CVD','chemical_vapor_deposition','化学气相沉积：使气态物质在固体表面发生化学反应并在该表面沉积，形成稳定的固态薄膜','2026-06-17 09:48:43','2026-06-17 09:48:43','气相反应沉积','好','快','高','较好','沉积时间、气相分压','易含杂质'),(2,'PVD','physical_vapor_deposition','物理气相沉积：真空状态下加热原材料，使原子或分子从原材料表面逸出从而在衬底上生长薄膜，包括真空蒸镀、溅射镀膜等','2026-06-17 09:48:43','2026-06-17 09:48:43','蒸发凝固','一般','快','低','一般','沉积时间','无杂质'),(3,'ALD','atomic_layer_deposition','原子层沉积：将物质以单原子膜形式一层一层镀在基底表面，每次反应只沉积一层原子，膜厚控制极精确','2026-06-17 09:48:43','2026-06-17 09:48:43','表面反应沉积（层状生长）','优秀','慢','低','优秀','反应循环次数','均匀、杂质少');
/*!40000 ALTER TABLE `thin_film_deposition_technology` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `training_accelerator`
--

DROP TABLE IF EXISTS `training_accelerator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_accelerator` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ai_compute_performance` double DEFAULT NULL,
  `supported_precision_format` varchar(500) DEFAULT NULL,
  `memory_capacity` double DEFAULT NULL,
  `memory_bandwidth` double DEFAULT NULL,
  `thermal_design_power` double DEFAULT NULL,
  `host_interface` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_accelerator`
--

LOCK TABLES `training_accelerator` WRITE;
/*!40000 ALTER TABLE `training_accelerator` DISABLE KEYS */;
INSERT INTO `training_accelerator` VALUES (1,'AMD Instinct MI300X','amd_instinct_mi300x','Data-center GPU accelerator for AI training and HPC.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(2,'AMD Instinct MI325X','amd_instinct_mi325x','Data-center GPU accelerator for training and inference.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(3,'AMD Instinct MI350 Series','amd_instinct_mi350_series','AMD CDNA 4 accelerator series for generative AI training and HPC.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Cambricon MLU370-X8','cambricon_mlu370-x8','Cambricon cloud training AI accelerator card.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(5,'Cambricon MLU370-X8 cloud training AI accelerator','cambricon_mlu370-x8_cloud_training_ai_accelerator','Cambricon MLU370-X8 cloud training AI accelerator card.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(6,'Huawei Ascend 910 AI Processor','huawei_ascend_910_ai_processor','Huawei Ascend training AI processor used in Atlas training systems.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(7,'Huawei Ascend 910C AI Processor','huawei_ascend_910c_ai_processor','Huawei Ascend AI processor used in Atlas 900 A3 SuperPoD.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(8,'Intel Gaudi 3 AI Accelerator','intel_gaudi_3_ai_accelerator','Intel AI accelerator for training and inference.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(9,'MetaX C500 GPU accelerator','metax_c500_gpu_accelerator','MetaX GPU accelerator product for AI computing.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(10,'NVIDIA B200 Tensor Core GPU','nvidia_b200_tensor_core_gpu','Blackwell-generation accelerator used for training and inference.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(11,'NVIDIA GB200 NVL72','nvidia_gb200_nvl72','Rack-scale Grace Blackwell system with 72 Blackwell GPUs.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(12,'NVIDIA H100 Tensor Core GPU','nvidia_h100_tensor_core_gpu','AI training accelerator used in data-center training workloads.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL),(13,'NVIDIA H200 Tensor Core GPU','nvidia_h200_tensor_core_gpu','AI/HPC accelerator with HBM3e memory for large models and HPC.','2026-06-17 08:29:00','2026-06-17 08:29:00',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `training_accelerator` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `transistor_architecture`
--

DROP TABLE IF EXISTS `transistor_architecture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transistor_architecture` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `channel_structure` varchar(500) DEFAULT NULL,
  `manufacturing_complexity` varchar(500) DEFAULT NULL,
  `power_efficiency_improvement` double DEFAULT NULL,
  `compatible_node_range` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transistor_architecture`
--

LOCK TABLES `transistor_architecture` WRITE;
/*!40000 ALTER TABLE `transistor_architecture` DISABLE KEYS */;
INSERT INTO `transistor_architecture` VALUES (1,'CFET','cfet','互补场效应晶体管，GAA后演进方向','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(2,'FD-SOI','fd-soi','全耗尽SOI，兼顾性能与功耗','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(3,'FinFET','finfet','鳍式场效应晶体管，先进制程主流架构','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(4,'GAAFET','gaafet','全环绕栅极场效应晶体管','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(5,'Multi-bridge Channel FET','multi-bridge_channel_fet','多桥沟道FET，GAA同范畴','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(6,'Planar CMOS','planar_cmos','平面CMOS晶体管','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(7,'SOI','soi','绝缘体上硅技术','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(36,'Planar CMOS','planar_cmos_1','平面CMOS晶体管','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(37,'FinFET','finfet_1','鳍式场效应晶体管，先进制程主流架构','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(38,'GAAFET','gaafet_1','全环绕栅极场效应晶体管','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(39,'CFET','cfet_1','互补场效应晶体管，GAA后演进方向','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(40,'Multi-bridge Channel FET','multi-bridge_channel_fet_1','多桥沟道FET，GAA同范畴','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(41,'SOI','soi_1','绝缘体上硅技术','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(42,'FD-SOI','fd-soi_1','全耗尽SOI，兼顾性能与功耗','2026-06-17 09:47:46','2026-06-17 09:47:46',NULL,NULL,NULL,NULL),(43,'Planar CMOS','planar_cmos_2','平面CMOS晶体管','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(44,'FinFET','finfet_2','鳍式场效应晶体管，先进制程主流架构','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(45,'GAAFET','gaafet_2','全环绕栅极场效应晶体管','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(46,'CFET','cfet_2','互补场效应晶体管，GAA后演进方向','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(47,'Multi-bridge Channel FET','multi-bridge_channel_fet_2','多桥沟道FET，GAA同范畴','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(48,'SOI','soi_2','绝缘体上硅技术','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL),(49,'FD-SOI','fd-soi_2','全耗尽SOI，兼顾性能与功耗','2026-06-17 09:48:43','2026-06-17 09:48:43',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `transistor_architecture` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tvs_diode`
--

DROP TABLE IF EXISTS `tvs_diode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvs_diode` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reverse_standoff_voltage` double DEFAULT NULL,
  `breakdown_voltage` double DEFAULT NULL,
  `clamping_voltage` double DEFAULT NULL,
  `peak_pulse_power` double DEFAULT NULL,
  `peak_pulse_current` double DEFAULT NULL,
  `reverse_leakage_current` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvs_diode`
--

LOCK TABLES `tvs_diode` WRITE;
/*!40000 ALTER TABLE `tvs_diode` DISABLE KEYS */;
INSERT INTO `tvs_diode` VALUES (1,'Vishay TVS protection diodes','vishay_tvs_protection_diodes','Vishay TVS protection diode product portfolio.','2026-06-17 08:28:54','2026-06-17 08:28:54',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `tvs_diode` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wafer_foundry`
--

DROP TABLE IF EXISTS `wafer_foundry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wafer_foundry` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mass_production_node` double DEFAULT NULL,
  `max_wafer_diameter` double DEFAULT NULL,
  `monthly_wafer_capacity` double DEFAULT NULL,
  `defect_density` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wafer_foundry`
--

LOCK TABLES `wafer_foundry` WRITE;
/*!40000 ALTER TABLE `wafer_foundry` DISABLE KEYS */;
INSERT INTO `wafer_foundry` VALUES (1,'Episil-Precision foundry services','episil-precision_foundry_services','Foundry capacity listed in SEMI WFF.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(2,'GlobalFoundries manufacturing services','globalfoundries_manufacturing_services','Foundry/manufacturing services provided by GlobalFoundries.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(3,'HLMC wafer foundry services','hlmc_wafer_foundry_services','Wafer foundry services provided by Shanghai Huali Microelectronics.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(4,'Hua Hong Grace specialty foundry services','hua_hong_grace_specialty_foundry_services','Pure-play foundry services using specialty technologies.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(5,'Intel Foundry services','intel_foundry_services','Systems foundry and semiconductor manufacturing services from Intel Foundry.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(6,'Nexchip foundry services','nexchip_foundry_services','Foundry capacity and semiconductor manufacturing services listed in SEMI WFF.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(7,'PSMC foundry services','psmc_foundry_services','Foundry capacity and semiconductor manufacturing services listed in SEMI WFF.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(8,'SMIC IC foundry services','smic_ic_foundry_services','Integrated circuit foundry and technology services provided by SMIC.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(9,'Samsung Foundry services','samsung_foundry_services','Foundry process, design technology, IP and high-volume manufacturing services.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(10,'TSMC dedicated IC foundry services','tsmc_dedicated_ic_foundry_services','Dedicated IC foundry services provided by TSMC.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(11,'UMC specialty foundry services','umc_specialty_foundry_services','Logic and specialty IC fabrication services provided by UMC.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL),(23,'Micron','micron','','2026-06-18 02:51:28','2026-06-18 02:51:28',NULL,NULL,NULL,NULL),(24,'foundry_installed_capacity','foundry_installed_capacity','','2026-06-18 03:03:31','2026-06-18 03:03:31',NULL,NULL,NULL,NULL),(25,'gross_margin','gross_margin','','2026-06-18 03:05:19','2026-06-18 03:05:19',NULL,NULL,NULL,NULL),(26,'net_income','net_income','','2026-06-18 03:05:19','2026-06-18 03:05:19',NULL,NULL,NULL,NULL),(27,'revenue','revenue','','2026-06-18 03:05:20','2026-06-18 03:05:20',NULL,NULL,NULL,NULL),(28,'operating_margin','operating_margin','','2026-06-18 03:05:20','2026-06-18 03:05:20',NULL,NULL,NULL,NULL),(29,'net_profit_attributable','net_profit_attributable','','2026-06-18 03:05:30','2026-06-18 03:05:30',NULL,NULL,NULL,NULL),(30,'capital_expenditure','capital_expenditure','','2026-06-18 03:05:30','2026-06-18 03:05:30',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `wafer_foundry` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wafer_prober`
--

DROP TABLE IF EXISTS `wafer_prober`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wafer_prober` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `unique_id` varchar(500) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `wafer_size` double DEFAULT NULL,
  `temperature_range` varchar(500) DEFAULT NULL,
  `positioning_accuracy` double DEFAULT NULL,
  `probe_card_interface` varchar(500) DEFAULT NULL,
  `throughput` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wafer_prober`
--

LOCK TABLES `wafer_prober` WRITE;
/*!40000 ALTER TABLE `wafer_prober` DISABLE KEYS */;
INSERT INTO `wafer_prober` VALUES (1,'Tokyo Electron Precio wafer prober','tokyo_electron_precio_wafer_prober','TEL Precio fully automatic wafer probing platform.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL,NULL),(2,'Tokyo Electron Prexa wafer prober','tokyo_electron_prexa_wafer_prober','TEL Prexa 300mm fully automated wafer prober.','2026-06-17 08:28:58','2026-06-17 08:28:58',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `wafer_prober` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: 127.0.0.1    Database: ontology
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `link_instance_data`
--
-- WHERE:  link_type_id COLLATE utf8mb4_unicode_ci IN (SELECT id FROM ontology.link_types WHERE project_id='project_1780997325389')

LOCK TABLES `link_instance_data` WRITE;
/*!40000 ALTER TABLE `link_instance_data` DISABLE KEYS */;
INSERT INTO `link_instance_data` VALUES (478,'lt_company_to_abf_substrate','at_s_austria_technologie_systemtechnik_ag','at_s_high-performance_ic_substrates','2026-06-17 09:19:29'),(479,'lt_company_to_abf_substrate','ibiden_co_ltd','ibiden_flip-chip_ic_package_substrate','2026-06-17 09:19:29'),(480,'lt_company_to_abf_substrate','nan_ya_printed_circuit_board_corporation','nan_ya_advanced_ic_substrate','2026-06-17 09:19:29'),(481,'lt_company_to_abf_substrate','shinko_electric_industries_co_ltd','shinko_flip-chip_package_substrate','2026-06-17 09:19:29'),(482,'lt_company_to_cmos_image_sensor','omnivision_technologies_inc','omnivision_cmos_image_sensors','2026-06-17 09:19:29'),(483,'lt_company_to_cmos_image_sensor','sony_semiconductor_solutions_corporation','sony_semiconductor_image_sensors','2026-06-17 09:19:29'),(484,'lt_company_to_cmp_equipment','applied_materials_inc','applied_materials_cmp_systems','2026-06-17 09:19:30'),(485,'lt_company_to_dram','changxin_memory_technologies_inc','cxmt_ddr5','2026-06-17 09:19:30'),(486,'lt_company_to_dram','changxin_memory_technologies_inc','cxmt_lpddr5_5x','2026-06-17 09:19:30'),(487,'lt_company_to_dram','gigadevice_semiconductor_inc','gigadevice_ddr4_sdram','2026-06-17 09:19:30'),(488,'lt_company_to_dram','gigadevice_semiconductor_inc','gigadevice_niche_dram','2026-06-17 09:19:30'),(489,'lt_company_to_dram','micron_technology_inc','micron_ddr5_sdram','2026-06-17 09:19:30'),(490,'lt_company_to_dram','micron_technology_inc','micron_ddr5_memory','2026-06-17 09:19:30'),(491,'lt_company_to_dram','micron_technology_inc','micron_gddr7_graphics_memory','2026-06-17 09:19:30'),(492,'lt_company_to_dram','nanya_technology_corporation','nanya_ddr5_dram','2026-06-17 09:19:30'),(493,'lt_company_to_dram','nanya_technology_corporation','nanya_lpddr5_5x_dram','2026-06-17 09:19:30'),(494,'lt_company_to_dram','sk_hynix_inc','sk_hynix_ddr5_dram','2026-06-17 09:19:30'),(495,'lt_company_to_dram','sk_hynix_inc','sk_hynix_lpddr5t_dram','2026-06-17 09:19:30'),(496,'lt_company_to_dram','samsung_electronics_co_ltd','samsung_ddr5_dram','2026-06-17 09:19:30'),(497,'lt_company_to_dram','samsung_electronics_co_ltd','samsung_dram','2026-06-17 09:19:30'),(498,'lt_company_to_dram','samsung_electronics_co_ltd','samsung_gddr7_dram','2026-06-17 09:19:30'),(499,'lt_company_to_eda_tool','cadence_design_systems_inc','cadence_eda_platform','2026-06-17 09:19:30'),(500,'lt_company_to_eda_tool','siemens_eda','siemens_eda_ic_design_and_verification_portfolio','2026-06-17 09:19:30'),(501,'lt_company_to_eda_tool','synopsys_inc','synopsys_eda_tools','2026-06-17 09:19:30'),(502,'lt_company_to_graphics_processing_unit','advanced_micro_devices_inc','amd_instinct_mi300x','2026-06-17 09:19:30'),(503,'lt_company_to_graphics_processing_unit','advanced_micro_devices_inc','amd_instinct_mi325x','2026-06-17 09:19:30'),(504,'lt_company_to_graphics_processing_unit','advanced_micro_devices_inc','amd_instinct_mi350_series','2026-06-17 09:19:30'),(505,'lt_company_to_graphics_processing_unit','metax_integrated_circuits_shanghai_co_ltd','metax_c500_gpu_accelerator','2026-06-17 09:19:30'),(506,'lt_company_to_graphics_processing_unit','metax_integrated_circuits_shanghai_co_ltd','metax_n100_gpu_accelerator','2026-06-17 09:19:30'),(507,'lt_company_to_graphics_processing_unit','metax_integrated_circuits_shanghai_co_ltd','metax_n260_gpu_accelerator','2026-06-17 09:19:30'),(508,'lt_company_to_graphics_processing_unit','nvidia_corporation','nvidia_b200_tensor_core_gpu','2026-06-17 09:19:30'),(509,'lt_company_to_graphics_processing_unit','nvidia_corporation','nvidia_blackwell_ultra_gpu','2026-06-17 09:19:30'),(510,'lt_company_to_graphics_processing_unit','nvidia_corporation','nvidia_h100_tensor_core_gpu','2026-06-17 09:19:30'),(511,'lt_company_to_graphics_processing_unit','nvidia_corporation','nvidia_h200_tensor_core_gpu','2026-06-17 09:19:30'),(512,'lt_company_to_graphics_processing_unit','nvidia_corporation','nvidia_rubin_gpu','2026-06-17 09:19:30'),(513,'lt_company_to_gan_hemt','infineon_technologies_ag','infineon_coolgan_transistors','2026-06-17 09:19:30'),(514,'lt_company_to_gan_hemt','navitas_semiconductor_corporation','navitas_ganfast_power_ics','2026-06-17 09:19:30'),(515,'lt_company_to_gan_hemt','rohm_co_ltd','rohm_ecogan_hemt','2026-06-17 09:19:30'),(516,'lt_company_to_gan_hemt','renesas_electronics_corporation','renesas_gan_power_discretes','2026-06-17 09:19:30'),(517,'lt_company_to_high_bandwidth_memory','micron_technology_inc','micron_hbm3e','2026-06-17 09:19:30'),(518,'lt_company_to_high_bandwidth_memory','micron_technology_inc','micron_hbm3e_12h_36gb','2026-06-17 09:19:30'),(519,'lt_company_to_high_bandwidth_memory','micron_technology_inc','micron_hbm3e_8h_24gb','2026-06-17 09:19:30'),(520,'lt_company_to_high_bandwidth_memory','sk_hynix_inc','sk_hynix_hbm3e','2026-06-17 09:19:30'),(521,'lt_company_to_high_bandwidth_memory','sk_hynix_inc','sk_hynix_hbm4','2026-06-17 09:19:30'),(522,'lt_company_to_high_bandwidth_memory','samsung_electronics_co_ltd','samsung_hbm3e','2026-06-17 09:19:30'),(523,'lt_company_to_high_bandwidth_memory','samsung_electronics_co_ltd','samsung_hbm3e_12h','2026-06-17 09:19:30'),(524,'lt_company_to_high_bandwidth_memory','samsung_electronics_co_ltd','samsung_hbm3e_shinebolt','2026-06-17 09:19:30'),(525,'lt_company_to_idm','infineon_technologies_ag','infineon_power_semiconductor_idm','2026-06-17 09:19:30'),(526,'lt_company_to_idm','intel_corporation','intel_idm_semiconductor_manufacturing','2026-06-17 09:19:30'),(527,'lt_company_to_idm','micron_technology_inc','micron_memory_idm','2026-06-17 09:19:30'),(528,'lt_company_to_idm','sk_hynix_inc','sk_hynix_memory_idm','2026-06-17 09:19:30'),(529,'lt_company_to_idm','stmicroelectronics_n_v','stmicroelectronics_integrated_semiconductor_manufacturing','2026-06-17 09:19:30'),(530,'lt_company_to_idm','samsung_electronics_co_ltd','samsung_memory_and_logic_idm','2026-06-17 09:19:30'),(531,'lt_company_to_idm','sony_semiconductor_solutions_corporation','sony_semiconductor_image_sensor_manufacturing','2026-06-17 09:19:30'),(532,'lt_company_to_idm','texas_instruments_incorporated','texas_instruments_analog_and_embedded_idm','2026-06-17 09:19:30'),(533,'lt_company_to_igbt','infineon_technologies_ag','infineon_igbt_products','2026-06-17 09:19:30'),(534,'lt_company_to_igbt','onsemi','onsemi_igbt_modules','2026-06-17 09:19:30'),(535,'lt_company_to_mems_microphone','tdk_invensense','tdk_invensense_smartsound_mems_microphones','2026-06-17 09:19:30'),(536,'lt_company_to_mlcc','murata_manufacturing_co_ltd','murata_multilayer_ceramic_capacitors','2026-06-17 09:19:31'),(537,'lt_company_to_mlcc','samsung_electro-mechanics_co_ltd','samsung_electro-mechanics_mlcc','2026-06-17 09:19:31'),(538,'lt_company_to_mlcc','tdk_corporation','tdk_multilayer_ceramic_chip_capacitors','2026-06-17 09:19:31'),(539,'lt_company_to_mlcc','yageo_corporation','yageo_multilayer_ceramic_capacitors','2026-06-17 09:19:31'),(540,'lt_company_to_mosfet','infineon_technologies_ag','infineon_mosfet_portfolio','2026-06-17 09:19:31'),(541,'lt_company_to_mosfet','onsemi','onsemi_mosfet_portfolio','2026-06-17 09:19:31'),(542,'lt_company_to_nand_flash','gigadevice_semiconductor_inc','gigadevice_spi_nand_flash','2026-06-17 09:19:31'),(543,'lt_company_to_nand_flash','kioxia_corporation','kioxia_bics_flash','2026-06-17 09:19:31'),(544,'lt_company_to_nand_flash','kioxia_corporation','kioxia_slc_nand_flash','2026-06-17 09:19:31'),(545,'lt_company_to_nand_flash','micron_technology_inc','micron_nand_flash_memory','2026-06-17 09:19:31'),(546,'lt_company_to_nand_flash','samsung_electronics_co_ltd','samsung_v-nand','2026-06-17 09:19:31'),(547,'lt_company_to_nand_flash','western_digital_corporation','western_digital_bics5_3d_nand','2026-06-17 09:19:31'),(548,'lt_company_to_nand_flash','yangtze_memory_technologies_co_ltd','ymtc_gen5_3d_nand_x4-6080','2026-06-17 09:19:31'),(549,'lt_company_to_nand_flash','yangtze_memory_technologies_co_ltd','ymtc_gen5_3d_nand_x4-9070','2026-06-17 09:19:31'),(550,'lt_company_to_nand_flash','yangtze_memory_technologies_co_ltd','ymtc_xtacking_3d_nand','2026-06-17 09:19:31'),(551,'lt_company_to_nor_flash','gigadevice_semiconductor_inc','gigadevice_spi_nor_flash','2026-06-17 09:19:31'),(552,'lt_company_to_nor_flash','infineon_technologies_ag','infineon_semper_nor_flash','2026-06-17 09:19:31'),(553,'lt_company_to_nor_flash','infineon_technologies_ag','infineon_semper_x1_lpddr_flash','2026-06-17 09:19:31'),(554,'lt_company_to_nor_flash','macronix_international_co_ltd','macronix_parallel_nor_flash','2026-06-17 09:19:31'),(555,'lt_company_to_nor_flash','macronix_international_co_ltd','macronix_serial_nor_flash','2026-06-17 09:19:31'),(556,'lt_company_to_nor_flash','winbond_electronics_corporation','winbond_w25q_qspi_nor_flash','2026-06-17 09:19:31'),(557,'lt_company_to_printed_circuit_board','at_s_austria_technologie_systemtechnik_ag','at_s_high-end_pcbs','2026-06-17 09:19:31'),(558,'lt_company_to_printed_circuit_board','nan_ya_printed_circuit_board_corporation','nan_ya_pcb_printed_circuit_boards','2026-06-17 09:19:31'),(559,'lt_company_to_pcb_electronic_resin','isola_group','isola_proprietary_pcb_resin_systems','2026-06-17 09:19:31'),(560,'lt_company_to_pcb_electronic_resin','nan_ya_plastics_corporation','nan_ya_pcb_ink_and_resin_electronic_materials','2026-06-17 09:19:31'),(561,'lt_company_to_pcb_copper_foil','mitsui_mining_smelting_co_ltd','mitsui_electrolytic_copper_foil','2026-06-17 09:19:31'),(562,'lt_company_to_pcb_copper_foil','nan_ya_plastics_corporation','nan_ya_copper_foils_for_ccl_and_pcb','2026-06-17 09:19:31'),(563,'lt_company_to_pcb_copper_foil','sumitomo_metal_mining_co_ltd','sumitomo_rolled_copper_foil','2026-06-17 09:19:31'),(564,'lt_company_to_soi_material','seh_america_inc','seh_america_soi_wafers','2026-06-17 09:19:31'),(565,'lt_company_to_soi_material','shin-etsu_chemical_co_ltd','shin-etsu_soi_wafers','2026-06-17 09:19:31'),(566,'lt_company_to_sic_mosfet','rohm_co_ltd','rohm_sic_mosfets','2026-06-17 09:19:31'),(567,'lt_company_to_sic_mosfet','wolfspeed_inc','wolfspeed_discrete_sic_mosfets','2026-06-17 09:19:31'),(568,'lt_company_to_sic_mosfet','onsemi','onsemi_elitesic_mosfets','2026-06-17 09:19:31'),(569,'lt_company_to_sic_diode','rohm_co_ltd','rohm_sic_schottky_barrier_diodes','2026-06-17 09:19:31'),(570,'lt_company_to_sic_diode','wolfspeed_inc','wolfspeed_sic_schottky_diodes','2026-06-17 09:19:31'),(571,'lt_company_to_sic_diode','onsemi','onsemi_sic_diodes','2026-06-17 09:19:31'),(572,'lt_company_to_soc_and_logic_test_equipment','advantest_corporation','advantest_v93000_soc_test_systems','2026-06-17 09:19:32'),(573,'lt_company_to_soc_and_logic_test_equipment','teradyne_inc','teradyne_semiconductor_soc_test_systems','2026-06-17 09:19:32'),(574,'lt_company_to_tvs_diode','vishay_intertechnology_inc','vishay_tvs_protection_diodes','2026-06-17 09:19:32'),(575,'lt_company_to_lithography_expose_and_write_equipment','asml_holding_n_v','asml_duv_lithography_systems','2026-06-17 09:19:32'),(576,'lt_company_to_lithography_expose_and_write_equipment','asml_holding_n_v','asml_euv_lithography_systems','2026-06-17 09:19:32'),(577,'lt_company_to_other_thin_film_deposition_equipment','applied_materials_inc','applied_materials_deposition_equipment','2026-06-17 09:19:32'),(578,'lt_company_to_other_thin_film_deposition_equipment','lam_research_corporation','lam_research_deposition_systems','2026-06-17 09:19:32'),(579,'lt_company_to_etch_equipment','applied_materials_inc','applied_materials_etch_equipment','2026-06-17 09:19:32'),(580,'lt_company_to_etch_equipment','lam_research_corporation','lam_research_etch_systems','2026-06-17 09:19:32'),(581,'lt_company_to_front_end_inspection_equipment','kla_corporation','kla_wafer_inspection_systems','2026-06-17 09:19:32'),(582,'lt_company_to_front_end_metrology_equipment','kla_corporation','kla_metrology_systems','2026-06-17 09:19:32'),(583,'lt_company_to_accelerometer','bosch_sensortec_gmbh','bosch_sensortec_3-axis_accelerometers','2026-06-17 09:19:32'),(584,'lt_company_to_accelerometer','stmicroelectronics_n_v','st_mems_accelerometers','2026-06-17 09:19:32'),(585,'lt_company_to_prepreg','isola_group','isola_pcb_prepreg_materials','2026-06-17 09:19:32'),(586,'lt_company_to_prepreg','nan_ya_plastics_corporation','nan_ya_ccl_prepreg_materials','2026-06-17 09:19:32'),(587,'lt_company_to_semiconductor_ip_core','arm_holdings_plc','arm_processor_ip','2026-06-17 09:19:32'),(588,'lt_company_to_semiconductor_ip_core','cadence_design_systems_inc','cadence_verification_and_design_ip','2026-06-17 09:19:32'),(589,'lt_company_to_semiconductor_ip_core','synopsys_inc','synopsys_semiconductor_ip','2026-06-17 09:19:32'),(590,'lt_company_to_pressure_sensor','bosch_sensortec_gmbh','bosch_sensortec_pressure_sensors','2026-06-17 09:19:33'),(591,'lt_company_to_pressure_sensor','stmicroelectronics_n_v','st_mems_pressure_sensors','2026-06-17 09:19:33'),(592,'lt_company_to_memory_test_equipment','advantest_corporation','advantest_t5800_memory_test_systems','2026-06-17 09:19:33'),(593,'lt_company_to_memory_test_equipment','teradyne_inc','teradyne_memory_test_systems','2026-06-17 09:19:33'),(594,'lt_company_to_assembly_test_service','ase_technology_holding_co_ltd','ase_semiconductor_assembly_and_test_services','2026-06-17 09:19:33'),(595,'lt_company_to_assembly_test_service','amkor_technology_inc','amkor_semiconductor_packaging_and_test_services','2026-06-17 09:19:33'),(596,'lt_company_to_assembly_test_service','jcet_group_co_ltd','jcet_turnkey_packaging_and_test_services','2026-06-17 09:19:33'),(597,'lt_company_to_assembly_test_service','powertech_technology_inc','pti_chip_probing_packaging_and_testing_services','2026-06-17 09:19:33'),(598,'lt_company_to_inertial_measurement_unit','bosch_sensortec_gmbh','bosch_sensortec_imus','2026-06-17 09:19:33'),(599,'lt_company_to_inertial_measurement_unit','tdk_invensense','tdk_invensense_icm-45605_6-axis_motion_sensor','2026-06-17 09:19:33'),(600,'lt_company_to_probe_card','formfactor_inc','formfactor_probe_cards','2026-06-17 09:19:33'),(601,'lt_company_to_inference_accelerator','advanced_micro_devices_inc','amd_instinct_mi325x','2026-06-17 09:19:33'),(602,'lt_company_to_inference_accelerator','advanced_micro_devices_inc','amd_instinct_mi350_series','2026-06-17 09:19:33'),(603,'lt_company_to_inference_accelerator','cambricon_technologies_corporation_limited','cambricon_mlu370-s4','2026-06-17 09:19:33'),(604,'lt_company_to_inference_accelerator','cambricon_technologies_corporation_limited','cambricon_mlu370-s4_cloud_inference_ai_accelerator','2026-06-17 09:19:33'),(605,'lt_company_to_inference_accelerator','cambricon_technologies_corporation_limited','cambricon_mlu370-x4','2026-06-17 09:19:33'),(606,'lt_company_to_inference_accelerator','huawei_technologies_co_ltd','huawei_ascend_310_ai_processor','2026-06-17 09:19:33'),(607,'lt_company_to_inference_accelerator','huawei_technologies_co_ltd','huawei_ascend_910_ai_processor','2026-06-17 09:19:33'),(608,'lt_company_to_inference_accelerator','intel_corporation','intel_gaudi_3_ai_accelerator','2026-06-17 09:19:33'),(609,'lt_company_to_inference_accelerator','nvidia_corporation','nvidia_b200_tensor_core_gpu','2026-06-17 09:19:33'),(610,'lt_company_to_inference_accelerator','nvidia_corporation','nvidia_h200_tensor_core_gpu','2026-06-17 09:19:33'),(611,'lt_company_to_wafer_foundry','episil-precision_inc','episil-precision_foundry_services','2026-06-17 09:19:33'),(612,'lt_company_to_wafer_foundry','globalfoundries_inc','globalfoundries_manufacturing_services','2026-06-17 09:19:33'),(613,'lt_company_to_wafer_foundry','hua_hong_semiconductor_limited','hua_hong_grace_specialty_foundry_services','2026-06-17 09:19:33'),(614,'lt_company_to_wafer_foundry','hua_li_microelectronics_corporation','hlmc_wafer_foundry_services','2026-06-17 09:19:33'),(615,'lt_company_to_wafer_foundry','intel_corporation','intel_foundry_services','2026-06-17 09:19:33'),(616,'lt_company_to_wafer_foundry','nexchip_semiconductor_corporation','nexchip_foundry_services','2026-06-17 09:19:33'),(617,'lt_company_to_wafer_foundry','powerchip_semiconductor_manufacturing_corporation','psmc_foundry_services','2026-06-17 09:19:33'),(618,'lt_company_to_wafer_foundry','samsung_electronics_co_ltd','samsung_foundry_services','2026-06-17 09:19:33'),(619,'lt_company_to_wafer_foundry','semiconductor_manufacturing_international_corporation','smic_ic_foundry_services','2026-06-17 09:19:33'),(620,'lt_company_to_wafer_foundry','taiwan_semiconductor_manufacturing_company_limited','tsmc_dedicated_ic_foundry_services','2026-06-17 09:19:33'),(621,'lt_company_to_wafer_foundry','united_microelectronics_corporation','umc_specialty_foundry_services','2026-06-17 09:19:33'),(622,'lt_company_to_wafer_prober','tokyo_electron_limited','tokyo_electron_precio_wafer_prober','2026-06-17 09:19:33'),(623,'lt_company_to_wafer_prober','tokyo_electron_limited','tokyo_electron_prexa_wafer_prober','2026-06-17 09:19:33'),(624,'lt_company_to_test_socket','formfactor_inc','formfactor_test_sockets_and_probe_interfaces','2026-06-17 09:19:33'),(625,'lt_company_to_temperature_humidity_sensor','bosch_sensortec_gmbh','bosch_sensortec_humidity_and_temperature_sensors','2026-06-17 09:19:33'),(626,'lt_company_to_electronic_glass_fiber_cloth','nitto_boseki_co_ltd','nittobo_electronic_materials_glass_cloth','2026-06-17 09:19:34'),(627,'lt_company_to_electronic_glass_fiber_cloth','taiwan_glass_industry_corporation','taiwan_glass_electronic_glass_fiber_cloth','2026-06-17 09:19:34'),(628,'lt_company_to_electronic_glass_fiber_yarn','agy_holding_corp','agy_l_glass_fiber_yarn','2026-06-17 09:19:34'),(629,'lt_company_to_electronic_glass_fiber_yarn','nitto_boseki_co_ltd','nittobo_ne-glass_yarn','2026-06-17 09:19:34'),(630,'lt_company_to_silicon_wafer','globalwafers_co_ltd','globalwafers_silicon_wafers','2026-06-17 09:19:34'),(631,'lt_company_to_silicon_wafer','seh_america_inc','seh_america_silicon_wafers','2026-06-17 09:19:34'),(632,'lt_company_to_silicon_wafer','sumco_corporation','sumco_silicon_wafers','2026-06-17 09:19:34'),(633,'lt_company_to_silicon_wafer','shin-etsu_chemical_co_ltd','shin-etsu_semiconductor_silicon_wafers','2026-06-17 09:19:34'),(634,'lt_company_to_silicon_wafer','siltronic_ag','siltronic_silicon_wafers','2026-06-17 09:19:34'),(635,'lt_company_to_magnetic_sensor','bosch_sensortec_gmbh','bosch_sensortec_magnetometers','2026-06-17 09:19:34'),(636,'lt_company_to_schottky_diode','rohm_co_ltd','rohm_schottky_barrier_diodes','2026-06-17 09:19:34'),(637,'lt_company_to_schottky_diode','vishay_intertechnology_inc','vishay_schottky_rectifiers','2026-06-17 09:19:34'),(638,'lt_company_to_automatic_test_equipment','advantest_corporation','advantest_automated_test_equipment','2026-06-17 09:19:34'),(639,'lt_company_to_automatic_test_equipment','teradyne_inc','teradyne_semiconductor_test_systems','2026-06-17 09:19:34'),(640,'lt_company_to_copper_clad_laminate','isola_group','isola_pcb_laminates','2026-06-17 09:19:34'),(641,'lt_company_to_copper_clad_laminate','kingboard_laminates_holdings_ltd','kingboard_copper_clad_laminates','2026-06-17 09:19:34'),(642,'lt_company_to_copper_clad_laminate','nan_ya_plastics_corporation','nan_ya_copper_clad_laminates','2026-06-17 09:19:34'),(643,'lt_company_to_training_accelerator','advanced_micro_devices_inc','amd_instinct_mi300x','2026-06-17 09:19:34'),(644,'lt_company_to_training_accelerator','advanced_micro_devices_inc','amd_instinct_mi325x','2026-06-17 09:19:34'),(645,'lt_company_to_training_accelerator','advanced_micro_devices_inc','amd_instinct_mi350_series','2026-06-17 09:19:34'),(646,'lt_company_to_training_accelerator','cambricon_technologies_corporation_limited','cambricon_mlu370-x8','2026-06-17 09:19:34'),(647,'lt_company_to_training_accelerator','cambricon_technologies_corporation_limited','cambricon_mlu370-x8_cloud_training_ai_accelerator','2026-06-17 09:19:34'),(648,'lt_company_to_training_accelerator','huawei_technologies_co_ltd','huawei_ascend_910_ai_processor','2026-06-17 09:19:34'),(649,'lt_company_to_training_accelerator','huawei_technologies_co_ltd','huawei_ascend_910c_ai_processor','2026-06-17 09:19:34'),(650,'lt_company_to_training_accelerator','intel_corporation','intel_gaudi_3_ai_accelerator','2026-06-17 09:19:34'),(651,'lt_company_to_training_accelerator','metax_integrated_circuits_shanghai_co_ltd','metax_c500_gpu_accelerator','2026-06-17 09:19:34'),(652,'lt_company_to_training_accelerator','nvidia_corporation','nvidia_b200_tensor_core_gpu','2026-06-17 09:19:34'),(653,'lt_company_to_training_accelerator','nvidia_corporation','nvidia_gb200_nvl72','2026-06-17 09:19:34'),(654,'lt_company_to_training_accelerator','nvidia_corporation','nvidia_h100_tensor_core_gpu','2026-06-17 09:19:34'),(655,'lt_company_to_training_accelerator','nvidia_corporation','nvidia_h200_tensor_core_gpu','2026-06-17 09:19:34'),(656,'lt_company_to_edge_ai_accelerator','cambricon_technologies_corporation_limited','cambricon_mlu220-m_2','2026-06-17 09:19:34'),(657,'lt_company_to_edge_ai_accelerator','cambricon_technologies_corporation_limited','cambricon_siyuan_220_edge_ai_chip','2026-06-17 09:19:34'),(658,'lt_company_to_gyroscope','bosch_sensortec_gmbh','bosch_sensortec_gyroscopes','2026-06-17 09:19:34'),(659,'lt_company_to_gyroscope','tdk_invensense','tdk_invensense_gyroscope_sensors','2026-06-17 09:19:34');
/*!40000 ALTER TABLE `link_instance_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 21:55:12
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
