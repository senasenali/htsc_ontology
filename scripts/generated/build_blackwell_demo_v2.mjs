import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { SpreadsheetFile, Workbook } from '@oai/artifact-tool';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, '..', '..');
const outDir = path.join(repoRoot, 'outputs', 'blackwell_demo_v2');
const projectId = 'project_1780997325389';

const sources = {
  nvidiaBlackwell: 'https://www.nvidia.com/en-us/data-center/technologies/blackwell-architecture/',
  nvidiaBlackwellNewsroom: 'https://nvidianews.nvidia.com/news/nvidia-blackwell-platform-arrives-to-power-a-new-era-of-computing',
  nvidiaGb200: 'https://www.nvidia.com/en-us/data-center/gb200-nvl72/',
  tsmcCowos: 'https://www.tsmc.com/english/dedicatedFoundry/technology/logic/l_3dfabric',
  hbm3e: 'https://www.skhynix.com/product/hbm3e.go',
  micronHbm3e: 'https://www.micron.com/products/memory/hbm/hbm3e',
  semiCoWoS: 'https://www.semi.org/en/blogs/technology-trends/tsmc-cowos-advanced-packaging',
  semiwiki: 'https://semiwiki.com/semiconductor-services/semiconductor-packaging/335318-understanding-tsmcs-cowos-l-packaging/',
};

const ot = {
  company: ['company', '公司'],
  gpu: ['graphics_processing_unit', 'GPU'],
  training: ['training_accelerator', '训练加速器'],
  cpu: ['central_processing_unit', 'CPU'],
  interconnect: ['interconnect_technology', '互联技术'],
  arch: ['gpu_architecture_generation', 'GPU架构世代'],
  process: ['process_platform', '制程工艺'],
  processNode: ['process_node_generation', '制程节点'],
  hbm: ['high_bandwidth_memory', 'HBM'],
  hbmGen: ['hbm_generation', 'HBM世代'],
  pkg: ['packaging_solution', '封装方案'],
  advPkg: ['advanced_packaging_technology', '先进封装技术'],
  pkgGen: ['packaging_technology_generation', '封装技术世代'],
  pkgSvc: ['assembly_test_service', '封装测试服务'],
  backend: ['backend_facility', '后道工厂'],
  abf: ['abf_substrate', 'ABF载板'],
  flip: ['flip_chip_bonding_equipment', '倒装键合机'],
  hybrid: ['hybrid_bonding_equipment', '混合键合机'],
  thin: ['wafer_thinning_equipment', '晶圆减薄机'],
  capex: ['capital_expenditure', '资本开支'],
  app: ['ai_server_application', '数据中心计算应用'],
};

const propertyPlan = {
  公司: ['company_category', 'country_region', 'source_url'],
  GPU: ['compute_die_count', 'transistor_count_billion', 'die_to_die_bandwidth_tbps', 'source_url'],
  训练加速器: ['gpu_count', 'cpu_count', 'memory_capacity_gb', 'memory_bandwidth_tbps', 'interconnect_bandwidth_tbps', 'source_url'],
  CPU: ['processor_family', 'processor_role', 'source_url'],
  互联技术: ['technology_family', 'technology_role', 'source_url'],
  GPU架构世代: ['release_date', 'source_url'],
  制程工艺: ['source_url'],
  制程节点: ['generation', 'source_url'],
  HBM: ['stack_height', 'capacity_per_stack_gb', 'pin_speed_gbps', 'bandwidth_per_stack_tbps', 'io_width_bits', 'source_url'],
  HBM世代: ['generation_name', 'typical_stack_height', 'typical_capacity_per_stack_gb', 'typical_bandwidth_per_stack_tbps', 'technology_significance', 'source_url'],
  封装方案: ['interposer_type', 'local_silicon_interconnect', 'hbm_support', 'source_url'],
  先进封装技术: ['technology_family', 'integration_mode', 'source_url'],
  封装技术世代: ['source_url'],
  封装测试服务: ['service_type', 'capacity_status', 'source_url'],
  后道工厂: ['country_region', 'city_or_site', 'facility_type', 'status', 'source_url'],
  ABF载板: ['dielectric_material', 'demand_driver', 'source_url'],
  倒装键合机: ['equipment_category', 'supported_process', 'source_url'],
  混合键合机: ['equipment_category', 'supported_process', 'source_url'],
  晶圆减薄机: ['equipment_category', 'supported_process', 'source_url'],
  资本开支: ['capex_amount', 'currency', 'period', 'capex_category', 'region', 'capacity_or_technology_purpose', 'source_url'],
  数据中心计算应用: ['application_scenario', 'compute_requirement', 'source_url'],
};

const objectRows = [
  { ot: '公司', id: 'obj_company_nvidia', name: '英伟达', nameEn: 'NVIDIA', description: 'Blackwell GPU and GB200/NVL72 supplier.', company_category: 'Fabless GPU/AI accelerator vendor', country_region: 'United States', source_url: sources.nvidiaBlackwell },
  { ot: '公司', id: 'obj_company_tsmc', name: '台积电', nameEn: 'TSMC', description: 'Foundry and CoWoS advanced packaging provider for leading AI chips.', company_category: 'Foundry and advanced packaging provider', country_region: 'Taiwan, China', source_url: sources.tsmcCowos },
  { ot: '公司', id: 'obj_company_skhynix', name: 'SK海力士', nameEn: 'SK hynix', description: 'HBM3E supplier.', company_category: 'Memory supplier', country_region: 'Korea', source_url: sources.hbm3e },
  { ot: '公司', id: 'obj_company_micron', name: '美光科技', nameEn: 'Micron', description: 'HBM3E supplier.', company_category: 'Memory supplier', country_region: 'United States', source_url: sources.micronHbm3e },
  { ot: '公司', id: 'obj_company_samsung_electronics', name: '三星电子', nameEn: 'Samsung Electronics', description: 'HBM supplier candidate.', company_category: 'Memory supplier', country_region: 'Korea', source_url: sources.hbm3e },
  { ot: '公司', id: 'obj_company_ibiden', name: '揖斐电', nameEn: 'Ibiden', description: 'ABF substrate supplier.', company_category: 'IC substrate supplier', country_region: 'Japan', source_url: sources.semiwiki },
  { ot: '公司', id: 'obj_company_unimicron', name: '欣兴电子', nameEn: 'Unimicron', description: 'ABF substrate supplier.', company_category: 'IC substrate supplier', country_region: 'Taiwan, China', source_url: sources.semiwiki },
  { ot: '公司', id: 'obj_company_shinko', name: '新光电气', nameEn: 'Shinko Electric', description: 'ABF substrate supplier.', company_category: 'IC substrate supplier', country_region: 'Japan', source_url: sources.semiwiki },
  { ot: '公司', id: 'obj_company_besi', name: 'BESI', nameEn: 'BESI', description: 'Advanced bonding equipment supplier.', company_category: 'Semiconductor equipment supplier', country_region: 'Netherlands', source_url: sources.semiwiki },
  { ot: '公司', id: 'obj_company_asmpt', name: 'ASMPT', nameEn: 'ASMPT', description: 'Advanced bonding equipment supplier.', company_category: 'Semiconductor equipment supplier', country_region: 'Hong Kong, China', source_url: sources.semiwiki },
  { ot: '公司', id: 'obj_company_kulicke_soffa', name: 'K&S', nameEn: 'Kulicke & Soffa', description: 'Bonding equipment supplier.', company_category: 'Semiconductor equipment supplier', country_region: 'United States', source_url: sources.semiwiki },
  { ot: '公司', id: 'obj_company_disco', name: 'DISCO', nameEn: 'DISCO', description: 'Wafer thinning and dicing equipment supplier.', company_category: 'Semiconductor equipment supplier', country_region: 'Japan', source_url: sources.semiwiki },

  { ot: 'GPU', id: 'obj_gpu_nvidia_b200', name: 'NVIDIA B200 Tensor Core GPU', nameEn: 'NVIDIA B200 Tensor Core GPU', description: 'Blackwell-generation Tensor Core GPU used in GB200 Grace Blackwell Superchip and HGX B200 platforms.', compute_die_count: 2, transistor_count_billion: 208, die_to_die_bandwidth_tbps: 10, source_url: sources.nvidiaBlackwellNewsroom },
  { ot: '训练加速器', id: 'obj_training_accelerator_gb200', name: 'NVIDIA GB200 Grace Blackwell Superchip', nameEn: 'NVIDIA GB200 Grace Blackwell Superchip', description: 'Training accelerator module combining one Grace CPU and two Blackwell GPUs.', gpu_count: 2, cpu_count: 1, memory_capacity_gb: 372, memory_bandwidth_tbps: 16, interconnect_bandwidth_tbps: 3.6, source_url: sources.nvidiaGb200 },
  { ot: 'CPU', id: 'obj_cpu_nvidia_grace', name: 'NVIDIA Grace CPU', nameEn: 'NVIDIA Grace CPU', description: 'CPU used with Blackwell GPUs in the GB200 Grace Blackwell Superchip.', processor_family: 'NVIDIA Grace', processor_role: 'host CPU for Grace Blackwell Superchip', source_url: sources.nvidiaGb200 },
  { ot: '互联技术', id: 'obj_interconnect_nvlink', name: 'NVIDIA NVLink', nameEn: 'NVIDIA NVLink', description: 'High-speed interconnect technology used by NVIDIA AI accelerator platforms.', technology_family: 'NVLink', technology_role: 'GPU and system interconnect', source_url: sources.nvidiaGb200 },
  { ot: '互联技术', id: 'obj_interconnect_nvlink_c2c', name: 'NVIDIA NVLink-C2C', nameEn: 'NVIDIA NVLink-C2C', description: 'Chip-to-chip interconnect technology used between Grace CPU and Blackwell GPUs.', technology_family: 'NVLink-C2C', technology_role: 'CPU-GPU chip-to-chip interconnect', source_url: sources.nvidiaGb200 },
  { ot: 'GPU架构世代', id: 'obj_gpu_arch_blackwell', name: 'NVIDIA Blackwell架构', nameEn: 'NVIDIA Blackwell Architecture', description: 'GPU architecture generation centered on AI training and inference scaling.', release_date: '2024-03-18', source_url: sources.nvidiaBlackwell },
  { ot: '制程工艺', id: 'obj_process_platform_tsmc_4np', name: 'TSMC 4NP', nameEn: 'TSMC 4NP', description: 'Custom-built TSMC process disclosed by NVIDIA for Blackwell-architecture GPUs; scope is expressed through GPU and architecture link instances.', source_url: sources.nvidiaBlackwellNewsroom },
  { ot: '制程节点', id: 'obj_process_node_4nm_class', name: '4nm-class制程节点', nameEn: '4nm-class Process Node', description: 'Industry node class used to group TSMC 4nm-class process variants; not a literal physical feature size.', generation: '4nm', source_url: sources.nvidiaBlackwellNewsroom },

  { ot: 'HBM', id: 'obj_hbm_skhynix_hbm3e', name: 'SK海力士HBM3E 12Hi', nameEn: 'SK hynix HBM3E 12Hi', description: '12-high HBM3E product relevant to AI accelerator memory capacity growth.', stack_height: '12Hi', capacity_per_stack_gb: 36, pin_speed_gbps: 9.2, bandwidth_per_stack_tbps: 1.18, io_width_bits: 1024, source_url: sources.hbm3e },
  { ot: 'HBM', id: 'obj_hbm_micron_hbm3e', name: '美光HBM3E 24GB', nameEn: 'Micron HBM3E 24GB', description: '24GB HBM3E product relevant to AI accelerator memory bandwidth.', stack_height: '8Hi', capacity_per_stack_gb: 24, pin_speed_gbps: 9.2, bandwidth_per_stack_tbps: 1.2, io_width_bits: 1024, source_url: sources.micronHbm3e },
  { ot: 'HBM', id: 'obj_hbm_samsung_hbm3e', name: '三星HBM3E', nameEn: 'Samsung HBM3E', description: 'Samsung HBM3E product family.', stack_height: '8Hi/12Hi', capacity_per_stack_gb: '24-36', pin_speed_gbps: '9.2+', bandwidth_per_stack_tbps: '1.2+', io_width_bits: 1024, source_url: sources.hbm3e },
  { ot: 'HBM世代', id: 'obj_hbm_generation_hbm3e', name: 'HBM3E世代', nameEn: 'HBM3E Generation', description: 'Enhanced HBM3 generation used in advanced AI accelerator products.', generation_name: 'HBM3E', typical_stack_height: '8Hi/12Hi', typical_capacity_per_stack_gb: '24-36', typical_bandwidth_per_stack_tbps: '1.2+', technology_significance: 'raises memory bandwidth and capacity for AI accelerators', source_url: sources.hbm3e },

  { ot: '封装技术世代', id: 'obj_packaging_generation_2_5d', name: '2.5D先进封装', nameEn: '2.5D Advanced Packaging', description: 'Advanced packaging class represented by interposer, RDL or substrate-based multi-die integration.', source_url: sources.tsmcCowos },
  { ot: '先进封装技术', id: 'obj_advanced_packaging_cowos', name: 'CoWoS', nameEn: 'CoWoS', description: 'Chip-on-wafer-on-substrate advanced packaging technology platform for high-end AI accelerators.', technology_family: 'CoWoS', integration_mode: '2.5D multi-die and HBM integration', source_url: sources.tsmcCowos },
  { ot: '封装方案', id: 'obj_packaging_solution_tsmc_cowos_l', name: 'TSMC CoWoS-L', nameEn: 'TSMC CoWoS-L', description: 'Concrete CoWoS solution variant using local silicon interconnect bridges for large multi-die AI packages.', interposer_type: 'RDL interposer plus local silicon interconnect', local_silicon_interconnect: 'LSI bridge', hbm_support: 'supports multiple HBM stacks', source_url: sources.tsmcCowos },
  { ot: '封装测试服务', id: 'obj_service_tsmc_cowos', name: '台积电CoWoS封装测试服务', nameEn: 'TSMC CoWoS Packaging and Testing Service', description: 'Commercial packaging and testing service capacity required to manufacture CoWoS-based AI accelerator products.', service_type: 'advanced packaging and test', capacity_status: 'tight capacity / expansion demand', source_url: sources.semiCoWoS },
  { ot: '后道工厂', id: 'obj_facility_tsmc_ap6', name: '台积电CoWoS后道产能', nameEn: 'TSMC CoWoS Backend Capacity Taiwan', description: 'TSMC backend capacity associated with CoWoS advanced packaging expansion.', country_region: 'Taiwan, China', city_or_site: 'Taiwan sites', facility_type: 'advanced packaging backend facility', status: 'capacity expansion', source_url: sources.semiCoWoS },

  { ot: 'ABF载板', id: 'obj_abf_substrate', name: 'AI加速器ABF载板', nameEn: 'ABF Substrate for AI Accelerators', description: 'Large-size ABF substrate used by high-end AI accelerator packages.', dielectric_material: 'Ajinomoto build-up film', demand_driver: 'larger package size and advanced packaging demand', source_url: sources.semiwiki },
  { ot: '倒装键合机', id: 'obj_equipment_flip_chip_bonder', name: 'AI封装倒装键合机', nameEn: 'Flip-chip Bonder for AI Packaging', description: 'Flip-chip bonding equipment used in advanced packaging assembly.', equipment_category: 'flip-chip bonding', supported_process: 'die attach / chip placement for advanced package', source_url: sources.semiwiki },
  { ot: '混合键合机', id: 'obj_equipment_hybrid_bonder', name: '先进封装混合键合机', nameEn: 'Hybrid Bonder for Advanced Packaging', description: 'Hybrid bonding equipment relevant to advanced interconnect density.', equipment_category: 'hybrid bonding', supported_process: 'wafer-to-wafer / die-to-wafer bonding', source_url: sources.semiwiki },
  { ot: '晶圆减薄机', id: 'obj_equipment_wafer_thinning', name: 'HBM/先进封装晶圆减薄机', nameEn: 'Wafer Thinning Equipment for HBM and Advanced Packaging', description: 'Wafer thinning equipment used in HBM and advanced packaging process flows.', equipment_category: 'wafer thinning', supported_process: 'backgrind / thinning for stacked memory and packaging', source_url: sources.semiwiki },

  { ot: '资本开支', id: 'obj_metric_tsmc_adv_packaging_capex', name: '台积电先进封装扩产资本开支', nameEn: 'TSMC Advanced Packaging Expansion Capex', description: 'Capital expenditure associated with advanced packaging and CoWoS capacity expansion.', capex_amount: 'not specified', currency: 'USD/TWD', period: '2024-2026', capex_category: 'advanced packaging capacity expansion', region: 'Taiwan, China', capacity_or_technology_purpose: 'CoWoS and AI accelerator package capacity', source_url: sources.semiCoWoS },
  { ot: '数据中心计算应用', id: 'obj_app_ai_server_training', name: '数据中心AI训练与推理', nameEn: 'Data Center AI Training and Inference', description: 'Demand scenario driving Blackwell GPU, HBM and advanced packaging requirements.', application_scenario: 'large-scale AI training and inference', compute_requirement: 'high FLOPS, high memory bandwidth, high cluster interconnect bandwidth', source_url: sources.nvidiaGb200 },
];

const linkTypeRows = [
  ['lt_graphics_processing_unit_adopts_gpu_architecture_generation', 'GPU采用GPU架构世代', 'GPU', 'GPU架构世代', '采用', '已有/确保存在'],
  ['lt_training_accelerator_adopts_gpu_architecture_generation', '训练加速器采用GPU架构世代', '训练加速器', 'GPU架构世代', '采用', '已有/确保存在'],
  ['lt_training_accelerator_contains_central_processing_unit', '训练加速器搭载CPU', '训练加速器', 'CPU', '搭载', '新增'],
  ['lt_training_accelerator_adopts_hbm_generation', '训练加速器采用HBM世代', '训练加速器', 'HBM世代', '采用', '新增'],
  ['lt_training_accelerator_adopts_interconnect_technology', '训练加速器采用互联技术', '训练加速器', '互联技术', '采用', '新增'],
  ['lt_graphics_processing_unit_relation_ai_server_application', 'GPU下游应用数据中心计算应用', 'GPU', '数据中心计算应用', '下游应用', '已有/确保存在'],
  ['lt_training_accelerator_relation_ai_server_application', '训练加速器下游应用数据中心计算应用', '训练加速器', '数据中心计算应用', '下游应用', '已有/确保存在'],
  ['lt_graphics_processing_unit_adopts_process_platform', 'GPU采用制程工艺', 'GPU', '制程工艺', '采用', '新增'],
  ['lt_gpu_architecture_generation_corresponds_to_process_platform', 'GPU架构世代对应制程工艺', 'GPU架构世代', '制程工艺', '对应', '新增'],
  ['lt_process_platform_relation_process_node_generation', '制程工艺对应制程节点', '制程工艺', '制程节点', '对应', '已有/改名复用'],
  ['lt_company_produces_for_process_platform', '公司生产供给制程工艺', '公司', '制程工艺', '生产供给', '新增'],
  ['lt_gpu_architecture_generation_drives_advanced_packaging_technology', 'GPU架构世代驱动先进封装技术', 'GPU架构世代', '先进封装技术', '驱动', '新增'],
  ['lt_packaging_technology_generation_corresponds_to_advanced_packaging_technology', '封装技术世代对应先进封装技术', '封装技术世代', '先进封装技术', '对应', '已有/确保存在'],
  ['lt_advanced_packaging_technology_corresponds_to_packaging_solution', '先进封装技术对应封装方案', '先进封装技术', '封装方案', '对应', '新增'],
  ['lt_graphics_processing_unit_adopts_packaging_solution', 'GPU采用封装方案', 'GPU', '封装方案', '采用', '新增'],
  ['lt_high_bandwidth_memory_adopts_hbm_generation', 'HBM采用HBM世代', 'HBM', 'HBM世代', '采用', '新增'],
  ['lt_company_produces_for_high_bandwidth_memory', '公司生产供给HBM', '公司', 'HBM', '生产供给', '新增/确保存在'],
  ['lt_company_produces_for_packaging_solution', '公司生产供给封装方案', '公司', '封装方案', '生产供给', '新增'],
  ['lt_company_produces_for_assembly_test_service', '公司生产供给封装测试服务', '公司', '封装测试服务', '生产供给', '已有/确保存在'],
  ['lt_assembly_test_service_supports_capability_of_graphics_processing_unit', '封装测试服务能力支撑GPU', '封装测试服务', 'GPU', '能力支撑', '已有/确保存在'],
  ['lt_backend_facility_belongs_to_company', '后道工厂所属公司', '后道工厂', '公司', '所属', '已有/确保存在'],
  ['lt_backend_facility_produces_for_assembly_test_service', '后道工厂生产供给封装测试服务', '后道工厂', '封装测试服务', '生产供给', '已有/确保存在'],
  ['lt_abf_substrate_supplies_to_graphics_processing_unit', 'ABF载板供给于GPU', 'ABF载板', 'GPU', '供给于', '已有/确保存在'],
  ['lt_company_produces_for_abf_substrate', '公司生产供给ABF载板', '公司', 'ABF载板', '生产供给', '已有/确保存在'],
  ['lt_company_produces_for_flip_chip_bonding_equipment', '公司生产供给倒装键合机', '公司', '倒装键合机', '生产供给', '新增/确保存在'],
  ['lt_company_produces_for_hybrid_bonding_equipment', '公司生产供给混合键合机', '公司', '混合键合机', '生产供给', '新增/确保存在'],
  ['lt_company_produces_for_wafer_thinning_equipment', '公司生产供给晶圆减薄机', '公司', '晶圆减薄机', '生产供给', '新增/确保存在'],
  ['lt_flip_chip_bonding_equipment_supports_capability_of_assembly_test_service', '倒装键合机能力支撑封装测试服务', '倒装键合机', '封装测试服务', '能力支撑', '已有/确保存在'],
  ['lt_hybrid_bonding_equipment_supports_capability_of_assembly_test_service', '混合键合机能力支撑封装测试服务', '混合键合机', '封装测试服务', '能力支撑', '已有/确保存在'],
  ['lt_wafer_thinning_equipment_supports_capability_of_assembly_test_service', '晶圆减薄机能力支撑封装测试服务', '晶圆减薄机', '封装测试服务', '能力支撑', '已有/确保存在'],
  ['lt_capital_expenditure_measures_for_assembly_test_service', '资本开支统计对象封装测试服务', '资本开支', '封装测试服务', '统计对象', '已有/确保存在'],
  ['lt_capital_expenditure_measures_for_backend_facility', '资本开支统计对象后道工厂', '资本开支', '后道工厂', '统计对象', '已有/确保存在'],
];

const linkRows = [
  ['link_b200_to_blackwell_arch', 'lt_graphics_processing_unit_adopts_gpu_architecture_generation', 'obj_gpu_nvidia_b200', 'obj_gpu_arch_blackwell', 'NVIDIA B200 Tensor Core GPU belongs to the Blackwell GPU architecture generation.'],
  ['link_gb200_to_blackwell_arch', 'lt_training_accelerator_adopts_gpu_architecture_generation', 'obj_training_accelerator_gb200', 'obj_gpu_arch_blackwell', 'GB200 uses Blackwell GPUs.'],
  ['link_gb200_to_grace_cpu', 'lt_training_accelerator_contains_central_processing_unit', 'obj_training_accelerator_gb200', 'obj_cpu_nvidia_grace', 'GB200 Grace Blackwell Superchip includes one NVIDIA Grace CPU; quantity is stored as cpu_count on the accelerator instance.'],
  ['link_gb200_to_hbm3e_generation', 'lt_training_accelerator_adopts_hbm_generation', 'obj_training_accelerator_gb200', 'obj_hbm_generation_hbm3e', 'GB200 uses HBM3E memory generation; aggregate capacity and bandwidth are accelerator-level numeric properties.'],
  ['link_gb200_to_nvlink', 'lt_training_accelerator_adopts_interconnect_technology', 'obj_training_accelerator_gb200', 'obj_interconnect_nvlink', 'GB200 uses NVLink interconnect technology.'],
  ['link_gb200_to_nvlink_c2c', 'lt_training_accelerator_adopts_interconnect_technology', 'obj_training_accelerator_gb200', 'obj_interconnect_nvlink_c2c', 'GB200 uses NVLink-C2C chip-to-chip interconnect technology.'],
  ['link_b200_to_ai_app', 'lt_graphics_processing_unit_relation_ai_server_application', 'obj_gpu_nvidia_b200', 'obj_app_ai_server_training', 'B200 Tensor Core GPU targets data-center AI training and inference.'],
  ['link_gb200_to_ai_app', 'lt_training_accelerator_relation_ai_server_application', 'obj_training_accelerator_gb200', 'obj_app_ai_server_training', 'GB200 targets data-center AI training and inference.'],
  ['link_b200_to_tsmc_4np', 'lt_graphics_processing_unit_adopts_process_platform', 'obj_gpu_nvidia_b200', 'obj_process_platform_tsmc_4np', 'B200 is modeled as adopting the TSMC 4NP process technology disclosed for Blackwell GPUs.'],
  ['link_blackwell_to_tsmc_4np', 'lt_gpu_architecture_generation_corresponds_to_process_platform', 'obj_gpu_arch_blackwell', 'obj_process_platform_tsmc_4np', 'Blackwell architecture corresponds to the TSMC 4NP process technology disclosed by NVIDIA.'],
  ['link_tsmc_4np_to_4nm_class', 'lt_process_platform_relation_process_node_generation', 'obj_process_platform_tsmc_4np', 'obj_process_node_4nm_class', 'TSMC 4NP is grouped under the 4nm-class process node layer for demo modeling.'],
  ['link_tsmc_to_4np', 'lt_company_produces_for_process_platform', 'obj_company_tsmc', 'obj_process_platform_tsmc_4np', 'TSMC provides the process technology used for Blackwell GPUs.'],
  ['link_blackwell_to_cowos', 'lt_gpu_architecture_generation_drives_advanced_packaging_technology', 'obj_gpu_arch_blackwell', 'obj_advanced_packaging_cowos', 'Dual-die Blackwell raises demand for CoWoS advanced packaging technology.'],
  ['link_2_5d_to_cowos', 'lt_packaging_technology_generation_corresponds_to_advanced_packaging_technology', 'obj_packaging_generation_2_5d', 'obj_advanced_packaging_cowos', 'CoWoS is represented under the 2.5D advanced packaging class.'],
  ['link_cowos_to_cowos_l', 'lt_advanced_packaging_technology_corresponds_to_packaging_solution', 'obj_advanced_packaging_cowos', 'obj_packaging_solution_tsmc_cowos_l', 'CoWoS-L is the concrete packaging solution instance.'],
  ['link_b200_to_cowos_l', 'lt_graphics_processing_unit_adopts_packaging_solution', 'obj_gpu_nvidia_b200', 'obj_packaging_solution_tsmc_cowos_l', 'B200 packaging choice is modeled through a packaging-solution link, not as a GPU text attribute.'],
  ['link_skhynix_hbm3e_to_generation', 'lt_high_bandwidth_memory_adopts_hbm_generation', 'obj_hbm_skhynix_hbm3e', 'obj_hbm_generation_hbm3e', 'Supplier product is linked to HBM3E generation.'],
  ['link_micron_hbm3e_to_generation', 'lt_high_bandwidth_memory_adopts_hbm_generation', 'obj_hbm_micron_hbm3e', 'obj_hbm_generation_hbm3e', 'Supplier product is linked to HBM3E generation.'],
  ['link_samsung_hbm3e_to_generation', 'lt_high_bandwidth_memory_adopts_hbm_generation', 'obj_hbm_samsung_hbm3e', 'obj_hbm_generation_hbm3e', 'Supplier product is linked to HBM3E generation.'],
  ['link_skhynix_to_hbm', 'lt_company_produces_for_high_bandwidth_memory', 'obj_company_skhynix', 'obj_hbm_skhynix_hbm3e', 'Supplier relationship is modeled through link instance.'],
  ['link_micron_to_hbm', 'lt_company_produces_for_high_bandwidth_memory', 'obj_company_micron', 'obj_hbm_micron_hbm3e', 'Supplier relationship is modeled through link instance.'],
  ['link_samsung_to_hbm', 'lt_company_produces_for_high_bandwidth_memory', 'obj_company_samsung_electronics', 'obj_hbm_samsung_hbm3e', 'Supplier relationship is modeled through link instance.'],
  ['link_tsmc_to_cowos_l', 'lt_company_produces_for_packaging_solution', 'obj_company_tsmc', 'obj_packaging_solution_tsmc_cowos_l', 'Provider relationship is modeled through link instance.'],
  ['link_tsmc_to_cowos_service', 'lt_company_produces_for_assembly_test_service', 'obj_company_tsmc', 'obj_service_tsmc_cowos', 'TSMC provides CoWoS packaging and testing service.'],
  ['link_cowos_service_to_b200', 'lt_assembly_test_service_supports_capability_of_graphics_processing_unit', 'obj_service_tsmc_cowos', 'obj_gpu_nvidia_b200', 'Packaging service supports B200 production.'],
  ['link_cowos_facility_to_tsmc', 'lt_backend_facility_belongs_to_company', 'obj_facility_tsmc_ap6', 'obj_company_tsmc', 'Facility owner relationship is modeled through link instance.'],
  ['link_cowos_facility_to_service', 'lt_backend_facility_produces_for_assembly_test_service', 'obj_facility_tsmc_ap6', 'obj_service_tsmc_cowos', 'Backend facility produces CoWoS packaging service capacity.'],
  ['link_abf_to_b200', 'lt_abf_substrate_supplies_to_graphics_processing_unit', 'obj_abf_substrate', 'obj_gpu_nvidia_b200', 'Large ABF substrates supply high-end AI accelerator packages.'],
  ['link_ibiden_to_abf', 'lt_company_produces_for_abf_substrate', 'obj_company_ibiden', 'obj_abf_substrate', 'ABF supplier relationship.'],
  ['link_unimicron_to_abf', 'lt_company_produces_for_abf_substrate', 'obj_company_unimicron', 'obj_abf_substrate', 'ABF supplier relationship.'],
  ['link_shinko_to_abf', 'lt_company_produces_for_abf_substrate', 'obj_company_shinko', 'obj_abf_substrate', 'ABF supplier relationship.'],
  ['link_besi_to_flip_chip', 'lt_company_produces_for_flip_chip_bonding_equipment', 'obj_company_besi', 'obj_equipment_flip_chip_bonder', 'Equipment supplier relationship.'],
  ['link_asmpt_to_flip_chip', 'lt_company_produces_for_flip_chip_bonding_equipment', 'obj_company_asmpt', 'obj_equipment_flip_chip_bonder', 'Equipment supplier relationship.'],
  ['link_kulicke_to_flip_chip', 'lt_company_produces_for_flip_chip_bonding_equipment', 'obj_company_kulicke_soffa', 'obj_equipment_flip_chip_bonder', 'Equipment supplier relationship.'],
  ['link_besi_to_hybrid', 'lt_company_produces_for_hybrid_bonding_equipment', 'obj_company_besi', 'obj_equipment_hybrid_bonder', 'Equipment supplier relationship.'],
  ['link_asmpt_to_hybrid', 'lt_company_produces_for_hybrid_bonding_equipment', 'obj_company_asmpt', 'obj_equipment_hybrid_bonder', 'Equipment supplier relationship.'],
  ['link_disco_to_thinning', 'lt_company_produces_for_wafer_thinning_equipment', 'obj_company_disco', 'obj_equipment_wafer_thinning', 'Equipment supplier relationship.'],
  ['link_flip_chip_to_service', 'lt_flip_chip_bonding_equipment_supports_capability_of_assembly_test_service', 'obj_equipment_flip_chip_bonder', 'obj_service_tsmc_cowos', 'Flip-chip bonding equipment supports advanced packaging service.'],
  ['link_hybrid_to_service', 'lt_hybrid_bonding_equipment_supports_capability_of_assembly_test_service', 'obj_equipment_hybrid_bonder', 'obj_service_tsmc_cowos', 'Hybrid bonding equipment supports advanced packaging service.'],
  ['link_thinning_to_service', 'lt_wafer_thinning_equipment_supports_capability_of_assembly_test_service', 'obj_equipment_wafer_thinning', 'obj_service_tsmc_cowos', 'Wafer thinning equipment supports advanced packaging and HBM process flows.'],
  ['link_capex_to_service', 'lt_capital_expenditure_measures_for_assembly_test_service', 'obj_metric_tsmc_adv_packaging_capex', 'obj_service_tsmc_cowos', 'Capex is measured against packaging service capacity.'],
  ['link_capex_to_facility', 'lt_capital_expenditure_measures_for_backend_facility', 'obj_metric_tsmc_adv_packaging_capex', 'obj_facility_tsmc_ap6', 'Capex is measured against backend facility expansion.'],
];

const auditRows = [
  ['GPU', 'architecture_generation/process_platform/hbm_generation/packaging_solution/target_application；以及由GB200聚合规格反推的HBM容量/带宽', 'GPU实例只保留NVIDIA明确归属于Blackwell/B200 GPU的属性：双die、208B晶体管、10TB/s die-to-die；架构、制程工艺、封装、HBM、应用继续用关系表达', '避免把GB200 Superchip聚合规格误写成单颗B200 GPU规格，回答更经得住追问。'],
  ['训练加速器', 'architecture_generation/target_workload/cpu_configuration/memory_configuration/interconnect_configuration/compute_capability_summary/source_granularity', '训练加速器保留gpu_count、cpu_count、memory_capacity_gb、memory_bandwidth_tbps、interconnect_bandwidth_tbps；CPU、HBM世代、互联技术、架构、应用均用关系表达', '让模块级数值、可对象化部件和内部审计证据分开，回答更清楚。'],
  ['GPU架构世代', 'process_platform/compute_die_count/die_to_die_bandwidth_tbps/transistor_count_billion/technical_bottleneck', '架构世代实例只保留release_date和source_url；工艺走制程工艺关系，双die/208B/10TB/s留在GPU实例和属性证据，technical_bottleneck不落正式属性', '避免把某个Blackwell GPU实现规格误写成整个架构世代的通用属性。'],
  ['制程工艺/制程节点', 'process_name/process_type/customer_scope/node_name/node_class/node_semantics等说明性字段', 'TSMC 4NP作为制程工艺实例，只保留source_url；4nm-class作为制程节点实例，只额外保留generation；工艺类型、适用范围、节点归属通过description和link_instance_data表达', '把“具体工艺变体”和“节点层级”拆开，同时避免正式属性和name字段重复。'],
  ['HBM', 'supplier/generation', '供应商改为公司生产供给HBM；世代改为HBM采用HBM世代', '同一HBM世代可以挂多个供应商产品，避免属性枚举供应链。'],
  ['封装技术世代', 'generation_name/packaging_dimension', '封装技术世代实例只保留name、description、source_url；2.5D作为技术大类，通过关系连接到CoWoS', '先回答“属于哪一类封装范式”，避免和具体方案混在一起。'],
  ['先进封装技术', 'packaging_type/max_die_count/interconnect_density_requirement等方案或规格化字段', '先进封装技术承载CoWoS这类技术路线，只保留technology_family、integration_mode和source_url', '先回答“用了什么技术平台/路线”，不承载供应商服务或具体方案细节。'],
  ['封装方案', 'provider/technology_type/multi_die_support/key_bottleneck等关系或解释性字段', '封装方案承载TSMC CoWoS-L这类具体可被GPU采用的方案，保留interposer_type、local_silicon_interconnect、hbm_support', '让GPU采用的对象更具体，同时把供应商、瓶颈、服务能力交给关系和服务层表达。'],
  ['封装测试服务', 'provider/supported_product/supported_packaging_solution', '封装测试服务承载台积电CoWoS封装测试服务这类商业化服务/产能能力，通过公司、后道工厂、资本开支、GPU支撑关系挂载', '服务不再和CoWoS-L方案混同，便于回答“谁能做、产能在哪里、扩产投向什么”。'],
  ['后道工厂', 'owner_company/related_technology', '改为后道工厂所属公司、后道工厂生产供给封装测试服务', '工厂保留地点/状态，归属和能力用边表达。'],
  ['ABF载板', 'supplier/target_application', '改为公司生产供给ABF载板、ABF载板供给于GPU', '材料对象保留材料和需求驱动，供应链挂边。'],
  ['设备类OT', 'supplier', '改为公司生产供给倒装键合机/混合键合机/晶圆减薄机', '设备参数和设备供应商分开，便于查找设备瓶颈。'],
  ['资本开支', 'company_name', '不作为正式属性；通过统计对象边挂到服务/工厂，必要时由服务/工厂回推公司', '资本开支更像事实对象，统计对象比文本公司名更稳。'],
];

const propertyDesignRows = [
  ['判断问题', '进入OT正式属性', '进入证据/规格明细表', '改成link_instance_data'],
  ['是否是该类对象长期稳定、跨实例常见的内在参数？', '是，例如训练加速器的gpu_count、cpu_count、memory_capacity_gb', '否，某一代产品才有的细颗粒度跑分或规格', '否，描述另一个对象或上下游对象时'],
  ['是否需要作为高频筛选/排序字段？', '是，例如容量、代际、状态等高频字段可保留', '低频展示、审计追溯字段可以下沉', '如果筛选条件本质是关联对象，例如供应商/应用/封装方案'],
  ['空值是否会大面积出现？', '如果多数实例都有值，可以保留', '如果只有少数实例有值，优先放规格明细/证据表', '如果空值来自对象关系不存在或不确定，用关系表表达'],
  ['属性值是否来自多个来源或需要逐字段追溯？', '可保留主来源source_url作为实例级默认来源', '逐字段来源放instance_property_evidence', '关系证据放Link_Instance_Data或关系证据扩展表'],
  ['本次GB200处理', '训练加速器保留模块级可比较数值属性', '细颗粒度算力、逐字段来源进入证据表，供内部审计使用', 'Grace CPU、HBM3E世代、NVLink/NVLink-C2C、架构、应用等通过link_instance_data表达'],
];

const evidenceRows = [
  ['evi_b200_compute_die_count', 'GPU', 'obj_gpu_nvidia_b200', 'compute_die_count', '2', 'number', sources.nvidiaBlackwellNewsroom, 'NVIDIA Blackwell Platform Arrives to Power a New Era of Computing', 'Official NVIDIA release describes Blackwell GPUs as using two reticle-limit dies connected as one unified GPU.', 'official', '2024-03-18'],
  ['evi_b200_transistor_count', 'GPU', 'obj_gpu_nvidia_b200', 'transistor_count_billion', '208', 'billion transistors', sources.nvidiaBlackwellNewsroom, 'NVIDIA Blackwell Platform Arrives to Power a New Era of Computing', 'Official NVIDIA release states Blackwell-architecture GPUs contain 208 billion transistors.', 'official', '2024-03-18'],
  ['evi_b200_die_to_die_bandwidth', 'GPU', 'obj_gpu_nvidia_b200', 'die_to_die_bandwidth_tbps', '10', 'TB/s', sources.nvidiaBlackwellNewsroom, 'NVIDIA Blackwell Platform Arrives to Power a New Era of Computing', 'Official NVIDIA release states the two GPU dies are connected by a 10TB/s chip-to-chip link.', 'official', '2024-03-18'],
  ['evi_gb200_gpu_count', '训练加速器', 'obj_training_accelerator_gb200', 'gpu_count', '2', 'GPU', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list one Grace CPU and two Blackwell GPUs per GB200 Superchip.', 'official', ''],
  ['evi_gb200_cpu_count', '训练加速器', 'obj_training_accelerator_gb200', 'cpu_count', '1', 'CPU', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list one Grace CPU in the GB200 Superchip configuration.', 'official', ''],
  ['evi_gb200_memory_capacity', '训练加速器', 'obj_training_accelerator_gb200', 'memory_capacity_gb', '372', 'GB HBM3E', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list 372GB HBM3E GPU memory for the GB200 Superchip.', 'official', ''],
  ['evi_gb200_memory_bandwidth', '训练加速器', 'obj_training_accelerator_gb200', 'memory_bandwidth_tbps', '16', 'TB/s', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list 16TB/s HBM3E bandwidth for the GB200 Superchip.', 'official', ''],
  ['evi_gb200_interconnect_bandwidth', '训练加速器', 'obj_training_accelerator_gb200', 'interconnect_bandwidth_tbps', '3.6', 'TB/s', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list 3.6TB/s NVLink bandwidth.', 'official', ''],
  ['evi_gb200_nvfp4_sparse_dense', '训练加速器', 'obj_training_accelerator_gb200', 'nvfp4_tensor_core_pflops_sparse_dense', '40 | 20', 'PFLOPS sparse | dense', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list NVFP4 Tensor Core throughput as sparse and dense values.', 'official', ''],
  ['evi_gb200_fp8_fp6', '训练加速器', 'obj_training_accelerator_gb200', 'fp8_fp6_tensor_core_pflops', '20', 'PFLOPS', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP8/FP6 Tensor Core throughput.', 'official', ''],
  ['evi_gb200_int8', '训练加速器', 'obj_training_accelerator_gb200', 'int8_tensor_core_pops', '20', 'POPS', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list INT8 Tensor Core throughput.', 'official', ''],
  ['evi_gb200_fp16_bf16', '训练加速器', 'obj_training_accelerator_gb200', 'fp16_bf16_tensor_core_pflops', '10', 'PFLOPS', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP16/BF16 Tensor Core throughput.', 'official', ''],
  ['evi_gb200_tf32', '训练加速器', 'obj_training_accelerator_gb200', 'tf32_tensor_core_pflops', '5', 'PFLOPS', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list TF32 Tensor Core throughput.', 'official', ''],
  ['evi_gb200_fp32', '训练加速器', 'obj_training_accelerator_gb200', 'fp32_tflops', '160', 'TFLOPS', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP32 throughput.', 'official', ''],
  ['evi_gb200_fp64', '训练加速器', 'obj_training_accelerator_gb200', 'fp64_tflops', '80', 'TFLOPS', sources.nvidiaGb200, 'NVIDIA GB200 NVL72', 'Official GB200 product specifications list FP64 throughput.', 'official', ''],
];

function q(value) {
  if (value === undefined || value === null) return 'NULL';
  return `'${String(value).replaceAll('\\', '\\\\').replaceAll("'", "''")}'`;
}

function qi(identifier) {
  return `\`${identifier.replaceAll('`', '``')}\``;
}

function tableName(otName) {
  return ot[Object.keys(ot).find((k) => ot[k][1] === otName)][0];
}

function rowColumns(otName) {
  return ['unique_id', 'name', 'description', ...propertyPlan[otName]];
}

function objectRowsByOt() {
  const grouped = new Map();
  for (const row of objectRows) {
    if (!grouped.has(row.ot)) grouped.set(row.ot, []);
    grouped.get(row.ot).push(row);
  }
  return grouped;
}

function backingDatasetSql() {
  const stmts = [];
  const seen = new Set();
  for (const row of objectRows) {
    if (seen.has(row.ot)) continue;
    seen.add(row.ot);
    const [otId] = ot[Object.keys(ot).find((k) => ot[k][1] === row.ot)];
    stmts.push(`UPDATE object_types SET backing_dataset = ${q(tableName(row.ot))} WHERE project_id = @project_id AND id = ${q(otId)};`);
  }
  return stmts.join('\n');
}

function metadataRenameSql() {
  return [
    `UPDATE object_types SET name = '制程工艺' WHERE project_id = @project_id AND id = 'process_platform';`,
    `UPDATE object_types SET name = '制程节点' WHERE project_id = @project_id AND id = 'process_node_generation';`,
  ].join('\n');
}

function createTableSql() {
  const stmts = [];
  for (const [otName] of objectRowsByOt()) {
    const cols = [
      '  `id` bigint NOT NULL AUTO_INCREMENT',
      '  `name` varchar(500) DEFAULT NULL',
      '  `unique_id` varchar(500) DEFAULT NULL',
      '  `description` text',
      '  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP',
      '  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP',
      ...propertyPlan[otName].map((col) => `  ${qi(col)} text NULL`),
    ];
    stmts.push(`CREATE TABLE IF NOT EXISTS ${qi(tableName(otName))} (\n${cols.join(',\n')},\n  PRIMARY KEY (\`id\`),\n  UNIQUE KEY \`uk_unique_id\` (\`unique_id\`)\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`);
  }
  return stmts.join('\n\n');
}

function insertObjectsSql() {
  const stmts = [];
  for (const [otName, rows] of objectRowsByOt()) {
    const cols = rowColumns(otName);
    const values = rows.map((row) => `(${cols.map((col) => q(col === 'unique_id' ? row.id : row[col])).join(', ')})`);
    const updates = cols.filter((c) => c !== 'unique_id').map((col) => `${qi(col)} = VALUES(${qi(col)})`).join(', ');
    stmts.push(`INSERT INTO ${qi(tableName(otName))} (${cols.map(qi).join(', ')}) VALUES\n${values.join(',\n')}\nON DUPLICATE KEY UPDATE ${updates};`);
  }
  return stmts.join('\n\n');
}

function linkTypeSql() {
  return linkTypeRows.map(([id, name, sourceOt, targetOt, predicate, status]) => {
    const sourceOtId = Object.values(ot).find(([, cn]) => cn === sourceOt)[0];
    const targetOtId = Object.values(ot).find(([, cn]) => cn === targetOt)[0];
    const category = predicate === '驱动' ? '技术驱动' : predicate === '适配' ? '能力适配' : predicate === '下游应用' ? '下游应用' : predicate === '统计对象' ? '统计对象' : '技术关联';
    const description = `Blackwell demo v2: ${status}`;
    return `INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at)
VALUES (${q(id)}, ${q(name)}, ${q(sourceOtId)}, ${q(targetOtId)}, 'M:N', ${q(category)}, ${q(description)}, NULL, NULL, NULL, 'active', @project_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE name=VALUES(name), source_object_id=VALUES(source_object_id), target_object_id=VALUES(target_object_id), link_category=VALUES(link_category), description=VALUES(description), status='active', updated_at=CURRENT_TIMESTAMP;`;
  }).join('\n\n');
}

function linkInstanceSql() {
  const inserts = linkRows.map(([_id, linkTypeId, sourceId, targetId]) => `INSERT INTO link_instance_data (link_type_id, source_instance_id, target_instance_id)
SELECT ${q(linkTypeId)}, ${q(sourceId)}, ${q(targetId)}
WHERE NOT EXISTS (
  SELECT 1 FROM link_instance_data
  WHERE link_type_id=${q(linkTypeId)} AND source_instance_id=${q(sourceId)} AND target_instance_id=${q(targetId)}
);`);
  return `CREATE TABLE IF NOT EXISTS link_instance_data (
  \`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  \`link_type_id\` varchar(100) NOT NULL COMMENT '链接类型ID',
  \`source_instance_id\` varchar(100) NOT NULL COMMENT '源对象实例唯一标识',
  \`target_instance_id\` varchar(100) NOT NULL COMMENT '目标对象实例唯一标识',
  \`created_at\` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (\`id\`),
  KEY \`idx_link_type\` (\`link_type_id\`),
  KEY \`idx_source_instance\` (\`source_instance_id\`),
  KEY \`idx_target_instance\` (\`target_instance_id\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='链接实例数据表';

${inserts.join('\n\n')}`;
}

function propertyEvidenceSql() {
  const columns = ['evidence_id', 'object_type_name', 'instance_id', 'property_name', 'property_value', 'value_unit', 'source_url', 'source_title', 'evidence_text', 'confidence', 'evidence_date'];
  const values = evidenceRows.map((row) => `(${row.map(q).join(', ')})`);
  const updates = columns.filter((col) => col !== 'evidence_id').map((col) => `${qi(col)} = VALUES(${qi(col)})`).join(', ');
  return `CREATE TABLE IF NOT EXISTS instance_property_evidence (
  \`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  \`evidence_id\` varchar(160) NOT NULL COMMENT '证据唯一标识',
  \`object_type_name\` varchar(100) NOT NULL COMMENT '对象类型中文名',
  \`instance_id\` varchar(160) NOT NULL COMMENT '实例唯一标识',
  \`property_name\` varchar(160) NOT NULL COMMENT '属性名或规格名',
  \`property_value\` text NULL COMMENT '属性值',
  \`value_unit\` varchar(100) DEFAULT NULL COMMENT '值单位',
  \`source_url\` text NULL COMMENT '来源链接',
  \`source_title\` varchar(500) DEFAULT NULL COMMENT '来源标题',
  \`evidence_text\` text NULL COMMENT '证据摘述',
  \`confidence\` varchar(50) DEFAULT NULL COMMENT '证据可信度',
  \`evidence_date\` varchar(50) DEFAULT NULL COMMENT '证据日期',
  \`created_at\` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  \`updated_at\` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (\`id\`),
  UNIQUE KEY \`uk_evidence_id\` (\`evidence_id\`),
  KEY \`idx_instance_property\` (\`instance_id\`, \`property_name\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='实例属性级证据表';

INSERT INTO instance_property_evidence (${columns.map(qi).join(', ')}) VALUES
${values.join(',\n')}
ON DUPLICATE KEY UPDATE ${updates};`;
}

function buildSql() {
  return [
    '-- Blackwell demo v2 import for company DB',
    '-- Scope: company DB already has object_types/link_types/properties metadata, but has no instance tables.',
    '-- Modeling rule: intrinsic attributes stay on OT tables; cross-object facts are represented by link_instance_data.',
    `SET @project_id := ${q(projectId)};`,
    '',
    '-- 1. Create instance tables and bind object_types.backing_dataset.',
    createTableSql(),
    '',
    '-- 1a. Align display names for reused process OTs.',
    metadataRenameSql(),
    '',
    backingDatasetSql(),
    '',
    '-- 2. Upsert object instances.',
    insertObjectsSql(),
    '',
    '-- 3. Ensure link types required by the v2 mounting plan exist.',
    linkTypeSql(),
    '',
    '-- 4. Upsert link instances.',
    linkInstanceSql(),
    '',
    '-- 5. Upsert property-level evidence for audited specs.',
    propertyEvidenceSql(),
    '',
  ].join('\n');
}

function setBlock(sheet, rows) {
  const rowCount = rows.length;
  const colCount = Math.max(...rows.map((row) => row.length));
  const normalized = rows.map((row) => {
    const copy = [...row];
    while (copy.length < colCount) copy.push(null);
    return copy;
  });
  const range = sheet.getRangeByIndexes(0, 0, rowCount, colCount);
  range.values = normalized;
  return { rowCount, colCount };
}

function styleSheet(sheet, rowCount, colCount) {
  sheet.showGridLines = false;
  const header = sheet.getRangeByIndexes(0, 0, 1, colCount);
  header.format = {
    fill: '#17324d',
    font: { bold: true, color: '#ffffff' },
  };
  header.format.wrapText = true;
  const used = sheet.getRangeByIndexes(0, 0, rowCount, colCount);
  used.format.borders = { preset: 'inside', style: 'thin', color: '#d9e2ec' };
  used.format.wrapText = true;
  used.format.autofitColumns();
  used.format.autofitRows();
  sheet.freezePanes.freezeRows(1);
}

async function addSheet(workbook, name, rows) {
  const sheet = workbook.worksheets.add(name);
  const { rowCount, colCount } = setBlock(sheet, rows);
  styleSheet(sheet, rowCount, colCount);
}

function objectSheetRows(otName, rows) {
  const cols = ['unique_id', 'name', 'name_en', 'object_type_name', 'description', ...propertyPlan[otName]];
  return [cols, ...rows.map((row) => cols.map((col) => col === 'unique_id' ? row.id : col === 'name_en' ? row.nameEn : col === 'object_type_name' ? row.ot : row[col] ?? ''))];
}

async function buildWorkbook() {
  const workbook = Workbook.create();
  await addSheet(workbook, 'Design_Principles', [
    ['原则', '说明'],
    ['属性只放对象自身参数', '例如GPU保留官方明确属于Blackwell/B200 GPU的die数量、晶体管数、die-to-die带宽；架构、制程工艺、封装、应用均改成关系。'],
    ['B200/GB200规格分层', 'B200 GPU不承载从GB200 Superchip聚合规格反推的HBM容量、HBM带宽或算力；这些规格放在训练加速器/加速模块实例上。'],
    ['OT属性保持可复用', '训练加速器OT不因为GB200一个实例就扩成规格大全；低频、细颗粒度、强来源依赖的规格放入属性级证据表。'],
    ['关系统一落link_instance_data', '供应商、采用、对应、支撑、供给、统计对象都用显式边表达，便于检索和路径解释。'],
    ['制程工艺和制程节点分层', 'TSMC 4NP作为制程工艺实例，4nm-class作为制程节点实例，通过制程工艺对应制程节点挂载。'],
    ['演示目标', '让Blackwell问题优先命中架构、GPU、制程工艺、制程节点、HBM、封装方案、服务/产能等关键路径，而不是散落属性文本。'],
  ]);
  await addSheet(workbook, 'Attribute_Audit', [['OT', '原设计中关系型属性', 'v2处理方式', '演示收益'], ...auditRows]);
  await addSheet(workbook, 'Property_Design_Guide', propertyDesignRows);
  await addSheet(workbook, 'Object_Instance_Index', [
    ['instance_id', 'name', 'object_type', 'description'],
    ...objectRows.map((row) => [row.id, row.name, row.ot, row.description]),
  ]);
  for (const [otName, rows] of objectRowsByOt()) {
    await addSheet(workbook, `OT_${otName}`.slice(0, 31), objectSheetRows(otName, rows));
  }
  await addSheet(workbook, 'Link_Type_Plan', [
    ['link_type_id', 'name', 'source_ot', 'target_ot', 'predicate', 'status'],
    ...linkTypeRows,
  ]);
  await addSheet(workbook, 'Link_Instance_Data', [
    ['link_instance_id', 'link_type_id', 'source_instance_id', 'target_instance_id', 'evidence'],
    ...linkRows,
  ]);
  await addSheet(workbook, 'Property_Evidence', [
    ['evidence_id', 'object_type_name', 'instance_id', 'property_name', 'property_value', 'value_unit', 'source_url', 'source_title', 'evidence_text', 'confidence', 'evidence_date'],
    ...evidenceRows,
  ]);
  await addSheet(workbook, 'SQL_Import_Summary', [
    ['项目', '数量/说明'],
    ['project_id', projectId],
    ['instance_tables', objectRowsByOt().size],
    ['object_instances', objectRows.length],
    ['link_types_ensured', linkTypeRows.length],
    ['link_instances', linkRows.length],
    ['property_evidence_rows', evidenceRows.length],
    ['sql_strategy', 'CREATE TABLE IF NOT EXISTS + UPSERT；不删除原有数据，不清空已有backing_dataset。'],
  ]);
  return workbook;
}

async function main() {
  await fs.mkdir(outDir, { recursive: true });
  const sqlPath = path.join(outDir, 'import_blackwell_demo_v2_company_db.sql');
  const workbookPath = path.join(outDir, 'blackwell_technology_transmission_demo_v2.xlsx');
  const workbook = await buildWorkbook();
  await fs.writeFile(sqlPath, buildSql(), 'utf8');

  const errors = await workbook.inspect({
    kind: 'match',
    searchTerm: '#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A',
    options: { useRegex: true, maxResults: 300 },
    summary: 'formula error scan',
  });
  console.log(errors.ndjson);

  const xlsx = await SpreadsheetFile.exportXlsx(workbook);
  await xlsx.save(workbookPath);

  const renderDir = path.join(outDir, 'rendered_sheets');
  await fs.mkdir(renderDir, { recursive: true });
  for (const sheetName of ['Design_Principles', 'Attribute_Audit', 'Property_Design_Guide', 'Object_Instance_Index', 'OT_GPU', 'OT_训练加速器', 'OT_CPU', 'OT_互联技术', 'OT_GPU架构世代', 'OT_制程工艺', 'OT_制程节点', 'OT_封装技术世代', 'OT_先进封装技术', 'OT_封装方案', 'OT_封装测试服务', 'Link_Type_Plan', 'Link_Instance_Data', 'Property_Evidence', 'SQL_Import_Summary']) {
    const preview = await workbook.render({ sheetName, autoCrop: 'all', scale: 1, format: 'png' });
    await fs.writeFile(path.join(renderDir, `${sheetName}.png`), new Uint8Array(await preview.arrayBuffer()));
  }
  console.log(JSON.stringify({ sqlPath, workbookPath, renderDir }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
