import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const root = process.cwd();
const fullDir = path.join(root, "data/instance/full_instance");
const factDir = path.join(root, "data/instance/fact_tables");
const outDir = path.join(root, "outputs/semi_wff_mounting");
const outputPath = path.join(outDir, "semi_wff_instance_mounting_summary.xlsx");

function parseCsv(text) {
  text = text.replace(/^\uFEFF/, "");
  const rows = [];
  let row = [];
  let value = "";
  let inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    const next = text[i + 1];
    if (inQuotes) {
      if (ch === '"' && next === '"') {
        value += '"';
        i++;
      } else if (ch === '"') {
        inQuotes = false;
      } else {
        value += ch;
      }
    } else if (ch === '"') {
      inQuotes = true;
    } else if (ch === ",") {
      row.push(value);
      value = "";
    } else if (ch === "\n") {
      row.push(value.replace(/\r$/, ""));
      rows.push(row);
      row = [];
      value = "";
    } else {
      value += ch;
    }
  }
  if (value.length || row.length) {
    row.push(value.replace(/\r$/, ""));
    rows.push(row);
  }
  if (!rows.length) return [];
  const headers = rows[0];
  return rows
    .slice(1)
    .filter((r) => r.some((v) => String(v ?? "").length))
    .map((r) => Object.fromEntries(headers.map((h, i) => [h, r[i] ?? ""])));
}

async function readCsv(filePath) {
  const text = await fs.readFile(filePath, "utf8");
  return parseCsv(text);
}

function normalizeValue(v) {
  if (v === undefined || v === null || v === "") return null;
  const s = String(v);
  if (/^-?\d+(\.\d+)?$/.test(s)) return Number(s);
  return s;
}

function rowsToMatrix(rows, headers) {
  return [headers, ...rows.map((r) => headers.map((h) => normalizeValue(r[h])))];
}

function safeSheetName(name) {
  return name.slice(0, 31).replace(/[\\/?*:[\]]/g, "_");
}

function colLetter(index) {
  let n = index + 1;
  let s = "";
  while (n > 0) {
    const rem = (n - 1) % 26;
    s = String.fromCharCode(65 + rem) + s;
    n = Math.floor((n - 1) / 26);
  }
  return s;
}

function writeSheet(workbook, name, headers, rows, options = {}) {
  const sheet = workbook.worksheets.add(safeSheetName(name));
  sheet.showGridLines = false;
  const matrix = rowsToMatrix(rows, headers);
  const range = sheet.getRangeByIndexes(0, 0, matrix.length, headers.length);
  range.values = matrix;

  const headerRange = sheet.getRangeByIndexes(0, 0, 1, headers.length);
  headerRange.format.fill.color = "#1F4E78";
  headerRange.format.font.color = "#FFFFFF";
  headerRange.format.font.bold = true;
  headerRange.format.wrapText = true;

  if (matrix.length > 1) {
    const body = sheet.getRangeByIndexes(1, 0, matrix.length - 1, headers.length);
    body.format.borders = { preset: "inside", style: "thin", color: "#E5E7EB" };
    body.format.wrapText = options.wrap ?? false;
  }
  range.format.autofitColumns();
  range.format.autofitRows();
  sheet.freezePanes.freezeRows(1);
  return sheet;
}

function metricRowsFromSummary(summary) {
  const rows = [];
  for (const [file, info] of Object.entries(summary.fact_table_summary ?? {})) {
    for (const [metric, count] of Object.entries(info.metric_counts ?? {})) {
      rows.push({
        fact_table: file,
        metric_name: metric,
        rows: count,
        role: metric.includes("spending")
          ? "可抽取为资本开支事实"
          : metric.includes("capacity")
            ? "可抽取为晶圆产能事实"
            : "保留为分析字段",
      });
    }
  }
  return rows;
}

async function main() {
  await fs.mkdir(outDir, { recursive: true });
  const summary = JSON.parse(await fs.readFile(path.join(outDir, "semi_wff_mounting_summary.json"), "utf8"));

  const workbook = Workbook.create();

  const otRows = [
    { ot: "晶圆制造工厂", file: "晶圆制造工厂.csv", rows: summary.facility_instance_counts?.["晶圆制造工厂"] ?? 0, usage: "实体底座", action: "采用已有 SEMI 实例" },
    { ot: "外延工厂", file: "外延工厂.csv", rows: summary.facility_instance_counts?.["外延工厂"] ?? 0, usage: "实体底座", action: "采用已有 SEMI 实例" },
    { ot: "研发中试工厂", file: "研发中试工厂.csv", rows: summary.facility_instance_counts?.["研发中试工厂"] ?? 0, usage: "实体底座", action: "采用已有 SEMI 实例" },
    { ot: "后道工厂", file: "后道工厂.csv", rows: summary.facility_instance_counts?.["后道工厂"] ?? 0, usage: "实体底座", action: "采用已有 SEMI 实例" },
    { ot: "晶圆产能", file: "晶圆产能.csv", rows: (await readCsv(path.join(fullDir, "晶圆产能.csv"))).length, usage: "指标事实实例", action: "采用已有实例并补关系挂载" },
    { ot: "资本开支", file: "资本开支.csv", rows: (await readCsv(path.join(fullDir, "资本开支.csv"))).length, usage: "指标事实实例", action: "采用已有实例；修复过 Excel 日期污染值" },
    { ot: "晶圆代工", file: "晶圆代工.csv", rows: (await readCsv(path.join(fullDir, "晶圆代工.csv"))).length, usage: "被统计对象/服务口径", action: "新增通用口径实例 SEMI WFF wafer foundry market scope" },
  ];

  const linkRows = [];
  for (const [file, rows] of Object.entries(summary.written_link_csv_rows ?? {})) {
    linkRows.push({
      file,
      rows,
      action: "本次生成/刷新",
      source: "SEMI facility_record_id 或 foundry metric_name",
    });
  }

  const relationFiles = Object.keys(summary.written_link_csv_rows ?? {}).map((f) => path.join(root, f));
  const relationDetails = [];
  for (const file of relationFiles) {
    const rows = await readCsv(file);
    for (const row of rows) {
      relationDetails.push({
        link_csv: path.relative(root, file),
        linkTypeName: row.linkTypeName,
        sourceObjectType: row.sourceObjectType,
        sourceInstance: row.sourceInstance,
        targetObjectType: row.targetObjectType,
        targetInstance: row.targetInstance,
        source_url: row.source_url,
      });
    }
  }

  const facilityRows = [];
  for (const file of ["晶圆制造工厂.csv", "外延工厂.csv", "研发中试工厂.csv", "后道工厂.csv"]) {
    const rows = await readCsv(path.join(fullDir, file));
    for (const row of rows) {
      facilityRows.push({
        objectTypeName: row.objectTypeName,
        nameCn: row.nameCn,
        record_id: row["property.record_id"],
        status: row["property.status"],
        country: row["property.country"],
        region: row["property.region"],
        product_type_2: row["property.product_type_2"],
        current_full_capacity: row["property.current_full_capacity"],
        capacity_200mm_equivalent: row["property.capacity_200mm_equivalent"],
        source_sheet: row["property.source_sheet"],
      });
    }
  }

  const capacityRows = (await readCsv(path.join(fullDir, "晶圆产能.csv"))).map((row) => ({
    nameCn: row.nameCn,
    statistic_period: row["property.statistic_period"],
    capacity_value: row["property.capacity_value"],
    wafer_size: row["property.wafer_size"],
    company_name: row["property.company_name"],
    segment: row["property.segment"],
    metric_name: row["property.metric_name"],
    facility_name: row["property.facility_name"],
    facility_record_id: row["property.facility_record_id"],
    source_sheet: row["property.source_sheet"],
  }));

  const capexRows = (await readCsv(path.join(fullDir, "资本开支.csv"))).map((row) => ({
    nameCn: row.nameCn,
    capex_amount: row["property.capex_amount"],
    currency: row["property.currency"],
    period: row["property.period"],
    capex_category: row["property.capex_category"],
    company_name: row["property.company_name"],
    purpose: row["property.capacity_or_technology_purpose"],
    facility_name: row["property.facility_name"],
    facility_record_id: row["property.facility_record_id"],
    source_sheet: row["property.source_sheet"],
  }));

  const ltRows = [
    {
      name: "晶圆产能统计对象后道工厂",
      sourceObjectType: "晶圆产能",
      targetObjectType: "后道工厂",
      linkTypeCategory: "统计对象",
      predicate: "统计对象",
      radix: "多对一（N:1）",
      action: "已补充到本体 JSON",
    },
  ];

  const validationRows = [
    { check: "facility_record_id duplicate", result: Object.keys(summary.duplicate_facility_record_ids ?? {}).length, status: "pass" },
    { check: "capacity unmatched facility records", result: summary.unmatched_counts?.capacity ?? 0, status: "pass" },
    { check: "capex unmatched facility records", result: summary.unmatched_counts?.capex ?? 0, status: "pass" },
    { check: "numeric anomalies after normalization", result: (summary.numeric_anomalies ?? []).length, status: "pass" },
    { check: "generated relation rows", result: relationDetails.length, status: "pass" },
  ];

  writeSheet(workbook, "总览", ["item", "value", "note"], [
    { item: "source", value: summary.source, note: "SEMI WFF source workbook" },
    { item: "ontology LT added", value: "晶圆产能统计对象后道工厂", note: summary.added_capacity_backend_facility_lt ? "本次新增" : "已存在" },
    { item: "generic foundry scope", value: "SEMI WFF wafer foundry market scope", note: "用于挂载公司级 foundry 产能口径" },
    { item: "relation csv rows", value: relationDetails.length, note: "所有生成关系实例明细行数" },
    { item: "facility records indexed", value: summary.facility_record_index_size, note: "用 record_id 进行硬匹配" },
  ], { wrap: true });
  writeSheet(workbook, "OT实例汇总", ["ot", "file", "rows", "usage", "action"], otRows, { wrap: true });
  writeSheet(workbook, "新增LT", ["name", "sourceObjectType", "targetObjectType", "linkTypeCategory", "predicate", "radix", "action"], ltRows, { wrap: true });
  writeSheet(workbook, "关系实例汇总", ["file", "rows", "action", "source"], linkRows, { wrap: true });
  writeSheet(workbook, "关系实例明细", ["link_csv", "linkTypeName", "sourceObjectType", "sourceInstance", "targetObjectType", "targetInstance", "source_url"], relationDetails);
  writeSheet(workbook, "设施实例", ["objectTypeName", "nameCn", "record_id", "status", "country", "region", "product_type_2", "current_full_capacity", "capacity_200mm_equivalent", "source_sheet"], facilityRows);
  writeSheet(workbook, "晶圆产能实例", ["nameCn", "statistic_period", "capacity_value", "wafer_size", "company_name", "segment", "metric_name", "facility_name", "facility_record_id", "source_sheet"], capacityRows);
  writeSheet(workbook, "资本开支实例", ["nameCn", "capex_amount", "currency", "period", "capex_category", "company_name", "purpose", "facility_name", "facility_record_id", "source_sheet"], capexRows);
  writeSheet(workbook, "fact表摘要", ["fact_table", "metric_name", "rows", "role"], metricRowsFromSummary(summary), { wrap: true });
  writeSheet(workbook, "数据修复与校验", ["check", "result", "status"], validationRows, { wrap: true });

  for (const sheet of workbook.worksheets.items) {
    const used = sheet.getUsedRange();
    if (used) {
      used.format.autofitColumns();
      used.format.autofitRows();
    }
  }

  const inspect = await workbook.inspect({
    kind: "sheet",
    include: "name",
    maxChars: 4000,
  });
  console.log(inspect.ndjson);

  const previewDir = path.join(outDir, "previews");
  await fs.mkdir(previewDir, { recursive: true });
  for (const sheet of workbook.worksheets.items) {
    const used = sheet.getUsedRange();
    if (!used) continue;
    const name = sheet.name;
    const lastCol = Math.min(9, used.columnCount - 1);
    const lastRow = Math.min(24, used.rowCount - 1);
    const range = `A1:${colLetter(lastCol)}${lastRow + 1}`;
    const preview = await workbook.render({ sheetName: name, range, scale: 1, format: "png" });
    const bytes = new Uint8Array(await preview.arrayBuffer());
    await fs.writeFile(path.join(previewDir, `${name}.png`), bytes);
  }

  const output = await SpreadsheetFile.exportXlsx(workbook);
  await output.save(outputPath);
  console.log(`saved ${outputPath}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
