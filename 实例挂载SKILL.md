---
name: ontology-instance-fill
description: 为 Ontology-creat 生成的 type-only JSON 生成独立实例文件。凡用户提到生成实例、补齐实例、填充 object/link instance、产品实例、公司生产实例、从公告/联网资料采集企业和产品实例，或要生成 full-instance CSV / objectTypeAndInstance / linkTypeAndInstance，都使用此 skill。本 skill 只处理实例层，Ontology-creat 继续只负责 objectType 和 linkType 框架。
---

# Ontology Instance Fill

这个 skill 只做一件事：读取 `Ontology-creat` 生成的 type-only JSON，生成独立实例文件。主交付是 full-instance CSV 目录，同时保留 Markdown 索引用于人读和快速校验。

分层边界：

- `Ontology-creat`：只生成 `objectType` 和 `linkType` 框架，不写具体公司、产品 SKU、项目、订单、事件或 `instanceList`。
- `ontology-instance-fill`：只生成实例层，不重写本体框架，不把实例塞回 `objectType + linkType` 文件。
- 除非用户明确要求，不在这个 skill 里改 object/link type。

输入兼容与输出形态：

- 新格式输入：顶层 `objectType` + `linkType`。
- 旧格式输入：顶层 `objectType` + `linkTypeAndInstance`。
- 默认输出 Markdown 索引和同名 full-instance CSV 目录，例如 `semiconductor_instances.md` 与 `semiconductor_instances_full_instance/`。
- full-instance CSV 是主交付。CSV 文件名必须按 `objectType.nameCn` 或 `linkType.name` 命名，例如 `GPU.csv`、`公司生产供给GPU.csv`。
- full-instance CSV 目录只放实例表，不混入材料用量、价格、毛利率、capex 等旁路事实表，避免 `GPU.csv` 这类 object instance 表和事实表撞名。
- Markdown 顶层表达 `objectTypeAndInstance` 与 `linkTypeAndInstance`，可以作为 CSV 的索引和校验视图。
- `objectTypeAndInstance.instanceList` 可以是字符串数组，也可以是对象数组。外部/协作者实例带属性时，使用对象结构并输出到 CSV：
  - 基础列：`nameCn`、`nameEn`、`objectTypeName`、`description`
  - 扩展属性列：`property.<propertyName>`
- `linkTypeAndInstance` 的 CSV 基础列：`sourceInstance`、`targetInstance`、`linkTypeName`、`sourceObjectType`、`targetObjectType`、`linkTypeCategory`。
- 如果用户要求的指标当前没有对应 object type，例如本轮半导体本体没有 `营业收入`、`净利润`，可以在 Markdown 或旁路 CSV 中追加事实段；不要临时伪造 object type，也不要把事实表放进 full-instance CSV 目录。
- 旁路事实段的 Markdown 表名必须优先使用现有 ontology 名称：
  - 能对应到 `linkType.name` 的，用完整 link type 名，例如 `产品价格报价对象GPU`、`资本开支统计对象晶圆代工`、`公司生产供给封装测试服务`。
  - 不能对应到 link type 但能对应到 `objectType.nameCn` 的，用 object type 名，例如 `GPU`、`被动元件`。
  - 不要把工程分组名作为最终表名，例如不要用 `productPriceFacts`、`businessGrossMarginFacts` 这类名字做交付表名。
- 不要把 `instanceList` 回写到 Ontology-creat 的 type-only JSON 原文件。

推荐 Markdown 结构：

~~~markdown
# <主题> Instance Fill

## objectTypeAndInstance

```json
[
  {
    "objectTypeName": "GPU",
    "instanceList": ["NVIDIA H100 Tensor Core GPU"]
  }
]
```

## linkTypeAndInstance

```json
[
  {
    "linkTypeName": "公司生产供给GPU",
    "sourceObjectType": "公司",
    "targetObjectType": "GPU",
    "linkTypeCategory": "生产供给",
    "instanceList": [
      {
        "sourceInstance": "NVIDIA Corporation",
        "targetInstance": "NVIDIA H100 Tensor Core GPU"
      }
    ]
  }
]
```
~~~

## 当前范围

默认只使用用户已经提供或本地已有的数据材料。不要默认联网检索、调用 Gangtise 或启动 agent 补采；只有用户明确要求“扩展采集”“从网上获取 instance”“用公告/网页补采”等外部采集时，才进入联网采集模式。

本地数据优先级：

1. 结构化映射表，尤其是含 `enterprise`、`enterprise_object`、`standard_product` 的 CSV。
2. 本地图谱 JSON 中节点自带的 `company` 列表。
3. 供应链/OEM JSON 树里带公司、供应商、零部件字段的数据。
4. Markdown 里明确写出的企业产品层。
5. 对非公司对象使用 object type 同名兜底实例。

外部采集模式沿用 `Ontology-creat` 的 source_discovery 思路，但目标从 type 层改成 instance 层：

1. 先读输入 JSON 附近的 `ontology_source_cache/source_discovery.md`、`query_iteration_log.md` 和既有来源，继承行业边界和权威来源。
2. 再做 instance_source_discovery，优先找能直接证明公司、产品、财务指标的来源。
3. 公司和产品实例以公司公告、年报、10-K/20-F、招股书、投资者关系材料、产品页、datasheet、白皮书为主证据。
4. Tavily API / agent-reach / web search 用于发现公司官网、公告页、交易所披露页、监管文件和产品资料入口。Tavily 是 API 能力，不是 opencli；不要把 Tavily 写成 opencli 路由。
5. Gemini、OpenCLI Gemini、Gangtise、HTSC 或其他 LLM 只能用于候选生成、同义词归并、冲突检查和遗漏检查；不能作为最终实例证据。
6. 新闻、百科、媒体稿和二手网页只能作 lead；除非来自权威主体官网或监管/交易所平台，不单独入库。
7. 每轮查询、采纳和排除都写入旁路 cache，不写进 `instanceList`。

## 实例语义

最终 JSON 保持 demo 里的最小结构：

```json
{
  "sourceInstance": "比亚迪股份有限公司",
  "targetInstance": "秦PLUS 2025款 DM-i 智驾版 55KM领先型"
}
```

不要把证据、置信度、id 或 metadata 塞进 `instanceList`。来源和统计记录写到 Markdown 的 evidence / cache 段落或旁路 cache。

外部采集模式下，旁路 cache 至少包含：

```text
<output_stem>_instance_cache/
  instance_fill_summary.json
  instance_source_discovery.md
  instance_query_iteration_log.md
  company_candidate_matrix.csv
  product_candidate_matrix.csv
  market_metric_candidate_matrix.csv
  evidence_index.csv
  conflict_review.md
```

## 填充规则

### 公司生产关系

当 link 满足：

- `sourceObjectType` 是 `公司`
- `linkTypeCategory` 是 `生产供给` 或旧口径 `生产`

只使用已验证的公司/产品关系。

- 如果结构化行能映射 `enterprise -> enterprise_object -> standard_product`，且 `standard_product` 精确匹配目标 object type：
  - `sourceInstance = enterprise`
  - `targetInstance = enterprise_object`
- 如果本地图谱只给出某节点下的公司列表：
  - `sourceInstance = company`
  - `targetInstance = 目标 object type 名称`
- 外部采集模式下，必须能从公司公告、年报/10-K/20-F、招股书、IR 材料、公司产品页或 datasheet 中找到证据，才写入公司生产关系。
- 不编造公司实例。没有证据时，该生产关系的 `instanceList` 保持空数组。

### 半导体联网采集重点

当用户要求给半导体本体联网补实例，且输入是 `output/semiconductor_ontology/semiconductor_ontology.json` 这一类现有本体时，默认聚焦下面三类，不扩大到全产业链：

1. 公司实例：覆盖国内和国外公司。先从目标产品类型反推公司池，再按公告/官网证据确认。
2. 公司对应产品：暂时只关注 `存储` 和 `GPU/AI加速器` 相关叶子类型。
   - 存储目标 object type：`DRAM`、`HBM`、`NAND Flash`、`NOR Flash`。
   - GPU/AI 加速目标 object type：`GPU`、`NPU`、`推理加速器`、`训练加速器`、`边缘AI加速器`。
   - `AI加速器` 是父类时，不直接作为 link endpoint；使用其叶子子类承接实例。
3. 公司市场数据：优先采集 `资本开支`，并把盈利类指标作为公司财务指标旁路数据处理。
   - 当前 type 层已有 `资本开支` object type，可填充 `资本开支 -> 产品/服务` 的 `统计对象` 实例关系，或输出公司-指标事实表。
   - 当前 type 层没有 `营业收入`、`净利润` 等独立 object type；不要为了填盈利实例擅自改 type 层。盈利、营收、净利润、毛利率等写入 `market_metric_candidate_matrix.csv` 或单独指标 fact 表，除非用户明确要求先更新 ontology type。

半导体来源优先级：

1. 公司公告与财报：A 股公告、港交所公告、SEC 10-K/20-F/6-K、公司 annual report、investor presentation。
2. 公司产品证据：公司产品页、datasheet、技术白皮书、开发者文档、解决方案页。
3. 交易所/监管平台：SEC EDGAR、巨潮资讯、上交所/深交所/北交所、港交所披露易、公司 IR archive。
4. 行业核心源和统计源：SEMI、SIA、WSTS、TrendForce/DRAMeXchange 等，用于指标口径和市场数据线索。
5. Tavily API / agent-reach / web search：用于定位上述来源。
6. Gemini/OpenCLI Gemini：用于候选公司池、同义词、产品归类和冲突检查；输出必须回链到主证据。

半导体候选字段：

- `company_candidate_matrix.csv`：`company_name`、`company_alias`、`country_or_region`、`listing_venue`、`ticker`、`homepage`、`ir_url`、`evidence_status`、`notes`。
- `product_candidate_matrix.csv`：`company_name`、`standard_product`、`enterprise_product`、`product_family`、`evidence_url`、`evidence_type`、`filing_date_or_doc_date`、`adopted`、`reject_reason`。
- `market_metric_candidate_matrix.csv`：`company_name`、`metric_name`、`metric_period`、`metric_value`、`currency_or_unit`、`segment`、`related_object_type`、`source_doc`、`source_date`、`adopted`。
- `product_material_requirement_matrix.csv`：`product_platform`、`product_instance`、`component_or_material`、`quantity`、`unit`、`scope`、`derivation_method`、`source_doc`、`source_date`、`confidence`。
- `product_price_matrix.csv`：`standard_product`、`product_instance`、`price_type`、`price_value`、`currency`、`unit`、`market_region`、`as_of_date`、`source_doc`、`source_type`、`confidence`。
- `business_gross_margin_matrix.csv`：`company_name`、`business_segment`、`metric_period`、`gross_margin_pct`、`metric_basis`、`source_doc`、`source_date`、`confidence`。
- `fab_capacity_or_spending_matrix.csv`：`company_name`、`metric_name`、`metric_period`、`metric_value`、`unit`、`product_type`、`source_doc`、`source_sheet`、`confidence`。

采纳规则：

- 公司名称采用公告或公司官网中的正式名称；同时保留别名到旁路 cache。
- 产品必须能映射到现有 object type；如果只能看到品牌名或 SKU，要上提到 `DRAM/HBM/NAND Flash/NOR Flash/GPU/...` 等标准类型后再填关系。
- 对同一公司同一产品类型可以有多个 `targetInstance`，例如产品族、产品线或型号系列；不要把单次订单、客户项目、传闻规格写成稳定产品实例。
- 市场数据必须带期间和单位；没有期间或币种/单位的数值不采纳。
- 产品材料/组件用量必须写清作用域：`per_gpu`、`per_superchip`、`per_rack`、`per_system` 或 `derived_from_public_capacity`。如果公开资料只给平台总量，允许写推导值，但 `derivation_method` 必须说明公式。
- CPU/GPU/MCU 价格必须写清价格类型：`official_rcp`、`official_store_price`、`authorized_reseller_price`、`retail_listing`、`estimated_market_range`。非官方价格不能伪装成官方价。
- 分业务毛利率必须区分 `company_consolidated`、`foundry`、`packaging_testing`、`passive_components`、`EMS` 等口径；若公司只披露 operating margin 而非 gross margin，不要改名成 gross margin。
- 公司公告与官网冲突时，优先公告；公告与第三方统计冲突时，保留冲突记录并默认不写入实例关系。

### 非公司关系

其他 link 优先使用本地产品/组件映射。没有真实实例时，用 object type 中文名作为唯一兜底实例：

```json
{
  "sourceInstance": "锂资源与化合物",
  "targetInstance": "碳酸锂"
}
```

这表示 `碳酸锂` 可以同时是 object type 和兜底 instance。它只是类型代理实例，不代表具体商品、SKU 或已经验证的企业产品。

## 命令

使用内置脚本：

```bash
python3 /Users/simon/.agents/skills/ontology/skills/ontology-instance-fill/scripts/fill_instances.py \
  /path/to/input_ontology.json \
  --data /path/to/data_or_file \
  --target-object-type GPU \
  --include-link-category 生产供给 \
  --include-source-object-type 公司 \
  --output /path/to/input_ontology_instances.md \
  --output-dir /path/to/input_ontology_instances_full_instance
```

可以多次传入 `--data`。如果不传，脚本会从输入 JSON 附近和当前工作目录查找常见本地数据目录。

默认只做精确匹配。只有用户接受更高召回和更多人工复核时，才使用 `--fuzzy-match`。

常用过滤参数：

- `--target-object-type`：只输出与指定目标 object type 相关的实例。可以重复传入。
- `--include-link-category`：只输出指定关系类型，例如只输出 `生产供给`。
- `--include-source-object-type`：只输出指定 source object type，例如只输出 `公司 -> 产品`，避免把其他生产供给类类型代理关系带入。

如果不传 `--output-dir`，脚本会在 Markdown 旁边生成 `<output_stem>_full_instance/`。脚本还会在输出文件旁边写旁路记录：

```text
<output_stem>_full_instance/
  <objectType.nameCn>.csv
  <linkType.name>.csv
<output_stem>_instance_cache/
  instance_fill_summary.json
```

外部采集模式暂不由 `fill_instances.py` 直接联网抓取。执行时先把公告和网页证据整理成结构化 CSV，再把 CSV 传给脚本。推荐最小 link instance CSV 字段：

```csv
enterprise,enterprise_object,standard_product,evidence_url,evidence_type,source_date
NVIDIA Corporation,NVIDIA H100 Tensor Core GPU,GPU,https://...,annual_report,2025-02-26
SK hynix Inc.,HBM3E,HBM,https://...,annual_report,2025-03-21
```

协作者或上游工具已经给出 object instance 时，推荐最小 object instance CSV 字段：

```csv
nameCn,nameEn,objectTypeName,description,property.generation_name
Blackwell,Blackwell,GPU架构世代,NVIDIA Blackwell GPU架构,Blackwell
```

如果来源是 JSON，脚本会读取顶层 `instance` 数组，并把 `properties` 扁平化为 `property.*` 列。

## 校验

生成后运行：

```bash
python3 /Users/simon/.agents/skills/ontology/skills/ontology-instance-fill/scripts/fill_instances.py \
  /path/to/input_ontology.json \
  --data /path/to/data_or_file \
  --output /path/to/input_ontology_instances.md \
  --check
```

`--check` 会检查：

- Markdown 包含 `## objectTypeAndInstance` 和 `## linkTypeAndInstance`
- `objectTypeAndInstance` 与 `linkTypeAndInstance` 代码块是可解析 JSON
- 每条 link instance 都有 `instanceList`
- 每个实例只包含 `sourceInstance` 和 `targetInstance`
- object instance 是非空字符串，或包含 `nameCn`、`nameEn`、`objectTypeName`、`description` 的对象
- link instance 值都是非空字符串

外部采集模式还要人工或脚本检查：

- 每个采纳公司和产品关系都有主证据 URL。
- 公告/财报类来源记录了发布日期或报告期。
- 盈利、capex 等市场数据记录了期间、单位和币种。
- Gemini/Tavily 只出现在候选或检索日志中，不作为唯一证据。
- 输入的 type-only JSON 原文件没有被污染为 instance JSON。

## 回复口径

完成后简短说明：

- 输入 JSON 路径
- 输出 Markdown 路径和 full-instance CSV 目录
- 使用的数据来源数量
- 已填充 link 数和实例总数
- 因无公司数据保持空的生产关系数量
- 如果是外部采集模式，补充说明公告/官网/交易所/其他来源的数量，以及未采纳的主要原因

不要写成长报告。这个 skill 是确定性转换工具，不是研究报告。
