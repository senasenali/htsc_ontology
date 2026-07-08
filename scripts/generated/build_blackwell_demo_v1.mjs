import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const __filename = fileURLToPath(import.meta.url);
const repoRoot = path.resolve(path.dirname(__filename), "../..");
const outputDir = path.join(repoRoot, "outputs/blackwell_demo_v1");
const sourceOntologyPath = path.join(repoRoot, "data/ontology/semiconductor_ontology_ot_lt_with_relation_objects.json");
const outputOntologyPath = path.join(repoRoot, "outputs/blackwell_demo_v1/semiconductor_ontology_blackwell_demo_v1.json");
const outputWorkbookPath = path.join(repoRoot, "outputs/blackwell_demo_v1/blackwell_technology_transmission_demo_v1.xlsx");
const outputSqlPath = path.join(repoRoot, "outputs/blackwell_demo_v1/import_blackwell_demo_v1.sql");

const sources = {
  nvidiaBlackwell: "https://www.nvidia.com/en-us/data-center/technologies/blackwell-architecture/",
  nvidiaGB200: "https://www.nvidia.com/en-us/data-center/gb200-nvl72/",
  tsmcCowos: "https://3dfabric.tsmc.com/english/dedicatedFoundry/technology/cowos.htm",
  micronHbm3e: "https://www.micron.com/products/memory/hbm/hbm3e",
  samsungHbm3e: "https://semiconductor.samsung.com/dram/hbm/hbm3e/",
  skHynixHbm3e: "https://news.skhynix.com/sk-hynix-begins-volume-production-of-industrys-first-hbm3e/",
  skHynix12Hi: "https://news.skhynix.com/sk-hynix-begins-volume-production-of-worlds-first-12-layer-hbm3e/",
  tsmcFacilities: "https://en.wikipedia.org/wiki/TSMC",
  ibiden: "https://www.ibiden.com/product/electronics/package_substrate/",
  unimicron: "https://www.unimicron.com/en/product/IC-Substrate",
  shinko: "https://www.shinko.co.jp/english/product/package/",
  besi: "https://www.besi.com/products/advanced-packaging/",
  asmpt: "https://www.asmpt.com/en/products/semiconductor-solutions/advanced-packaging",
  kulicke: "https://www.kns.com/Products/Advanced-Packaging",
  disco: "https://www.disco.co.jp/eg/products/grinder/",
};

const otProperties = {
  "GPU": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["架构世代", "architecture_generation", "string", ""],
    ["计算芯粒数量", "compute_die_count", "integer", "dies"],
    ["制程平台", "process_platform", "string", ""],
    ["HBM代际", "hbm_generation", "string", ""],
    ["HBM容量", "hbm_capacity", "number", "GB"],
    ["HBM带宽", "hbm_bandwidth", "number", "TB/s"],
    ["封装方案", "packaging_solution", "string", ""],
    ["目标应用", "target_application", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "训练加速器": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["架构世代", "architecture_generation", "string", ""],
    ["GPU数量", "gpu_count", "integer", "units"],
    ["CPU配置", "cpu_configuration", "string", ""],
    ["HBM容量", "hbm_capacity", "number", "GB"],
    ["HBM带宽", "hbm_bandwidth", "number", "TB/s"],
    ["互连方式", "interconnect", "string", ""],
    ["目标负载", "target_workload", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "GPU架构世代": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["发布时间", "release_date", "string", ""],
    ["计算芯粒数量", "compute_die_count", "integer", "dies"],
    ["芯粒互连带宽", "die_to_die_bandwidth", "number", "TB/s"],
    ["晶体管数量", "transistor_count", "number", "billion"],
    ["制程平台", "process_platform", "string", ""],
    ["技术瓶颈", "technical_bottleneck", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "HBM": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["代际", "generation", "string", ""],
    ["堆叠层数", "stack_height", "integer", "layers"],
    ["单堆容量", "capacity_per_stack", "number", "GB"],
    ["引脚速率", "pin_speed", "number", "Gbps"],
    ["单堆带宽", "bandwidth_per_stack", "number", "TB/s"],
    ["I/O位宽", "io_width", "integer", "bit"],
    ["供应商", "supplier", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "HBM世代": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["代际名称", "generation_name", "string", ""],
    ["典型堆叠层数", "typical_stack_height", "string", "layers"],
    ["典型单堆容量", "typical_capacity_per_stack", "string", "GB"],
    ["典型单堆带宽", "typical_bandwidth_per_stack", "string", "TB/s"],
    ["技术意义", "technology_significance", "string", ""],
  ],
  "封装方案": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["技术类型", "technology_type", "string", ""],
    ["中介层形态", "interposer_type", "string", ""],
    ["本地硅互连", "local_silicon_interconnect", "string", ""],
    ["适配多芯粒", "multi_die_support", "string", ""],
    ["适配HBM", "hbm_support", "string", ""],
    ["关键瓶颈", "key_bottleneck", "string", ""],
    ["供应商", "provider", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "先进封装技术": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["封装类型", "packaging_type", "string", ""],
    ["集成维度", "integration_dimension", "string", ""],
    ["最大芯粒数量", "max_die_count", "string", "dies"],
    ["互连密度要求", "interconnect_density_requirement", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "封装技术世代": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["世代名称", "generation_name", "string", ""],
    ["封装维度", "packaging_dimension", "string", ""],
    ["代表技术", "representative_technology", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "封装测试服务": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["服务类型", "service_type", "string", ""],
    ["支持封装方案", "supported_packaging_solution", "string", ""],
    ["支持产品", "supported_product", "string", ""],
    ["产能状态", "capacity_status", "string", ""],
    ["服务商", "provider", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "后道工厂": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["所属公司", "owner_company", "string", ""],
    ["国家地区", "country_region", "string", ""],
    ["城市/园区", "city_or_site", "string", ""],
    ["工厂类型", "facility_type", "string", ""],
    ["相关技术", "related_technology", "string", ""],
    ["状态", "status", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "ABF载板": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["介质材料", "dielectric_material", "string", ""],
    ["目标应用", "target_application", "string", ""],
    ["供应商", "supplier", "string", ""],
    ["需求驱动", "demand_driver", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "倒装键合机": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["设备类别", "equipment_category", "string", ""],
    ["供应商", "supplier", "string", ""],
    ["支撑工艺", "supported_process", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "混合键合机": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["设备类别", "equipment_category", "string", ""],
    ["供应商", "supplier", "string", ""],
    ["支撑工艺", "supported_process", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "晶圆减薄机": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["设备类别", "equipment_category", "string", ""],
    ["供应商", "supplier", "string", ""],
    ["支撑工艺", "supported_process", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "资本开支": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["资本开支金额", "capex_amount", "number", ""],
    ["币种", "currency", "string", ""],
    ["统计周期", "period", "string", ""],
    ["开支类别", "capex_category", "string", ""],
    ["地区", "region", "string", ""],
    ["产能或技术用途", "capacity_or_technology_purpose", "string", ""],
    ["主体公司", "company_name", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
  "数据中心计算应用": [
    ["实例ID", "instance_id", "string", ""],
    ["实例名称", "nameCn", "string", ""],
    ["应用场景", "application_scenario", "string", ""],
    ["计算需求", "compute_requirement", "string", ""],
    ["传导作用", "transmission_role", "string", ""],
  ],
};

const objectRows = {
  "公司": [
    ["obj_company_nvidia", "NVIDIA Corporation", "NVIDIA Corporation", "公司", "GPU and accelerated computing platform supplier.", sources.nvidiaBlackwell],
    ["obj_company_tsmc", "Taiwan Semiconductor Manufacturing Company Limited", "TSMC", "公司", "Foundry and advanced packaging provider for CoWoS/3DFabric.", sources.tsmcCowos],
    ["obj_company_skhynix", "SK hynix Inc.", "SK hynix", "公司", "Memory supplier with HBM3E products.", sources.skHynixHbm3e],
    ["obj_company_micron", "Micron Technology Inc.", "Micron", "公司", "Memory supplier with HBM3E products.", sources.micronHbm3e],
    ["obj_company_samsung", "Samsung Electronics Co. Ltd.", "Samsung Electronics", "公司", "Memory supplier with HBM3E products.", sources.samsungHbm3e],
    ["obj_company_ibiden", "Ibiden Co., Ltd.", "Ibiden", "公司", "IC package substrate supplier.", sources.ibiden],
    ["obj_company_unimicron", "Unimicron Technology Corporation", "Unimicron", "公司", "IC substrate supplier.", sources.unimicron],
    ["obj_company_shinko", "Shinko Electric Industries Co., Ltd.", "Shinko Electric", "公司", "Semiconductor package supplier.", sources.shinko],
    ["obj_company_besi", "BE Semiconductor Industries N.V.", "BESI", "公司", "Advanced packaging equipment supplier.", sources.besi],
    ["obj_company_asmpt", "ASMPT Limited", "ASMPT", "公司", "Advanced packaging and semiconductor assembly equipment supplier.", sources.asmpt],
    ["obj_company_kulicke", "Kulicke and Soffa Industries, Inc.", "K&S", "公司", "Advanced packaging equipment supplier.", sources.kulicke],
    ["obj_company_disco", "DISCO Corporation", "DISCO", "公司", "Wafer grinding and thinning equipment supplier.", sources.disco],
  ],
  "GPU": [
    ["obj_gpu_nvidia_b200", "NVIDIA B200 Tensor Core GPU", "NVIDIA B200", "GPU", "NVIDIA Blackwell Architecture", 2, "TSMC 4NP", "HBM3E", 192, 8, "TSMC CoWoS-L", "AI training and inference", "核心产品实例，承接双计算芯粒、HBM3E、先进封装需求", sources.nvidiaBlackwell],
  ],
  "训练加速器": [
    ["obj_training_accelerator_gb200", "NVIDIA GB200 Grace Blackwell Superchip", "NVIDIA GB200", "训练加速器", "NVIDIA Blackwell Architecture", 2, "1 Grace CPU", 372, 16, "NVLink-C2C / NVLink", "AI training and trillion-parameter inference", "系统级训练加速实例，连接架构、GPU、HBM与数据中心应用", sources.nvidiaGB200],
  ],
  "GPU架构世代": [
    ["obj_gpu_arch_blackwell", "NVIDIA Blackwell Architecture", "Blackwell", "GPU架构世代", "2024-03-18", 2, 10, 208, "TSMC 4NP", "reticle-limited die, yield, compute scaling", "技术路线起点：双reticle-limited dies推动Chiplet和封装升级", sources.nvidiaBlackwell],
  ],
  "HBM": [
    ["obj_hbm_skhynix_hbm3e", "SK hynix HBM3E", "SK hynix HBM3E", "HBM", "HBM3E", 12, 36, null, null, 1024, "SK hynix", "高带宽存储需求受Blackwell/GB200拉动", sources.skHynix12Hi],
    ["obj_hbm_micron_hbm3e", "Micron HBM3E", "Micron HBM3E", "HBM", "HBM3E", 8, 24, 9.2, 1.2, 1024, "Micron", "高带宽存储供给候选", sources.micronHbm3e],
    ["obj_hbm_samsung_hbm3e", "Samsung HBM3E", "Samsung HBM3E", "HBM", "HBM3E", null, null, null, null, 1024, "Samsung Electronics", "高带宽存储供给候选", sources.samsungHbm3e],
    ["obj_hbm_hbm3e_generic", "HBM3E", "HBM3E", "HBM", "HBM3E", null, null, null, null, 1024, "Multiple suppliers", "作为CoWoS-L适配对象的通用HBM3E实例", sources.micronHbm3e],
  ],
  "HBM世代": [
    ["obj_hbm_generation_hbm3e", "HBM3E Generation", "HBM3E", "HBM世代", "HBM3E", "8-high / 12-high", "24GB / 36GB", ">1.2TB/s per placement for Micron disclosed parts", "AI GPU的高带宽显存代际升级", sources.micronHbm3e],
  ],
  "封装方案": [
    ["obj_packaging_solution_tsmc_cowos_l", "TSMC CoWoS-L", "CoWoS-L", "封装方案", "2.5D advanced packaging", "RDL-based interposer with embedded local silicon interconnect", "LSI", "Yes", "HBM stacks and large HPC products", "larger package size and high routing density", "TSMC", "承接Blackwell双芯粒和HBM3E堆栈的封装方案", sources.tsmcCowos],
  ],
  "先进封装技术": [
    ["obj_adv_packaging_chiplet_multi_die", "Chiplet / Multi-die Integration", "Chiplet integration", "先进封装技术", "advanced packaging", "2.5D / multi-die", "NULL", "high", "把单大芯片演进为多die系统级封装", sources.nvidiaBlackwell],
    ["obj_adv_packaging_cowos", "TSMC CoWoS Advanced Packaging", "CoWoS", "先进封装技术", "2.5D advanced packaging", "2.5D", "NULL", "high", "CoWoS-L的技术能力承载层", sources.tsmcCowos],
  ],
  "封装技术世代": [
    ["obj_packaging_generation_2_5d", "2.5D Advanced Packaging Generation", "2.5D advanced packaging", "封装技术世代", "2.5D advanced packaging", "2.5D", "CoWoS / CoWoS-L", "先进封装代际，连接封装技术和具体封装方案", sources.tsmcCowos],
  ],
  "封装测试服务": [
    ["obj_service_tsmc_cowos", "TSMC CoWoS Advanced Packaging Service", "TSMC CoWoS service", "封装测试服务", "advanced packaging service", "TSMC CoWoS-L", "NVIDIA Blackwell GPU / AI accelerator", "capacity expanding", "TSMC", "产能瓶颈和扩产承接环节", sources.tsmcCowos],
  ],
  "后道工厂": [
    ["obj_facility_tsmc_ap6", "TSMC Advanced Backend Fab 6 (AP6)", "TSMC AP6", "后道工厂", "TSMC", "Taiwan", "Zhunan", "advanced backend fab", "3DFabric / CoWoS", "operational / expansion referenced publicly", "CoWoS扩产的设施承接对象", sources.tsmcFacilities],
  ],
  "ABF载板": [
    ["obj_abf_substrate", "ABF Substrate", "ABF substrate", "ABF载板", "ABF build-up film", "HPC GPU / AI accelerator packaging", "Ibiden / Unimicron / Shinko", "large package and high-density interconnect", "CoWoS-L后续带动的封装基板需求", sources.ibiden],
  ],
  "倒装键合机": [
    ["obj_equipment_flip_chip_bonder", "Flip Chip Bonder", "Flip chip bonder", "倒装键合机", "advanced packaging bonding equipment", "BESI / ASMPT / K&S", "flip-chip attach for advanced packaging", "先进封装贴装/键合设备需求", sources.besi],
  ],
  "混合键合机": [
    ["obj_equipment_hybrid_bonder", "Hybrid Bonder", "Hybrid bonder", "混合键合机", "advanced bonding equipment", "BESI / ASMPT", "hybrid bonding / high-density interconnect", "更高互连密度下的设备候选", sources.besi],
  ],
  "晶圆减薄机": [
    ["obj_equipment_wafer_thinning", "Wafer Thinning Equipment", "Wafer grinder/thinning equipment", "晶圆减薄机", "back-end wafer processing equipment", "DISCO", "wafer thinning for advanced packaging", "先进封装前后道处理设备需求", sources.disco],
  ],
  "资本开支": [
    ["obj_metric_tsmc_adv_packaging_capex", "TSMC Advanced Packaging CapEx", "TSMC advanced packaging capex", "资本开支", null, "NULL", "2024-2026", "advanced packaging capacity expansion", "Taiwan", "CoWoS / 3DFabric capacity", "TSMC", "扩产和设备采购的市场层观察指标", sources.tsmcCowos],
  ],
  "数据中心计算应用": [
    ["obj_app_ai_server_training", "AI Server / Data Center AI Training", "AI server training", "数据中心计算应用", "large-scale AI training and inference", "high GPU compute, high memory bandwidth, scale-up interconnect", "需求端起点，解释Blackwell产品需求", sources.nvidiaGB200],
  ],
};

const objectHeaders = {
  "公司": ["instance_id", "nameCn", "nameEn", "objectTypeName", "description", "source_url"],
  "GPU": ["instance_id", "nameCn", "nameEn", "objectTypeName", "architecture_generation", "compute_die_count", "process_platform", "hbm_generation", "hbm_capacity_GB", "hbm_bandwidth_TBps", "packaging_solution", "target_application", "transmission_role", "source_url"],
  "训练加速器": ["instance_id", "nameCn", "nameEn", "objectTypeName", "architecture_generation", "gpu_count", "cpu_configuration", "hbm_capacity_GB", "hbm_bandwidth_TBps", "interconnect", "target_workload", "transmission_role", "source_url"],
  "GPU架构世代": ["instance_id", "nameCn", "nameEn", "objectTypeName", "release_date", "compute_die_count", "die_to_die_bandwidth_TBps", "transistor_count_billion", "process_platform", "technical_bottleneck", "transmission_role", "source_url"],
  "HBM": ["instance_id", "nameCn", "nameEn", "objectTypeName", "generation", "stack_height_layers", "capacity_per_stack_GB", "pin_speed_Gbps", "bandwidth_per_stack_TBps", "io_width_bit", "supplier", "transmission_role", "source_url"],
  "HBM世代": ["instance_id", "nameCn", "nameEn", "objectTypeName", "generation_name", "typical_stack_height", "typical_capacity_per_stack", "typical_bandwidth_per_stack", "technology_significance", "source_url"],
  "封装方案": ["instance_id", "nameCn", "nameEn", "objectTypeName", "technology_type", "interposer_type", "local_silicon_interconnect", "multi_die_support", "hbm_support", "key_bottleneck", "provider", "transmission_role", "source_url"],
  "先进封装技术": ["instance_id", "nameCn", "nameEn", "objectTypeName", "packaging_type", "integration_dimension", "max_die_count", "interconnect_density_requirement", "transmission_role", "source_url"],
  "封装技术世代": ["instance_id", "nameCn", "nameEn", "objectTypeName", "generation_name", "packaging_dimension", "representative_technology", "transmission_role", "source_url"],
  "封装测试服务": ["instance_id", "nameCn", "nameEn", "objectTypeName", "service_type", "supported_packaging_solution", "supported_product", "capacity_status", "provider", "transmission_role", "source_url"],
  "后道工厂": ["instance_id", "nameCn", "nameEn", "objectTypeName", "owner_company", "country_region", "city_or_site", "facility_type", "related_technology", "status", "transmission_role", "source_url"],
  "ABF载板": ["instance_id", "nameCn", "nameEn", "objectTypeName", "dielectric_material", "target_application", "supplier", "demand_driver", "transmission_role", "source_url"],
  "倒装键合机": ["instance_id", "nameCn", "nameEn", "objectTypeName", "equipment_category", "supplier", "supported_process", "transmission_role", "source_url"],
  "混合键合机": ["instance_id", "nameCn", "nameEn", "objectTypeName", "equipment_category", "supplier", "supported_process", "transmission_role", "source_url"],
  "晶圆减薄机": ["instance_id", "nameCn", "nameEn", "objectTypeName", "equipment_category", "supplier", "supported_process", "transmission_role", "source_url"],
  "资本开支": ["instance_id", "nameCn", "nameEn", "objectTypeName", "capex_amount", "currency", "period", "capex_category", "region", "capacity_or_technology_purpose", "company_name", "transmission_role", "source_url"],
  "数据中心计算应用": ["instance_id", "nameCn", "nameEn", "objectTypeName", "application_scenario", "compute_requirement", "transmission_role", "source_url"],
};

const existingLt = [
  ["lt_graphics_processing_unit_adopts_gpu_architecture_generation", "GPU采用GPU架构世代", "GPU", "采用", "GPU架构世代", "已有"],
  ["lt_training_accelerator_adopts_gpu_architecture_generation", "训练加速器采用GPU架构世代", "训练加速器", "采用", "GPU架构世代", "已有"],
  ["lt_high_bandwidth_memory_supplies_to_graphics_processing_unit", "HBM供给于GPU", "HBM", "供给于", "GPU", "已有"],
  ["lt_company_produces_for_assembly_test_service", "公司生产供给封装测试服务", "公司", "生产供给", "封装测试服务", "已有"],
  ["lt_assembly_test_service_supports_capability_of_graphics_processing_unit", "封装测试服务能力支撑GPU", "封装测试服务", "能力支撑", "GPU", "已有"],
  ["lt_backend_facility_relation_company", "后道工厂属于公司", "后道工厂", "属于", "公司", "已有"],
  ["lt_backend_facility_produces_for_assembly_test_service", "后道工厂生产供给封装测试服务", "后道工厂", "生产供给", "封装测试服务", "已有"],
  ["lt_abf_substrate_supplies_to_graphics_processing_unit", "ABF载板供给于GPU", "ABF载板", "供给于", "GPU", "已有"],
  ["lt_company_produces_for_abf_substrate", "公司生产供给ABF载板", "公司", "生产供给", "ABF载板", "已有"],
  ["lt_flip_chip_bonding_equipment_supports_capability_of_assembly_test_service", "倒装键合机能力支撑封装测试服务", "倒装键合机", "能力支撑", "封装测试服务", "已有"],
  ["lt_hybrid_bonding_equipment_supports_capability_of_assembly_test_service", "混合键合机能力支撑封装测试服务", "混合键合机", "能力支撑", "封装测试服务", "已有"],
  ["lt_wafer_thinning_equipment_supports_capability_of_assembly_test_service", "晶圆减薄机能力支撑封装测试服务", "晶圆减薄机", "能力支撑", "封装测试服务", "已有"],
  ["lt_capital_expenditure_measures_for_assembly_test_service", "资本开支统计对象封装测试服务", "资本开支", "统计对象", "封装测试服务", "已有"],
  ["lt_capital_expenditure_measures_for_backend_facility", "资本开支统计对象后道工厂", "资本开支", "统计对象", "后道工厂", "已有"],
  ["lt_packaging_technology_generation_relation_advanced_packaging_technology", "封装技术世代对应先进封装技术", "封装技术世代", "对应", "先进封装技术", "已有"],
  ["lt_graphics_processing_unit_relation_ai_server_application", "GPU下游应用数据中心计算应用", "GPU", "下游应用", "数据中心计算应用", "已有"],
  ["lt_training_accelerator_relation_ai_server_application", "训练加速器下游应用数据中心计算应用", "训练加速器", "下游应用", "数据中心计算应用", "已有"],
];

const newLt = [
  ["lt_gpu_architecture_generation_drives_advanced_packaging_technology", "GPU架构世代驱动先进封装技术", "GPU架构世代", "驱动", "先进封装技术", "新增", "Blackwell双计算芯粒/Chiplet化驱动先进封装能力需求。"],
  ["lt_advanced_packaging_technology_corresponds_to_packaging_solution", "先进封装技术对应封装方案", "先进封装技术", "对应", "封装方案", "新增", "把Chiplet/2.5D技术能力落到CoWoS-L等具体封装方案。"],
  ["lt_graphics_processing_unit_adopts_packaging_solution", "GPU采用封装方案", "GPU", "采用", "封装方案", "新增", "表达B200/Blackwell产品与CoWoS-L封装方案的实例级绑定。"],
  ["lt_packaging_solution_supports_high_bandwidth_memory", "封装方案适配HBM", "封装方案", "适配", "HBM", "新增", "表达CoWoS-L承载GPU die与HBM3E堆栈互连的能力。"],
  ["lt_high_bandwidth_memory_adopts_hbm_generation", "HBM采用HBM世代", "HBM", "采用", "HBM世代", "新增", "将HBM3E产品实例与HBM3E技术世代连接。"],
];

const linkTypeChanges = [
  ["link_type_id", "linkTypeName", "source_ot", "predicate", "target_ot", "status", "reason"],
  ...newLt,
];

const linkRows = [
  ["link_type_id", "source_instance_id", "target_instance_id", "linkTypeName", "sourceInstance", "targetInstance", "source_ot", "target_ot", "chain_step"],
  ["lt_training_accelerator_relation_ai_server_application", "obj_training_accelerator_gb200", "obj_app_ai_server_training", "训练加速器下游应用数据中心计算应用", "NVIDIA GB200 Grace Blackwell Superchip", "AI Server / Data Center AI Training", "训练加速器", "数据中心计算应用", "00 需求侧应用"],
  ["lt_graphics_processing_unit_relation_ai_server_application", "obj_gpu_nvidia_b200", "obj_app_ai_server_training", "GPU下游应用数据中心计算应用", "NVIDIA B200 Tensor Core GPU", "AI Server / Data Center AI Training", "GPU", "数据中心计算应用", "01 AI需求拉动GPU"],
  ["lt_graphics_processing_unit_adopts_gpu_architecture_generation", "obj_gpu_nvidia_b200", "obj_gpu_arch_blackwell", "GPU采用GPU架构世代", "NVIDIA B200 Tensor Core GPU", "NVIDIA Blackwell Architecture", "GPU", "GPU架构世代", "02 B200采用Blackwell架构"],
  ["lt_training_accelerator_adopts_gpu_architecture_generation", "obj_training_accelerator_gb200", "obj_gpu_arch_blackwell", "训练加速器采用GPU架构世代", "NVIDIA GB200 Grace Blackwell Superchip", "NVIDIA Blackwell Architecture", "训练加速器", "GPU架构世代", "03 GB200采用Blackwell架构"],
  ["lt_gpu_architecture_generation_drives_advanced_packaging_technology", "obj_gpu_arch_blackwell", "obj_adv_packaging_chiplet_multi_die", "GPU架构世代驱动先进封装技术", "NVIDIA Blackwell Architecture", "Chiplet / Multi-die Integration", "GPU架构世代", "先进封装技术", "04 双计算芯粒驱动Chiplet/先进封装"],
  ["lt_packaging_technology_generation_relation_advanced_packaging_technology", "obj_packaging_generation_2_5d", "obj_adv_packaging_cowos", "封装技术世代对应先进封装技术", "2.5D Advanced Packaging Generation", "TSMC CoWoS Advanced Packaging", "封装技术世代", "先进封装技术", "05 2.5D封装世代对应CoWoS"],
  ["lt_advanced_packaging_technology_corresponds_to_packaging_solution", "obj_adv_packaging_cowos", "obj_packaging_solution_tsmc_cowos_l", "先进封装技术对应封装方案", "TSMC CoWoS Advanced Packaging", "TSMC CoWoS-L", "先进封装技术", "封装方案", "06 CoWoS技术落到CoWoS-L方案"],
  ["lt_graphics_processing_unit_adopts_packaging_solution", "obj_gpu_nvidia_b200", "obj_packaging_solution_tsmc_cowos_l", "GPU采用封装方案", "NVIDIA B200 Tensor Core GPU", "TSMC CoWoS-L", "GPU", "封装方案", "07 B200采用CoWoS-L"],
  ["lt_packaging_solution_supports_high_bandwidth_memory", "obj_packaging_solution_tsmc_cowos_l", "obj_hbm_hbm3e_generic", "封装方案适配HBM", "TSMC CoWoS-L", "HBM3E", "封装方案", "HBM", "08 CoWoS-L适配HBM3E"],
  ["lt_high_bandwidth_memory_adopts_hbm_generation", "obj_hbm_skhynix_hbm3e", "obj_hbm_generation_hbm3e", "HBM采用HBM世代", "SK hynix HBM3E", "HBM3E Generation", "HBM", "HBM世代", "09 HBM产品绑定HBM3E世代"],
  ["lt_high_bandwidth_memory_supplies_to_graphics_processing_unit", "obj_hbm_skhynix_hbm3e", "obj_gpu_nvidia_b200", "HBM供给于GPU", "SK hynix HBM3E", "NVIDIA B200 Tensor Core GPU", "HBM", "GPU", "10 HBM3E供给B200"],
  ["lt_high_bandwidth_memory_supplies_to_graphics_processing_unit", "obj_hbm_micron_hbm3e", "obj_gpu_nvidia_b200", "HBM供给于GPU", "Micron HBM3E", "NVIDIA B200 Tensor Core GPU", "HBM", "GPU", "11 HBM3E候选供给B200"],
  ["lt_company_produces_for_assembly_test_service", "obj_company_tsmc", "obj_service_tsmc_cowos", "公司生产供给封装测试服务", "Taiwan Semiconductor Manufacturing Company Limited", "TSMC CoWoS Advanced Packaging Service", "公司", "封装测试服务", "12 台积电供给CoWoS服务"],
  ["lt_assembly_test_service_supports_capability_of_graphics_processing_unit", "obj_service_tsmc_cowos", "obj_gpu_nvidia_b200", "封装测试服务能力支撑GPU", "TSMC CoWoS Advanced Packaging Service", "NVIDIA B200 Tensor Core GPU", "封装测试服务", "GPU", "13 CoWoS服务支撑B200"],
  ["lt_backend_facility_relation_company", "obj_facility_tsmc_ap6", "obj_company_tsmc", "后道工厂属于公司", "TSMC Advanced Backend Fab 6 (AP6)", "Taiwan Semiconductor Manufacturing Company Limited", "后道工厂", "公司", "14 AP6属于台积电"],
  ["lt_backend_facility_produces_for_assembly_test_service", "obj_facility_tsmc_ap6", "obj_service_tsmc_cowos", "后道工厂生产供给封装测试服务", "TSMC Advanced Backend Fab 6 (AP6)", "TSMC CoWoS Advanced Packaging Service", "后道工厂", "封装测试服务", "15 后道工厂承接CoWoS服务"],
  ["lt_abf_substrate_supplies_to_graphics_processing_unit", "obj_abf_substrate", "obj_gpu_nvidia_b200", "ABF载板供给于GPU", "ABF Substrate", "NVIDIA B200 Tensor Core GPU", "ABF载板", "GPU", "16 ABF载板供给B200"],
  ["lt_company_produces_for_abf_substrate", "obj_company_ibiden", "obj_abf_substrate", "公司生产供给ABF载板", "Ibiden Co., Ltd.", "ABF Substrate", "公司", "ABF载板", "17 ABF供应商"],
  ["lt_company_produces_for_abf_substrate", "obj_company_unimicron", "obj_abf_substrate", "公司生产供给ABF载板", "Unimicron Technology Corporation", "ABF Substrate", "公司", "ABF载板", "18 ABF供应商"],
  ["lt_company_produces_for_abf_substrate", "obj_company_shinko", "obj_abf_substrate", "公司生产供给ABF载板", "Shinko Electric Industries Co., Ltd.", "ABF Substrate", "公司", "ABF载板", "19 ABF供应商"],
  ["lt_flip_chip_bonding_equipment_supports_capability_of_assembly_test_service", "obj_equipment_flip_chip_bonder", "obj_service_tsmc_cowos", "倒装键合机能力支撑封装测试服务", "Flip Chip Bonder", "TSMC CoWoS Advanced Packaging Service", "倒装键合机", "封装测试服务", "20 倒装键合设备支撑CoWoS"],
  ["lt_hybrid_bonding_equipment_supports_capability_of_assembly_test_service", "obj_equipment_hybrid_bonder", "obj_service_tsmc_cowos", "混合键合机能力支撑封装测试服务", "Hybrid Bonder", "TSMC CoWoS Advanced Packaging Service", "混合键合机", "封装测试服务", "21 混合键合设备候选支撑"],
  ["lt_wafer_thinning_equipment_supports_capability_of_assembly_test_service", "obj_equipment_wafer_thinning", "obj_service_tsmc_cowos", "晶圆减薄机能力支撑封装测试服务", "Wafer Thinning Equipment", "TSMC CoWoS Advanced Packaging Service", "晶圆减薄机", "封装测试服务", "22 晶圆减薄设备支撑"],
  ["lt_capital_expenditure_measures_for_assembly_test_service", "obj_metric_tsmc_adv_packaging_capex", "obj_service_tsmc_cowos", "资本开支统计对象封装测试服务", "TSMC Advanced Packaging CapEx", "TSMC CoWoS Advanced Packaging Service", "资本开支", "封装测试服务", "23 CapEx统计CoWoS服务"],
  ["lt_capital_expenditure_measures_for_backend_facility", "obj_metric_tsmc_adv_packaging_capex", "obj_facility_tsmc_ap6", "资本开支统计对象后道工厂", "TSMC Advanced Packaging CapEx", "TSMC Advanced Backend Fab 6 (AP6)", "资本开支", "后道工厂", "24 CapEx统计后道工厂"],
];

const mappingRows = [
  ["事件概念", "对应OT", "映射理由"],
  ["NVIDIA Blackwell Architecture", "GPU架构世代", "Blackwell是GPU架构代际，承载双reticle-limited die、TSMC 4NP、芯粒互连等技术特征。"],
  ["NVIDIA B200 Tensor Core GPU", "GPU", "B200是Blackwell架构的数据中心GPU产品，适合作为产品层传导核心。"],
  ["NVIDIA GB200 Grace Blackwell Superchip", "训练加速器", "GB200是面向AI训练/推理的系统级加速产品，承载Grace CPU与两个Blackwell GPU。"],
  ["Dual Compute Die / Chiplet化", "GPU架构世代 + 先进封装技术", "当前无芯粒OT，作为架构属性与先进封装技术实例承载。"],
  ["HBM3E", "HBM + HBM世代", "HBM3E既是存储产品实例，也是技术世代，需要产品与世代分开建边。"],
  ["CoWoS-L", "封装方案", "CoWoS-L是TSMC具体封装方案，最适合落在封装方案OT。"],
  ["CoWoS/2.5D先进封装", "先进封装技术 + 封装技术世代", "技术能力与代际层分开表达，具体方案由CoWoS-L承载。"],
  ["台积电CoWoS产能扩张", "公司 + 后道工厂 + 封装测试服务 + 资本开支", "扩产不是OT，用公司、设施、服务与指标共同表达。"],
  ["ABF/封装基板需求", "ABF载板", "当前已有ABF载板作为封装基板叶子OT，足以承接基板需求。"],
  ["封装设备需求", "倒装键合机/混合键合机/晶圆减薄机", "选取与先进封装工艺最相关的设备叶子OT承接。"],
];

const otAnalysisRows = [
  ["OT", "层级", "参与原因", "角色", "连接对象"],
  ["数据中心计算应用", "市场/应用层", "AI训练推理需求是Blackwell需求起点", "需求侧触发", "GPU、训练加速器"],
  ["GPU", "产品层", "B200承接Blackwell架构、HBM3E与CoWoS-L封装", "主产品节点", "GPU架构世代、HBM、封装方案、封装测试服务、ABF载板"],
  ["训练加速器", "产品层", "GB200把Blackwell GPU组合成AI训练/推理系统", "系统级产品节点", "GPU架构世代、数据中心计算应用"],
  ["GPU架构世代", "技术层", "双计算芯粒与芯片互连是传导源头", "技术驱动", "GPU、训练加速器、先进封装技术"],
  ["先进封装技术", "技术层", "承接Chiplet/2.5D集成能力", "技术能力层", "GPU架构世代、封装技术世代、封装方案"],
  ["封装方案", "制造/技术层", "CoWoS-L承接多芯粒和HBM堆栈", "封装路线节点", "GPU、HBM、先进封装技术"],
  ["HBM", "产品层", "HBM3E是Blackwell高带宽存储投入", "关键上游投入", "GPU、HBM世代"],
  ["HBM世代", "技术层", "解释HBM3E代际升级", "存储技术代际", "HBM"],
  ["封装测试服务", "制造层", "CoWoS服务是产能瓶颈和扩产对象", "制造服务节点", "公司、后道工厂、GPU、设备、资本开支"],
  ["后道工厂", "制造层", "承载CoWoS扩产的物理设施", "产能载体", "公司、封装测试服务、资本开支"],
  ["ABF载板", "产业链/材料层", "大封装和高密度互连提升ABF需求", "封装基板投入", "GPU、公司"],
  ["倒装键合机", "设备层", "支撑多die贴装/倒装工艺", "设备投入", "封装测试服务、公司"],
  ["混合键合机", "设备层", "作为高密度互连方向的设备候选", "设备投入", "封装测试服务、公司"],
  ["晶圆减薄机", "设备层", "支撑先进封装前后道处理", "设备投入", "封装测试服务、公司"],
  ["资本开支", "市场/指标层", "表达CoWoS扩产的投资观察", "指标节点", "封装测试服务、后道工厂"],
];

const attrRows = [
  ["OT", "原始属性", "优化后属性", "修改原因"],
  ...Object.entries(otProperties).map(([ot, props]) => [
    ot,
    "见原JSON placeholder；本版保留OT名称但重设参与事件字段",
    props.map((p) => `${p[0]}(${p[1]})`).join("；"),
    "字段围绕技术路线传导设计，优先表达芯粒数量、HBM配置、封装方案、产能/设备/资本开支等驱动因素。",
  ]),
];

const transmissionRows = [
  ["step", "source", "link_type", "target", "是否断点", "说明"],
  ...linkRows.slice(1).map((r, idx) => [idx + 1, r[4], r[3], r[5], "否", r[8]]),
];

function propertyObjects(props) {
  return props.filter((p) => p[1] !== "instance_id" && p[1] !== "nameCn").map((p) => ({
    propertyCn: p[0],
    propertyEn: p[1],
    dataType: p[2],
    unit: p[3],
  }));
}

function sqlString(value) {
  if (value === null || value === undefined || value === "NULL") return "NULL";
  return `'${String(value).replace(/\\/g, "\\\\").replace(/'/g, "''")}'`;
}

function sqlIdent(value) {
  return `\`${String(value).replace(/`/g, "``")}\``;
}

function columnName(header) {
  return String(header)
    .replace(/[^A-Za-z0-9_]+/g, "_")
    .replace(/^_+|_+$/g, "")
    .toLowerCase()
    || "col";
}

function createTableSql(tableName, headers) {
  const cols = headers
    .filter((h) => !["instance_id", "nameCn", "nameEn", "objectTypeName", "description"].includes(h))
    .map((h) => `ADD COLUMN IF NOT EXISTS ${sqlIdent(columnName(h))} text NULL`);
  const alter = cols.length ? `ALTER TABLE ${sqlIdent(tableName)}\n  ${cols.join(",\n  ")};\n` : "";
  return `CREATE TABLE IF NOT EXISTS ${sqlIdent(tableName)} (
  \`id\` bigint NOT NULL AUTO_INCREMENT,
  \`name\` varchar(500) DEFAULT NULL,
  \`unique_id\` varchar(500) DEFAULT NULL,
  \`description\` text,
  \`created_at\` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  \`updated_at\` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (\`id\`),
  UNIQUE KEY \`uk_unique_id\` (\`unique_id\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Blackwell demo instance data';
${alter}`;
}

function insertObjectRowsSql(ot, tableName) {
  const headers = objectHeaders[ot];
  const rows = objectRows[ot];
  const extraHeaders = headers.filter((h) => !["instance_id", "nameCn", "nameEn", "objectTypeName", "description"].includes(h));
  const cols = ["unique_id", "name", "description", ...extraHeaders.map(columnName)];
  const values = rows.map((row) => {
    const byHeader = Object.fromEntries(headers.map((h, i) => [h, row[i]]));
    const description = byHeader.description ?? byHeader.transmission_role ?? byHeader.technology_significance ?? "";
    const vals = [
      byHeader.instance_id,
      byHeader.nameCn,
      description,
      ...extraHeaders.map((h) => byHeader[h]),
    ];
    return `(${vals.map(sqlString).join(", ")})`;
  });
  const updateCols = cols.filter((c) => c !== "unique_id").map((c) => `${sqlIdent(c)}=VALUES(${sqlIdent(c)})`);
  return `INSERT INTO ${sqlIdent(tableName)} (${cols.map(sqlIdent).join(", ")}) VALUES\n${values.join(",\n")}\nON DUPLICATE KEY UPDATE ${updateCols.join(", ")}, updated_at=CURRENT_TIMESTAMP;\n`;
}

function linkTypeSql() {
  return newLt.map(([id, name, source, predicate, target, _status, reason]) => {
    const src = cnToId[source];
    const tgt = cnToId[target];
    const category = predicate === "驱动" ? "技术驱动" : predicate === "适配" ? "能力适配" : "技术关联";
    return `INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES (${sqlString(id)}, ${sqlString(name)}, ${sqlString(src)}, ${sqlString(tgt)}, 'M:N', ${sqlString(category)}, ${sqlString(reason)}, NULL, NULL, NULL, 'active', 'project_1780997325389', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;\n`;
  }).join("\n");
}

function linkInstanceSql() {
  return linkRows.slice(1).map((r) => {
    const [lt, src, tgt] = r;
    return `INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT ${sqlString(lt)}, ${sqlString(src)}, ${sqlString(tgt)}
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id=${sqlString(lt)} AND source_instance_id=${sqlString(src)} AND target_instance_id=${sqlString(tgt)}
);\n`;
  }).join("\n");
}

const cnToId = {
  "公司": "company",
  "GPU": "graphics_processing_unit",
  "训练加速器": "training_accelerator",
  "GPU架构世代": "gpu_architecture_generation",
  "HBM": "high_bandwidth_memory",
  "HBM世代": "hbm_generation",
  "封装方案": "packaging_solution",
  "先进封装技术": "advanced_packaging_technology",
  "封装技术世代": "packaging_technology_generation",
  "封装测试服务": "assembly_test_service",
  "后道工厂": "backend_facility",
  "ABF载板": "abf_substrate",
  "倒装键合机": "flip_chip_bonding_equipment",
  "混合键合机": "hybrid_bonding_equipment",
  "晶圆减薄机": "wafer_thinning_equipment",
  "资本开支": "capital_expenditure",
  "数据中心计算应用": "ai_server_application",
};

function buildSql() {
  let sql = `-- Blackwell technology transmission demo v1 import\n-- Generated by scripts/generated/build_blackwell_demo_v1.mjs\nSET NAMES utf8mb4;\nSET FOREIGN_KEY_CHECKS=0;\n\n`;
  for (const ot of Object.keys(objectRows)) {
    const tableName = cnToId[ot];
    sql += `-- Object instances: ${ot}\n`;
    sql += createTableSql(tableName, objectHeaders[ot]);
    sql += insertObjectRowsSql(ot, tableName);
    sql += "\n";
  }
  sql += `-- Link type additions required by this demo\n${linkTypeSql()}\n`;
  sql += `-- Link instances for link_instance_data\n${linkInstanceSql()}\n`;
  sql += `-- User-requested visualization cleanup: backing_dataset can interfere with visualization.\nUPDATE object_types SET backing_dataset='', updated_at=CURRENT_TIMESTAMP;\n\n`;
  sql += `SET FOREIGN_KEY_CHECKS=1;\n`;
  return sql;
}

function addNewLinkTypes(ontology) {
  const existingNames = new Set(ontology.linkType.map((lt) => lt.name));
  for (const [id, name, source, predicate, target, _status, reason] of newLt) {
    if (existingNames.has(name)) continue;
    ontology.linkType.push({
      name,
      proposedId: id,
      sourceObjectType: source,
      targetObjectType: target,
      linkTypeCategory: predicate === "驱动" ? "技术驱动" : predicate === "适配" ? "能力适配" : predicate === "下游应用" ? "下游应用" : "技术关联",
      radix: "多对多（M:N）",
      description: reason,
      source: "Blackwell technology transmission demo v1",
      predicate,
    });
  }
}

function updateOntologyProperties(ontology) {
  const propByOt = new Map(Object.entries(otProperties));
  for (const ot of ontology.objectType) {
    const props = propByOt.get(ot.nameCn);
    if (!props) continue;
    ot.properties = propertyObjects(props);
    ot.demoPropertyOptimization = {
      scenario: "Blackwell-CoWoS-L technology transmission demo v1",
      note: "仅为Demo数据源优化参与OT属性；未新增、删除或重命名Object Type。",
    };
  }
}

function matrixForObjectSheet(ot) {
  return [objectHeaders[ot], ...objectRows[ot]];
}

function setBlock(sheet, rows) {
  const rowCount = rows.length;
  const colCount = Math.max(...rows.map((r) => r.length));
  const normalized = rows.map((r) => {
    const copy = [...r];
    while (copy.length < colCount) copy.push(null);
    return copy;
  });
  const range = sheet.getRangeByIndexes(0, 0, rowCount, colCount);
  range.values = normalized;
  return { range, rowCount, colCount };
}

function styleSheet(sheet, rowCount, colCount) {
  sheet.showGridLines = false;
  const header = sheet.getRangeByIndexes(0, 0, 1, colCount);
  header.format = {
    fill: "#1F4E79",
    font: { bold: true, color: "#FFFFFF" },
  };
  header.format.wrapText = true;
  const used = sheet.getRangeByIndexes(0, 0, rowCount, colCount);
  used.format.borders = { preset: "inside", style: "thin", color: "#D9E2EC" };
  used.format.wrapText = true;
  used.format.autofitColumns();
  used.format.autofitRows();
  sheet.freezePanes.freezeRows(1);
}

async function buildOntology() {
  const ontology = JSON.parse(await fs.readFile(sourceOntologyPath, "utf8"));
  updateOntologyProperties(ontology);
  addNewLinkTypes(ontology);
  await fs.mkdir(outputDir, { recursive: true });
  await fs.writeFile(outputOntologyPath, JSON.stringify(ontology, null, 2), "utf8");
  await fs.writeFile(outputSqlPath, buildSql(), "utf8");
}

async function buildWorkbook() {
  const workbook = Workbook.create();

  const sheetData = [
    ["Mapping", mappingRows],
    ["OT_Analysis", otAnalysisRows],
    ["Attribute_Optimization", attrRows],
    ["Link_Type_Changes", linkTypeChanges],
    ["Link_Instance_Data", linkRows],
    ["Transmission_Check", transmissionRows],
    ...Object.keys(objectRows).map((ot) => [ot, matrixForObjectSheet(ot)]),
  ];

  for (const [name, rows] of sheetData) {
    const sheet = workbook.worksheets.add(name);
    const { rowCount, colCount } = setBlock(sheet, rows);
    styleSheet(sheet, rowCount, colCount);
  }

  const sqlSheet = workbook.worksheets.add("SQL_Insert_Link_Instance");
  const sqlRows = [
    ["sql"],
    ["INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id) VALUES"],
    ...linkRows.slice(1).map((r, idx, arr) => [
      `('${r[0]}','${r[1]}','${r[2]}')${idx === arr.length - 1 ? ";" : ","}`,
    ]),
  ];
  const sqlBlock = setBlock(sqlSheet, sqlRows);
  styleSheet(sqlSheet, sqlBlock.rowCount, sqlBlock.colCount);

  await fs.mkdir(outputDir, { recursive: true });

  for (const [name] of sheetData) {
    const preview = await workbook.render({ sheetName: name, autoCrop: "all", scale: 1, format: "png" });
    await fs.writeFile(path.join(outputDir, `${name}.png`), new Uint8Array(await preview.arrayBuffer()));
  }
  {
    const preview = await workbook.render({ sheetName: "SQL_Insert_Link_Instance", autoCrop: "all", scale: 1, format: "png" });
    await fs.writeFile(path.join(outputDir, "SQL_Insert_Link_Instance.png"), new Uint8Array(await preview.arrayBuffer()));
  }

  const errors = await workbook.inspect({
    kind: "match",
    searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
    options: { useRegex: true, maxResults: 300 },
    summary: "formula error scan",
  });
  console.log(errors.ndjson);

  const inspect = await workbook.inspect({
    kind: "table",
    sheetId: "Link_Instance_Data",
    range: "A1:I30",
    include: "values",
    tableMaxRows: 30,
    tableMaxCols: 9,
  });
  console.log(inspect.ndjson);

  const xlsx = await SpreadsheetFile.exportXlsx(workbook);
  await xlsx.save(outputWorkbookPath);
}

await buildOntology();
await buildWorkbook();

console.log(`Wrote ${outputOntologyPath}`);
console.log(`Wrote ${outputWorkbookPath}`);
console.log(`Wrote ${outputSqlPath}`);
