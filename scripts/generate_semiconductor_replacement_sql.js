#!/usr/bin/env node
/*
 * Generate a dry-run SQL replacement package for semiconductor ontology metadata.
 *
 * This script does not connect to MySQL. It reads the source ontology JSON and
 * writes:
 *   - sql/generated/replace_semiconductor_ontology_metadata.sql
 *   - sql/generated/semiconductor_ontology_replacement_report.md
 *   - sql/generated/semiconductor_ontology_id_mapping.csv
 */

const fs = require("fs");
const path = require("path");

const DEFAULT_INPUT = "data/ontology/semiconductor_ontology_ot_lt_with_relation_objects.json";
const DEFAULT_PROJECT_ID = "project_1780997325389";
const DEFAULT_OUTPUT_DIR = "sql/generated";

const CARDINALITY_MAP = new Map([
  ["一对多（1:N）", "1:N"],
  ["多对多（M:N）", "M:N"],
  ["一对一（1:1）", "1:1"],
  ["多对一（N:1）", "N:1"],
  ["N:M", "M:N"],
]);

const PREDICATE_SLUGS = new Map([
  ["供给于", "supplies_to"],
  ["生产供给", "produces_for"],
  ["能力支撑", "supports_capability_of"],
  ["采用", "adopts"],
  ["报价对象", "quotes_for"],
  ["统计对象", "measures_for"],
  ["市场数据", "market_data_of"],
]);

function parseArgs(argv) {
  const args = {
    input: DEFAULT_INPUT,
    projectId: DEFAULT_PROJECT_ID,
    outputDir: DEFAULT_OUTPUT_DIR,
    includeProjectUpsert: false,
  };

  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === "--input") args.input = argv[++i];
    else if (arg === "--project-id") args.projectId = argv[++i];
    else if (arg === "--output-dir") args.outputDir = argv[++i];
    else if (arg === "--include-project-upsert") args.includeProjectUpsert = true;
    else if (arg === "--help" || arg === "-h") {
      console.log(`Usage:
  node scripts/generate_semiconductor_replacement_sql.js [options]

Options:
  --input <path>        Source ontology JSON. Default: ${DEFAULT_INPUT}
  --project-id <id>     Target project id. Default: ${DEFAULT_PROJECT_ID}
  --output-dir <dir>    Output directory. Default: ${DEFAULT_OUTPUT_DIR}
  --include-project-upsert
                       Also add INSERT ... ON DUPLICATE KEY UPDATE for projects.
`);
      process.exit(0);
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }

  return args;
}

function escapeSql(value) {
  if (value === null || value === undefined) return "";
  return String(value).replace(/\\/g, "\\\\").replace(/'/g, "''");
}

function sqlString(value) {
  if (value === null || value === undefined || value === "") return "NULL";
  return `'${escapeSql(value)}'`;
}

function csvCell(value) {
  const text = value === null || value === undefined ? "" : String(value);
  return `"${text.replace(/"/g, '""')}"`;
}

function hash32(text) {
  let hash = 0x811c9dc5;
  for (const char of text) {
    hash ^= char.codePointAt(0);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return hash.toString(16).padStart(8, "0");
}

function uniqueId(base, usedIds) {
  let id = base;
  let index = 2;
  while (usedIds.has(id)) {
    id = `${base}_${index}`;
    index += 1;
  }
  usedIds.add(id);
  return id;
}

function normalizeCardinality(raw) {
  return CARDINALITY_MAP.get(raw) || raw || "M:N";
}

function normalizeCategory(type) {
  return String(type || "").includes("关系") ? "relation" : "entity";
}

function buildIdMaps(objectTypes, linkTypes) {
  const usedIds = new Set();
  const cnToId = new Map();
  const mappingRows = [];

  for (const ot of objectTypes) {
    if (ot.nameEn) {
      const id = uniqueId(ot.nameEn, usedIds);
      cnToId.set(ot.nameCn, id);
      mappingRows.push({
        nameCn: ot.nameCn,
        generatedId: id,
        sourceNameEn: ot.nameEn,
        strategy: id === ot.nameEn ? "nameEn" : "nameEn_deduped",
      });
    }
  }

  for (const ot of objectTypes) {
    if (cnToId.has(ot.nameCn)) continue;

    const baseName = String(ot.nameCn || "").replace(/关系事实$/, "");
    const matchedLt = linkTypes.find((lt) => lt.name === baseName);
    let generated;
    let strategy;

    if (matchedLt) {
      const sourceId = cnToId.get(matchedLt.sourceObjectType);
      const targetId = cnToId.get(matchedLt.targetObjectType);
      const predicateSlug = PREDICATE_SLUGS.get(matchedLt.predicate) || "relation";
      generated = `relation_fact_${sourceId}_${predicateSlug}_${targetId}`;
      strategy = "matched_link_type";
    } else {
      generated = `relation_fact_${hash32(ot.nameCn)}`;
      strategy = "hash_fallback";
    }

    const id = uniqueId(generated, usedIds);
    cnToId.set(ot.nameCn, id);
    mappingRows.push({
      nameCn: ot.nameCn,
      generatedId: id,
      sourceNameEn: "",
      strategy,
    });
  }

  return { cnToId, mappingRows };
}

function getDepth(ot, byNameCn) {
  let depth = 0;
  let parentName = ot.parentObjectTypeName;
  const visited = new Set();
  while (parentName && !visited.has(parentName)) {
    visited.add(parentName);
    depth += 1;
    const parent = byNameCn.get(parentName);
    parentName = parent ? parent.parentObjectTypeName : null;
  }
  return depth;
}

function makePropertyId(objectTypeId, propertyEn, propertyCn, usedPropertyIds) {
  const cleanProperty = propertyEn || `unnamed_${hash32(propertyCn || "")}`;
  return uniqueId(`p_${objectTypeId}_${cleanProperty}`, usedPropertyIds);
}

function buildReplacementSql({ objectTypes, linkTypes, cnToId, projectId, inputPath, includeProjectUpsert }) {
  const byNameCn = new Map(objectTypes.map((ot) => [ot.nameCn, ot]));
  const nowSql = "CURRENT_TIMESTAMP";
  const projectIdSql = sqlString(projectId);
  const lines = [];
  const usedPropertyIds = new Set();
  const ltCounter = new Map();

  lines.push("-- ============================================================");
  lines.push("-- Semiconductor ontology metadata replacement SQL");
  lines.push(`-- Source JSON: ${inputPath}`);
  lines.push(`-- Target project_id: ${projectId}`);
  lines.push(`-- Object types: ${objectTypes.length}`);
  lines.push(`-- Link types: ${linkTypes.length}`);
  lines.push("-- Generated by scripts/generate_semiconductor_replacement_sql.js");
  lines.push("-- Review this file before executing it against MySQL.");
  lines.push("-- ============================================================");
  lines.push("");
  lines.push("START TRANSACTION;");
  lines.push("SET FOREIGN_KEY_CHECKS = 0;");
  lines.push("");
  lines.push("-- 1. Backup current target-project metadata into date-stamped tables.");
  lines.push("SET @backup_suffix = DATE_FORMAT(NOW(), '%Y%m%d_%H%i%s');");
  lines.push(`SET @project_id = '${escapeSql(projectId)}';`);
  lines.push("SET @sql = CONCAT('CREATE TABLE backup_object_types_', @backup_suffix, ' AS SELECT * FROM object_types WHERE project_id = ', QUOTE(@project_id));");
  lines.push("PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;");
  lines.push("SET @sql = CONCAT('CREATE TABLE backup_link_types_', @backup_suffix, ' AS SELECT * FROM link_types WHERE project_id = ', QUOTE(@project_id));");
  lines.push("PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;");
  lines.push("SET @sql = CONCAT('CREATE TABLE backup_properties_', @backup_suffix, ' AS SELECT * FROM properties WHERE project_id = ', QUOTE(@project_id));");
  lines.push("PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;");
  lines.push("SET @sql = CONCAT('CREATE TABLE backup_object_type_layouts_', @backup_suffix, ' AS SELECT * FROM object_type_layouts WHERE project_id = ', QUOTE(@project_id));");
  lines.push("PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;");
  lines.push("");
  lines.push("-- 2. Delete old metadata and direct dependents for the target project.");
  lines.push("DELETE FROM interface_link_type_constraint_mapping");
  lines.push(`WHERE link_type_id COLLATE utf8mb4_unicode_ci IN (SELECT id FROM link_types WHERE project_id = ${projectIdSql});`);
  lines.push("");
  lines.push("DELETE FROM link_instance_data");
  lines.push(`WHERE link_type_id COLLATE utf8mb4_unicode_ci IN (SELECT id FROM link_types WHERE project_id = ${projectIdSql});`);
  lines.push("");
  lines.push("DELETE FROM object_type_interfaces_mapping");
  lines.push(`WHERE object_type_id COLLATE utf8mb4_unicode_ci IN (SELECT id FROM object_types WHERE project_id = ${projectIdSql});`);
  lines.push("");
  lines.push(`DELETE FROM object_type_layouts WHERE project_id = ${projectIdSql};`);
  lines.push("");
  lines.push(`DELETE FROM properties WHERE project_id = ${projectIdSql};`);
  lines.push(`DELETE FROM link_types WHERE project_id = ${projectIdSql};`);
  lines.push(`DELETE FROM object_types WHERE project_id = ${projectIdSql};`);
  lines.push("");

  if (includeProjectUpsert) {
    lines.push("-- Optional project row upsert.");
    lines.push("INSERT INTO projects (id, name, description, is_public, status, created_at, updated_at)");
    lines.push(`VALUES (${sqlString(projectId)}, '半导体项目', '半导体产业链本体建模', 0, 'ACTIVE', ${nowSql}, ${nowSql})`);
    lines.push("ON DUPLICATE KEY UPDATE updated_at = VALUES(updated_at);");
    lines.push("");
  }

  lines.push("-- 3. Insert object types.");
  const sortedOts = [...objectTypes].sort((a, b) => {
    const depthDelta = getDepth(a, byNameCn) - getDepth(b, byNameCn);
    if (depthDelta !== 0) return depthDelta;
    return cnToId.get(a.nameCn).localeCompare(cnToId.get(b.nameCn));
  });

  const otValues = sortedOts.map((ot) => {
    const id = cnToId.get(ot.nameCn);
    const parentId = ot.parentObjectTypeName ? cnToId.get(ot.parentObjectTypeName) : null;
    return [
      sqlString(id),
      sqlString(ot.nameCn),
      sqlString(ot.description || ""),
      "'Database'",
      sqlString(id),
      "NULL",
      "'mysql'",
      "'ontology'",
      sqlString(parentId),
      "'active'",
      sqlString(projectId),
      "1",
      sqlString(normalizeCategory(ot.type)),
      nowSql,
      nowSql,
    ].join(",");
  });

  for (let i = 0; i < otValues.length; i += 50) {
    lines.push("INSERT INTO object_types (id, name, description, icon, backing_dataset, industry_id, data_source, database_name, parent_object_type, status, project_id, show_parent_link, object_type_category, created_at, updated_at) VALUES");
    lines.push(otValues.slice(i, i + 50).map((value) => `  (${value})`).join(",\n") + ";");
    lines.push("");
  }

  lines.push("-- 4. Insert properties.");
  const propValues = [];
  for (const ot of objectTypes) {
    const objectTypeId = cnToId.get(ot.nameCn);
    for (const [index, prop] of (ot.properties || []).entries()) {
      const propertyId = makePropertyId(objectTypeId, prop.propertyEn, prop.propertyCn, usedPropertyIds);
      const unit = prop.unit ? `; unit=${prop.unit}` : "";
      const description = `${prop.propertyCn || ""}${unit}`;
      propValues.push([
        sqlString(propertyId),
        sqlString(objectTypeId),
        sqlString(prop.propertyCn || prop.propertyEn || propertyId),
        sqlString(prop.dataType || "string"),
        sqlString(description),
        "0",
        sqlString(prop.propertyEn || ""),
        "NULL",
        String(index),
        sqlString(projectId),
      ].join(","));
    }
  }

  for (let i = 0; i < propValues.length; i += 100) {
    lines.push("INSERT INTO properties (id, object_type_id, name, type, description, is_primary_key, base_column, type_classes, sort_order, project_id) VALUES");
    lines.push(propValues.slice(i, i + 100).map((value) => `  (${value})`).join(",\n") + ";");
    lines.push("");
  }

  lines.push("-- 5. Insert link types.");
  const ltValues = [];
  for (const lt of linkTypes) {
    const sourceId = cnToId.get(lt.sourceObjectType);
    const targetId = cnToId.get(lt.targetObjectType);
    if (!sourceId || !targetId) continue;

    const predicateSlug = PREDICATE_SLUGS.get(lt.predicate) || "relation";
    const key = `lt_${sourceId}_${predicateSlug}_${targetId}`;
    const seen = (ltCounter.get(key) || 0) + 1;
    ltCounter.set(key, seen);
    const id = seen === 1 ? key : `${key}_${seen}`;

    ltValues.push([
      sqlString(id),
      sqlString(lt.name),
      sqlString(sourceId),
      sqlString(targetId),
      sqlString(normalizeCardinality(lt.radix)),
      sqlString(lt.linkTypeCategory || lt.predicate || ""),
      sqlString(lt.description || ""),
      "NULL",
      "NULL",
      "NULL",
      "'active'",
      sqlString(projectId),
      nowSql,
      nowSql,
    ].join(","));
  }

  for (let i = 0; i < ltValues.length; i += 100) {
    lines.push("INSERT INTO link_types (id, name, source_object_id, target_object_id, cardinality, link_category, description, industry_id, source_column, target_column, status, project_id, created_at, updated_at) VALUES");
    lines.push(ltValues.slice(i, i + 100).map((value) => `  (${value})`).join(",\n") + ";");
    lines.push("");
  }

  lines.push("-- 6. Post-import integrity checks.");
  lines.push(`SELECT 'object_types' AS table_name, COUNT(*) AS cnt FROM object_types WHERE project_id = '${escapeSql(projectId)}'`);
  lines.push(`UNION ALL SELECT 'relation_object_types', COUNT(*) FROM object_types WHERE project_id = '${escapeSql(projectId)}' AND object_type_category = 'relation'`);
  lines.push(`UNION ALL SELECT 'properties', COUNT(*) FROM properties WHERE project_id = '${escapeSql(projectId)}'`);
  lines.push(`UNION ALL SELECT 'link_types', COUNT(*) FROM link_types WHERE project_id = '${escapeSql(projectId)}';`);
  lines.push("");
  lines.push("SELECT lt.id, lt.name, lt.source_object_id, lt.target_object_id");
  lines.push("FROM link_types lt");
  lines.push("LEFT JOIN object_types s ON s.id = lt.source_object_id AND s.project_id = lt.project_id");
  lines.push("LEFT JOIN object_types t ON t.id = lt.target_object_id AND t.project_id = lt.project_id");
  lines.push(`WHERE lt.project_id = '${escapeSql(projectId)}' AND (s.id IS NULL OR t.id IS NULL);`);
  lines.push("");
  lines.push("SELECT p.id, p.object_type_id, p.name");
  lines.push("FROM properties p");
  lines.push("LEFT JOIN object_types ot ON ot.id = p.object_type_id AND ot.project_id = p.project_id");
  lines.push(`WHERE p.project_id = '${escapeSql(projectId)}' AND ot.id IS NULL;`);
  lines.push("");
  lines.push("SET FOREIGN_KEY_CHECKS = 1;");
  lines.push("COMMIT;");
  lines.push("");

  return lines.join("\n");
}

function analyze({ objectTypes, linkTypes, cnToId, mappingRows, inputPath, projectId }) {
  const objectNameCounts = new Map();
  const idCounts = new Map();
  for (const ot of objectTypes) {
    objectNameCounts.set(ot.nameCn, (objectNameCounts.get(ot.nameCn) || 0) + 1);
    const id = cnToId.get(ot.nameCn);
    idCounts.set(id, (idCounts.get(id) || 0) + 1);
  }

  const duplicateObjectNames = [...objectNameCounts.entries()].filter(([, count]) => count > 1);
  const duplicateIds = [...idCounts.entries()].filter(([, count]) => count > 1);
  const unresolvedParents = objectTypes.filter((ot) => ot.parentObjectTypeName && !cnToId.has(ot.parentObjectTypeName));
  const unresolvedLinks = linkTypes.filter((lt) => !cnToId.has(lt.sourceObjectType) || !cnToId.has(lt.targetObjectType));
  const missingNameEn = objectTypes.filter((ot) => !ot.nameEn);
  const relationObjects = objectTypes.filter((ot) => normalizeCategory(ot.type) === "relation");
  const properties = objectTypes.flatMap((ot) => ot.properties || []);

  const lines = [];
  lines.push("# Semiconductor Ontology Replacement Dry Run");
  lines.push("");
  lines.push(`- Source JSON: \`${inputPath}\``);
  lines.push(`- Target project_id: \`${projectId}\``);
  lines.push(`- Object types: ${objectTypes.length}`);
  lines.push(`- Entity object types: ${objectTypes.length - relationObjects.length}`);
  lines.push(`- Relation object types: ${relationObjects.length}`);
  lines.push(`- Properties: ${properties.length}`);
  lines.push(`- Link types: ${linkTypes.length}`);
  lines.push("");
  lines.push("## Validation");
  lines.push("");
  lines.push(`- Duplicate object Chinese names: ${duplicateObjectNames.length}`);
  lines.push(`- Duplicate generated object IDs: ${duplicateIds.length}`);
  lines.push(`- Unresolved parents: ${unresolvedParents.length}`);
  lines.push(`- Unresolved link endpoints: ${unresolvedLinks.length}`);
  lines.push(`- Missing source nameEn: ${missingNameEn.length}`);
  lines.push("");
  lines.push("## Missing nameEn Handling");
  lines.push("");
  if (missingNameEn.length === 0) {
    lines.push("No missing `nameEn` values.");
  } else {
    lines.push("| nameCn | generated_id | strategy |");
    lines.push("| --- | --- | --- |");
    for (const row of mappingRows.filter((row) => !row.sourceNameEn)) {
      lines.push(`| ${row.nameCn} | \`${row.generatedId}\` | ${row.strategy} |`);
    }
  }
  lines.push("");
  lines.push("## Execute After Review");
  lines.push("");
  lines.push("```bash");
  lines.push("mysql -u root -p12345678 ontology < sql/generated/replace_semiconductor_ontology_metadata.sql");
  lines.push("```");
  lines.push("");
  lines.push("Then verify the API:");
  lines.push("");
  lines.push("```bash");
  lines.push(`curl -s "http://localhost:3001/api/ontology?projectId=${projectId}"`);
  lines.push("```");
  lines.push("");

  return lines.join("\n");
}

function main() {
  const args = parseArgs(process.argv);
  const inputPath = path.resolve(args.input);
  const outputDir = path.resolve(args.outputDir);

  const src = JSON.parse(fs.readFileSync(inputPath, "utf8"));
  const objectTypes = src.objectType || [];
  const linkTypes = src.linkType || [];
  const { cnToId, mappingRows } = buildIdMaps(objectTypes, linkTypes);

  fs.mkdirSync(outputDir, { recursive: true });

  const sql = buildReplacementSql({
    objectTypes,
    linkTypes,
    cnToId,
    projectId: args.projectId,
    inputPath: path.relative(process.cwd(), inputPath),
    includeProjectUpsert: args.includeProjectUpsert,
  });
  const report = analyze({
    objectTypes,
    linkTypes,
    cnToId,
    mappingRows,
    inputPath: path.relative(process.cwd(), inputPath),
    projectId: args.projectId,
  });
  const csv = [
    ["nameCn", "generatedId", "sourceNameEn", "strategy"].map(csvCell).join(","),
    ...mappingRows.map((row) => [row.nameCn, row.generatedId, row.sourceNameEn, row.strategy].map(csvCell).join(",")),
  ].join("\n");

  const sqlPath = path.join(outputDir, "replace_semiconductor_ontology_metadata.sql");
  const reportPath = path.join(outputDir, "semiconductor_ontology_replacement_report.md");
  const mappingPath = path.join(outputDir, "semiconductor_ontology_id_mapping.csv");

  fs.writeFileSync(sqlPath, sql, "utf8");
  fs.writeFileSync(reportPath, report, "utf8");
  fs.writeFileSync(mappingPath, `${csv}\n`, "utf8");

  console.log(`Generated SQL: ${path.relative(process.cwd(), sqlPath)}`);
  console.log(`Generated report: ${path.relative(process.cwd(), reportPath)}`);
  console.log(`Generated ID mapping: ${path.relative(process.cwd(), mappingPath)}`);
}

main();
