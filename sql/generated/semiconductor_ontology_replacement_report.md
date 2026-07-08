# Semiconductor Ontology Replacement Dry Run

- Source JSON: `data/ontology/semiconductor_ontology_ot_lt_with_relation_objects.json`
- Target project_id: `project_1780997325389`
- Object types: 239
- Entity object types: 203
- Relation object types: 36
- Properties: 1329
- Link types: 1357

## Validation

- Duplicate object Chinese names: 0
- Duplicate generated object IDs: 0
- Unresolved parents: 0
- Unresolved link endpoints: 0
- Missing source nameEn: 0

## Missing nameEn Handling

No missing `nameEn` values.

## Execute After Review

```bash
mysql -u root -p12345678 ontology < sql/generated/replace_semiconductor_ontology_metadata.sql
```

Then verify the API:

```bash
curl -s "http://localhost:3001/api/ontology?projectId=project_1780997325389"
```
