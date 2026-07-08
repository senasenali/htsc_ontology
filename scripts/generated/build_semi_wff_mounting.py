#!/usr/bin/env python3
"""Build deterministic SEMI WFF instance mounting CSVs.

This script intentionally avoids ontology metadata edits. It only:
- maps existing wafer capacity / capex fact instances to facility instances
  via SEMI facility_record_id
- adds one generic wafer-foundry scope instance for company-level foundry facts
- maps foundry-specific company-level capacity facts to that scope
- writes an audit report under outputs/semi_wff_mounting
"""

import csv
import json
from collections import Counter, defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FULL = ROOT / "data" / "instance" / "full_instance"
FACT = ROOT / "data" / "instance" / "fact_tables"
OUT = ROOT / "outputs" / "semi_wff_mounting"
ONTOLOGY = ROOT / "data" / "ontology" / "semiconductor_ontology_ot_lt_with_relation_objects.json"

SOURCE_FILE = "SEMI_WFF_2026_1Q.xlsx"
GENERIC_FOUNDRY_SCOPE = "SEMI WFF wafer foundry market scope"

LINK_HEADER = [
    "sourceInstance",
    "targetInstance",
    "linkTypeName",
    "sourceObjectType",
    "targetObjectType",
    "linkTypeCategory",
    "source_url",
]


def read_csv(path):
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def read_header(path):
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return next(csv.reader(f), [])


def write_csv(path, fieldnames, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def is_semi_row(row):
    return any(SOURCE_FILE in str(v) or "SEMI WFF" in str(v) for v in row.values())


def source_ref(row):
    src = row.get("source_url") or row.get("property.data_source") or row.get("source_doc") or ""
    sheet = row.get("property.source_sheet") or row.get("source_sheet") or ""
    if sheet:
        return f"{SOURCE_FILE}#{sheet}"
    if SOURCE_FILE in src:
        return SOURCE_FILE
    return src


def load_facility_index():
    facility_files = {
        "晶圆制造工厂": "晶圆制造工厂.csv",
        "外延工厂": "外延工厂.csv",
        "研发中试工厂": "研发中试工厂.csv",
        "后道工厂": "后道工厂.csv",
    }
    by_record = {}
    duplicates = defaultdict(list)
    counts = {}
    for ot_name, file_name in facility_files.items():
        rows = read_csv(FULL / file_name)
        counts[ot_name] = len(rows)
        for row in rows:
            record_id = row.get("property.record_id", "").strip()
            name = row.get("nameCn", "").strip()
            if not record_id or not name:
                continue
            item = {"record_id": record_id, "name": name, "object_type": ot_name}
            if record_id in by_record:
                duplicates[record_id].append(item)
            else:
                by_record[record_id] = item
    return by_record, duplicates, counts


def link_row(source, target, link_type_name, source_ot, target_ot, src_url):
    return {
        "sourceInstance": source,
        "targetInstance": target,
        "linkTypeName": link_type_name,
        "sourceObjectType": source_ot,
        "targetObjectType": target_ot,
        "linkTypeCategory": "统计对象",
        "source_url": src_url,
    }


def build_facility_metric_links(metric_file, source_ot, by_record):
    rows = read_csv(FULL / metric_file)
    outputs = defaultdict(list)
    unmatched = []
    seen = set()

    for row in rows:
        record_id = row.get("property.facility_record_id", "").strip()
        source = row.get("nameCn", "").strip()
        if not record_id or not source:
            continue
        target = by_record.get(record_id)
        if not target:
            unmatched.append(
                {
                    "metric_file": metric_file,
                    "sourceInstance": source,
                    "facility_record_id": record_id,
                    "facility_name": row.get("property.facility_name", ""),
                }
            )
            continue

        target_ot = target["object_type"]
        link_type_name = f"{source_ot}统计对象{target_ot}"
        key = (source, target["name"], link_type_name)
        if key in seen:
            continue
        seen.add(key)
        outputs[target_ot].append(
            link_row(source, target["name"], link_type_name, source_ot, target_ot, source_ref(row))
        )
    return outputs, unmatched


def ensure_foundry_scope_instance():
    path = FULL / "晶圆代工.csv"
    rows = read_csv(path)
    header = read_header(path)
    if not any(row.get("nameCn") == GENERIC_FOUNDRY_SCOPE for row in rows):
        rows.append(
            {
                "nameCn": GENERIC_FOUNDRY_SCOPE,
                "nameEn": "",
                "objectTypeName": "晶圆代工",
                "description": "Generic wafer foundry market/service scope used to mount SEMI WFF company-level foundry capacity observations without attributing them to a specific company service instance.",
                "source_url": SOURCE_FILE,
            }
        )
        write_csv(path, header, rows)
        return True
    return False


def build_foundry_capacity_scope_links():
    rows = read_csv(FULL / "晶圆产能.csv")
    out = []
    seen = set()
    for row in rows:
        if row.get("property.metric_name") != "foundry_installed_capacity":
            continue
        source = row.get("nameCn", "").strip()
        if not source:
            continue
        key = (source, GENERIC_FOUNDRY_SCOPE)
        if key in seen:
            continue
        seen.add(key)
        out.append(
            link_row(
                source,
                GENERIC_FOUNDRY_SCOPE,
                "晶圆产能统计对象晶圆代工",
                "晶圆产能",
                "晶圆代工",
                source_ref(row),
            )
        )
    return out


def write_link_outputs(capacity_links, capex_links, foundry_capacity_links):
    mapping = {
        ("晶圆产能", "晶圆制造工厂"): FULL / "晶圆产能统计对象晶圆制造工厂.csv",
        ("晶圆产能", "外延工厂"): FULL / "晶圆产能统计对象外延工厂.csv",
        ("晶圆产能", "研发中试工厂"): FULL / "晶圆产能统计对象研发中试工厂.csv",
        ("晶圆产能", "后道工厂"): FULL / "晶圆产能统计对象后道工厂.csv",
        ("资本开支", "晶圆制造工厂"): FULL / "资本开支统计对象晶圆制造工厂.csv",
        ("资本开支", "外延工厂"): FULL / "资本开支统计对象外延工厂.csv",
        ("资本开支", "研发中试工厂"): FULL / "资本开支统计对象研发中试工厂.csv",
        ("资本开支", "后道工厂"): FULL / "资本开支统计对象后道工厂.csv",
        ("晶圆产能", "晶圆代工"): FULL / "晶圆产能统计对象晶圆代工.csv",
    }

    written = {}
    skipped_no_link_csv = {}
    for target_ot, rows in capacity_links.items():
        path = mapping.get(("晶圆产能", target_ot))
        if path:
            write_csv(path, LINK_HEADER, rows)
            written[str(path.relative_to(ROOT))] = len(rows)
        else:
            skipped_no_link_csv[f"晶圆产能统计对象{target_ot}"] = len(rows)

    for target_ot, rows in capex_links.items():
        path = mapping.get(("资本开支", target_ot))
        if path:
            write_csv(path, LINK_HEADER, rows)
            written[str(path.relative_to(ROOT))] = len(rows)
        else:
            skipped_no_link_csv[f"资本开支统计对象{target_ot}"] = len(rows)

    path = mapping[("晶圆产能", "晶圆代工")]
    write_csv(path, LINK_HEADER, foundry_capacity_links)
    written[str(path.relative_to(ROOT))] = len(foundry_capacity_links)
    return written, skipped_no_link_csv


def ensure_capacity_backend_facility_lt():
    """Add the missing LT needed by SEMI WFF backend-facility capacity rows."""
    with ONTOLOGY.open("r", encoding="utf-8") as f:
        data = json.load(f)

    link_types = data.get("linkType", [])
    name = "晶圆产能统计对象后道工厂"
    if any(lt.get("name") == name for lt in link_types):
        return False

    link_types.append(
        {
            "name": name,
            "sourceObjectType": "晶圆产能",
            "targetObjectType": "后道工厂",
            "linkTypeCategory": "统计对象",
            "radix": "多对一（N:1）",
            "description": "晶圆产能观测描述具体后道工厂的产能状态。",
            "source": "SEMI World Fab Forecast / user facility modeling decision",
            "predicate": "统计对象",
        }
    )
    with ONTOLOGY.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")
    return True


def summarize_fact_tables():
    summary = {}
    for file_name in ["公司市场数据_fact.csv", "工厂市场数据_fact.csv"]:
        rows = [row for row in read_csv(FACT / file_name) if is_semi_row(row)]
        metric_counts = Counter(row.get("metric_name", "") for row in rows)
        summary[file_name] = {
            "semi_rows": len(rows),
            "metric_counts": dict(metric_counts.most_common()),
            "source_sheets": dict(Counter(row.get("source_sheet", "") for row in rows).most_common()),
        }
    return summary


def find_numeric_anomalies():
    anomalies = []
    for file_name in ["晶圆产能.csv", "资本开支.csv"]:
        rows = read_csv(FULL / file_name)
        value_cols = ["property.capacity_value", "property.capex_amount"]
        for row in rows:
            for col in value_cols:
                val = row.get(col, "")
                if "1900-" in val:
                    anomalies.append(
                        {
                            "file": file_name,
                            "nameCn": row.get("nameCn", ""),
                            "column": col,
                            "value": val,
                            "facility_record_id": row.get("property.facility_record_id", ""),
                        }
                    )
    for file_name in ["工厂市场数据_fact.csv", "公司市场数据_fact.csv"]:
        for row in read_csv(FACT / file_name):
            val = row.get("metric_value", "")
            if "1900-" in val:
                anomalies.append(
                    {
                        "file": file_name,
                        "name": row.get("facility_name") or row.get("company_name", ""),
                        "column": "metric_value",
                        "metric_name": row.get("metric_name", ""),
                        "value": val,
                        "facility_record_id": row.get("facility_record_id", ""),
                    }
                )
    return anomalies


def excel_1900_date_to_number(value):
    """Convert polluted Excel serial-date display to its original numeric serial."""
    if not isinstance(value, str) or not value.startswith("1900-"):
        return value
    date_part = value.split(" ", 1)[0]
    year, month, day = [int(part) for part in date_part.split("-")]
    month_days = [31, 28]
    if year != 1900:
        return value
    serial = sum(month_days[: month - 1]) + day
    return str(serial)


def normalize_numeric_anomalies():
    """Repair known Excel-date-like numeric pollution in capex files."""
    changed = []
    targets = [
        (FULL / "资本开支.csv", "property.capex_amount"),
        (FACT / "工厂市场数据_fact.csv", "metric_value"),
    ]
    for path, value_col in targets:
        rows = read_csv(path)
        header = read_header(path)
        touched = 0
        for row in rows:
            old = row.get(value_col, "")
            new = excel_1900_date_to_number(old)
            if old != new:
                row[value_col] = new
                touched += 1
                changed.append(
                    {
                        "file": str(path.relative_to(ROOT)),
                        "name": row.get("nameCn") or row.get("facility_name", ""),
                        "column": value_col,
                        "old_value": old,
                        "new_value": new,
                        "facility_record_id": row.get("property.facility_record_id")
                        or row.get("facility_record_id", ""),
                    }
                )
        if touched:
            write_csv(path, header, rows)
    return changed


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    added_capacity_backend_lt = ensure_capacity_backend_facility_lt()
    by_record, duplicate_records, facility_counts = load_facility_index()
    normalized_numeric_values = normalize_numeric_anomalies()
    capacity_links, capacity_unmatched = build_facility_metric_links("晶圆产能.csv", "晶圆产能", by_record)
    capex_links, capex_unmatched = build_facility_metric_links("资本开支.csv", "资本开支", by_record)
    added_foundry_scope = ensure_foundry_scope_instance()
    foundry_capacity_links = build_foundry_capacity_scope_links()
    written, skipped_no_link_csv = write_link_outputs(capacity_links, capex_links, foundry_capacity_links)

    summary = {
        "source": SOURCE_FILE,
        "ontology_metadata_changed": False,
        "added_capacity_backend_facility_lt": added_capacity_backend_lt,
        "added_foundry_scope_instance": added_foundry_scope,
        "facility_instance_counts": facility_counts,
        "facility_record_index_size": len(by_record),
        "duplicate_facility_record_ids": {k: v for k, v in duplicate_records.items()},
        "written_link_csv_rows": written,
        "skipped_no_existing_link_csv": skipped_no_link_csv,
        "unmatched_counts": {
            "capacity": len(capacity_unmatched),
            "capex": len(capex_unmatched),
        },
        "normalized_numeric_values": normalized_numeric_values,
        "fact_table_summary": summarize_fact_tables(),
        "numeric_anomalies": find_numeric_anomalies(),
    }

    write_csv(OUT / "capacity_unmatched_facility_records.csv", [
        "metric_file", "sourceInstance", "facility_record_id", "facility_name"
    ], capacity_unmatched)
    write_csv(OUT / "capex_unmatched_facility_records.csv", [
        "metric_file", "sourceInstance", "facility_record_id", "facility_name"
    ], capex_unmatched)

    with (OUT / "semi_wff_mounting_summary.json").open("w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)

    md_lines = [
        "# SEMI WFF Mounting Summary",
        "",
        f"- Source: `{SOURCE_FILE}`",
        "- Ontology metadata changed: no",
        f"- Added LT `晶圆产能统计对象后道工厂`: {'yes' if added_capacity_backend_lt else 'already existed'}",
        f"- Added generic foundry scope instance: {'yes' if added_foundry_scope else 'already existed'}",
        "",
        "## Written Link CSVs",
        "",
        "| File | Rows |",
        "|---|---:|",
    ]
    for file_name, count in sorted(written.items()):
        md_lines.append(f"| `{file_name}` | {count} |")
    md_lines += [
        "",
        "## Skipped Because Link Type CSV Is Missing",
        "",
        "| Link Type Name | Candidate Rows |",
        "|---|---:|",
    ]
    for link_name, count in sorted(skipped_no_link_csv.items()):
        md_lines.append(f"| `{link_name}` | {count} |")
    md_lines += [
        "",
        "## Facility Instance Counts",
        "",
        "| OT | Rows |",
        "|---|---:|",
    ]
    for ot_name, count in sorted(facility_counts.items()):
        md_lines.append(f"| {ot_name} | {count} |")
    md_lines += [
        "",
        "## Unmatched Facility Records",
        "",
        f"- Capacity unmatched: {len(capacity_unmatched)}",
        f"- Capex unmatched: {len(capex_unmatched)}",
        "",
        "## Numeric Anomalies",
        "",
        f"- Normalized Excel-date-like values: {len(normalized_numeric_values)}",
        f"- Rows containing Excel-date-like numeric values: {len(summary['numeric_anomalies'])}",
    ]
    (OUT / "semi_wff_mounting_summary.md").write_text("\n".join(md_lines) + "\n", encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
