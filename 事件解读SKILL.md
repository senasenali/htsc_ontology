---
name: semiconductor-event-interpreter
description: 半导体产业链事件解读。输入事件描述、URL、公告/PDF、本地文件或初版观点，基于本机半导体 ontology 与 instance 做事实核实、实体 grounding、最多 5 跳产业链传导、A股/港股/美股受益受损标的评分，并输出 Markdown、JSON 和交互 HTML。凡用户要求解读半导体扩产/Capex、减产/供应中断、涨跌价、订单需求变化、技术突破或替代影响，即使没有点名本 skill，也应使用。不要用于修改 ontology、填充主 instance、单纯查询一个行情数值或与具体事件无关的泛公司研究。
compatibility: Requires Python 3.10+, filesystem access to the semiconductor ontology/database, and current-source search tools for event and market verification.
---

# 半导体产业链事件解读

把半导体事件转换成可核实、可回溯的投资解读。Ontology 提供产业链结构，instance 提供公司与产品映射，外部实时来源负责核实事件和证券数据；三者不能互相替代。

## 固定数据路径

```text
SKILL_DIR=/Users/simon/.agents/skills/semiconductor-event-interpreter
ONTOLOGY=/Users/simon/Documents/Simon-OB/本体论/base/半导体/output/semiconductor_ontology.json
DATABASE=/Users/simon/Documents/Simon-OB/本体论/base/半导体/output/数据库
OUTPUT_ROOT=/Users/simon/Documents/Simon-OB/workspace/半导体事件解读
```

以当前真实目录为准。`数据库_manifest.csv` 只作追溯，不按其中可能遗留的旧绝对路径读取文件。

主 ontology 和 database 全程只读。新事实、证券映射、别名判断和来源缓存只写本次事件目录。

## 开始前读取

每次执行都读取：

- `references/event-schema.md`：结构化输入格式。
- `references/source-policy.md`：来源、日期和置信度规则。
- `references/output-contract.md`：产物和报告格式。
- `references/report-writing-style.md`：投资快评写作、reference 样本处理和底稿索引规则。

通常无需读取 JSON 规则文件；确定性脚本会直接加载它们。只有调试传播或评分时再读：

- `references/propagation-rules.json`
- `references/scoring-rules.json`

## 支持范围

仅处理能 grounding 到半导体产业链的五类事件：

1. `capacity_capex`：扩产、建厂、提高 Capex。
2. `production_disruption`：减产、停产、事故、供应中断。
3. `price_change`：产品、材料或服务涨跌价。
4. `order_demand_change`：新订单、砍单、需求上修/下修。
5. `technology_substitution`：技术突破、量产、路线替代。

若事件本质是宏观、地缘或泛市场事件，且没有明确半导体公司、产品、材料、设备、制造/封测或应用锚点，改用通用 `event-interpreter`。

## Step 1：建立事件目录并保留原始输入

1. 用 `Asia/Shanghai` 当前时间创建：

   ```text
   $OUTPUT_ROOT/<event_slug>_<YYYYMMDD_HHMMSS>/
   └── source_cache/
   ```

2. 将用户观点与来源正文分开。`初版观点`只能成为待核实 claim，不能成为独立证据。
3. 如果用户提供“参考写法 / reference / 按这个感觉写 / 之前那种风格”等样本文字，先原样保存为 `$EVENT_DIR/source_cache/reference_style_user_supplied.md`。它只作为写作风格和结构参考，不作为事件证据；其中任何事实若要进入结论，必须按 Step 2 重新核实。
4. 对 URL、公告、PDF、本地文件或表格使用当前环境合适的读取工具；保留原始文件路径、URL、标题、发布时间和提取时间。
5. 不修改用户原文件。

## Step 2：事实核实与事件结构化

### 2.1 来源顺序

按以下顺序核实：

1. 公司 IR、交易所、监管、政府、标准组织等 A 类来源。
2. 权威行业机构、主流财经媒体等 B 类来源。
3. 聚合或社交线索仅用于寻找 A/B 类原始材料。

涉及当前事件、行情、公司状态或政策时必须实时检索。公司公告优先公司 IR/交易所；A 股行情和公告可优先使用 `opencli eastmoney` 或可用结构化行情工具；海外信息优先公司 IR、交易所和官方来源。

### 2.2 写入 `event_facts.json`

根据 `references/event-schema.md` 写入：

- 明确 `event_class`、`event_time`、`as_of_time`。
- 指定 `primary_claim_id`，方向传播以主 claim 为起点；其余 claims 用于核实和补充。
- 每条 claim 拆出主体、动作、对象、数值、单位、阶段、生效期、地域和 evidence IDs。
- 扩产必须区分建设期、爬坡期、供给释放期。
- 技术突破必须区分验证、导入、量产阶段。
- 不确定值写 `null` 并记录原因，不猜数。

### 2.3 写入 `evidence.json`

每条 evidence 至少包含：来源级别、机构、标题、发布日期、URL、支持的 claim IDs 和独立来源键。

若证据直接验证某个图节点或关系，再写：

- `supports_node_ids`
- `supports_relation_categories`

Hop 4-5 路径只有获得独立 A/B 类路径证据，才可进入标的榜。

### 硬停止 A

关键事件事实没有 A 类来源时，只做核实状态和缺口说明，不运行投资标的评分。

## Step 3：受约束的实体 Grounding

### 3.1 生成 mentions

将事件中的公司、产品、材料、设备、技术、制造/封测服务、产能或价格对象写入：

```json
{
  "mentions": [
    {"mention": "原文实体", "object_type_hint": null}
  ]
}
```

### 3.2 调用候选召回

```bash
python3 "$SKILL_DIR/scripts/prepare_grounding.py" \
  --mentions "$EVENT_DIR/source_cache/mentions.json" \
  --ontology "$ONTOLOGY" \
  --database "$DATABASE" \
  --output "$EVENT_DIR/source_cache/grounding_candidates.json"
```

### 3.3 消歧并写 `grounding.json`

- 唯一 exact/alias match 可采用 `auto_grounding`。
- fuzzy 或多候选时，只能在 `candidates` 中结合事件上下文选择。
- `selected_id` 必须属于 `candidate_ids`。
- 无法可靠选择时写 `ambiguous` 或 `unresolved`。
- 不创建候选集合外的节点，不用临时别名污染主库。

### 硬停止 B

没有任何 semiconductor anchor 成功 matched 时，只输出事实核实与本体覆盖缺口，不进行图推理。

## Step 4：补充本地事实和三地证券数据

### 4.1 本地事实

从 `$DATABASE/fact_tables/` 补充价格、产能、Capex、库存、稼动率、财务或毛利率。必须保留 `source_doc`、`source_date`、单位、币种、segment 和统计口径。

`统计对象`、`报价对象`只负责挂接数据，不能单独推出受益或受损。

### 4.2 证券映射

为候选公司核实：

- 公司法定名与常用名。
- A 股、港股或美股 ticker。
- 上市状态。
- 行情/成交反应截至哪个交易日。
- ticker 与事件公司的对应证据。

写入 `securities.json`。同一主体多地上市时分别保留 ticker，共享基本面路径。

### 4.3 评分输入纪律

- `business_exposure` 使用可核实的收入、产能、份额或产品组合占比，转换为 `0-100`；没有量化证据时写 `null`。
- `market_novelty` 按 `scoring-rules.json` 的离散档位选择，并在证券记录中写明依据和 evidence IDs。
- `data_freshness` 可留空，由引擎根据 `as_of_date` 计算。
- 缺 exposure 或 novelty 的标的会标记 `provisional`，总分上限 59。
- 无可靠 ticker 或 ticker evidence 的公司只进产业链影响清单，不进榜单。

## Step 5：运行确定性图引擎

```bash
python3 "$SKILL_DIR/scripts/run_semiconductor_event.py" \
  --event-facts "$EVENT_DIR/source_cache/event_facts.json" \
  --grounding "$EVENT_DIR/source_cache/grounding.json" \
  --evidence "$EVENT_DIR/source_cache/evidence.json" \
  --securities "$EVENT_DIR/source_cache/securities.json" \
  --ontology "$ONTOLOGY" \
  --database "$DATABASE" \
  --output "$EVENT_DIR"
```

引擎负责：

- 正向与逆向语义遍历。
- 最多 5 跳、循环检测、hop decay、beam 和总路径上限。
- 过滤 `统计对象`、`报价对象` 等 enrichment-only 边。
- 事件原型与时间阶段对应的方向传播。
- `impact_direction`、`evidence_confidence`、`rank_score` 分离。
- A 股、港股、美股分别排序。

不要绕过 runner 直接让模型生成分数或路径。

## Step 6：根据 Bundle 成文

读取 `reasoning_bundle.json`，获取其 SHA-256，再生成 `report.md`。报告开头必须包含：

```text
生成时间：YYYY-MM-DD HH:MM:SS Asia/Shanghai
事件时间：YYYY-MM-DD
数据截至：YYYY-MM-DD（交易日 / natural day / latest available）
bundle_id：<实际 bundle_id>
bundle_sha256：<实际 SHA-256>
```

默认使用 `references/output-contract.md` 与 `references/report-writing-style.md` 的“事件快评”结构，而不是把图谱路径铺在正文里。正文要先服务投资阅读，再用底稿索引满足可追溯与 validator。

写作规则：

- 报告主体默认写成“事件 / 点评 / 投资机会 / 节奏判断 / 风险 / 结论 / 底稿索引”。若用户给了 reference 样本，优先贴近其结构、语气和信息密度。
- 正文只解释少数高价值 Hop 1-3 机制，不堆 path IDs、evidence IDs、bundle 字段名、ontology 术语或机器评分细节。
- 每个方向结论必须能追溯到 `reasoning_bundle.json`；必要的 `path_id` 和 `evidence_id` 集中放在“底稿索引”，不要打断正文。
- 只有通过路径证据 Gate 的 Hop 4-5 才能进入正文；其余长链条放入观察池或覆盖缺口。
- 每个榜单 ticker 在底稿索引里保留分数拆解、数据截至日期、path IDs、evidence IDs、催化剂和失效条件；正文只写投资含义和 provisional 边界。
- `mixed` 必须解释不同阶段或相反机制，不能压成单一方向。
- 分数只表示同事件、同市场内的相对排序，不解释成预计涨跌幅。
- 未通过置信度闸门时降低结论强度，不用平衡话术伪装确定性。
- 如果用户提到“可读性差 / 太像机器 / 去AI味 / 参考这个感觉”，按 `human-writing` 的检查清单处理：删除模板化翻转句、反问过渡和段段金句，让报告像行业同事写的快评。

## Step 7：生成 HTML 并执行最终 Gate

```bash
python3 "$SKILL_DIR/scripts/render_impact_graph.py" \
  --bundle "$EVENT_DIR/reasoning_bundle.json" \
  --output "$EVENT_DIR/impact_graph.html"

python3 "$SKILL_DIR/scripts/validate_reasoning_bundle.py" \
  "$EVENT_DIR/reasoning_bundle.json"

python3 "$SKILL_DIR/scripts/validate_run_artifacts.py" \
  --bundle "$EVENT_DIR/reasoning_bundle.json" \
  --report "$EVENT_DIR/report.md" \
  --html "$EVENT_DIR/impact_graph.html" \
  --manifest "$EVENT_DIR/run_manifest.json"
```

### 硬停止 C

任一 validator 返回非零时，不宣布报告完成。修复结构化输入、报告引用或产物一致性后重跑；不得删除 Gate 来换取通过。

## Step 8：最终回复

只在最终 Gate 通过后，向用户提供：

- `report.md` 绝对路径。
- `reasoning_bundle.json` 绝对路径。
- `impact_graph.html` 绝对路径。
- 本次事件时间、数据截至日期、A/H/US 入榜数量。
- 明确列出降级项或数据缺口。

不要在最终回复中复述整篇报告。

## 失败与降级

- Ontology 缺失、schema 非法或 link endpoint 无效：停止图推理。
- 关键事件事实无 A 类来源：只做核实，不给榜单。
- Entity unresolved：写覆盖缺口，不传播。
- Instance 缺失：可保留 type-level 路径，不给公司 exposure 分。
- 某市场证券/行情数据失败：不输出该市场排名，其他市场可继续。
- HTML 失败：保留 JSON/Markdown，但整次运行仍标记未完成，直到 manifest 记录的 Gate 状态清楚。
- 来源冲突：并列记录口径、采用理由和置信度影响，不做无依据平均。

## 不要做

- 不修改 `$ONTOLOGY` 或 `$DATABASE`。
- 不把 ontology 结构关系当作当前事件事实。
- 不把模型共识当作来源。
- 不让 5 跳路径无限扩散；规则外关系默认不传播。
- 不将 score 当成目标价或涨跌幅预测。
- 不输出缺日期、单位、口径、公司或来源的数字。
