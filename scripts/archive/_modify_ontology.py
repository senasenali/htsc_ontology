import json
import sys

ONTOLOGY_FILE = '/Users/loopyotter/Documents/ontology_250525/semiconductor_ontology_v3_with_instances.json'

with open(ONTOLOGY_FILE, 'r', encoding='utf-8') as f:
    data = json.load(f)

# OTs to delete
ot_to_delete = {'光互连技术', '特色工艺平台', 'CMP技术'}

# ── objectType modifications ──
new_object_types = []
for ot in data['objectType']:
    name = ot.get('nameCn', '')

    # Delete OTs
    if name in ot_to_delete:
        print(f"  DELETE OT: {name}")
        continue

    # Rename 指令集架构世代 → 指令集架构, parent → 技术路线
    if name == '指令集架构世代':
        print(f"  RENAME OT: {name} → 指令集架构, parent → 技术路线")
        ot['nameCn'] = '指令集架构'
        ot['parentObjectTypeName'] = '技术路线'

    # 互联架构 parent → 技术路线
    if name == '互联架构':
        print(f"  UPDATE OT: {name} parent → 技术路线")
        ot['parentObjectTypeName'] = '技术路线'

    new_object_types.append(ot)

# Add 底衬技术 OT
new_ot = {
    "nameCn": "底衬技术",
    "nameEn": "substrate_technology",
    "parentObjectTypeName": "技术能力层",
    "properties": [
        {"propertyCn": "底衬类型", "propertyEn": "substrate_type", "dataType": "string", "unit": ""},
        {"propertyCn": "绝缘层材料", "propertyEn": "insulator_material", "dataType": "string", "unit": ""},
        {"propertyCn": "绝缘层厚度", "propertyEn": "insulator_thickness", "dataType": "string", "unit": "nm"}
    ],
    "description": "半导体衬底技术，包括体硅、SOI等各类衬底方案",
    "type": "实体对象类型",
    "source": "SEMI"
}
print(f"  ADD OT: 底衬技术 (parent: 技术能力层)")
new_object_types.append(new_ot)

data['objectType'] = new_object_types

# ── instance modifications ──
# Delete instances of removed OTs
instances_to_remove_names = set()
new_instances = []
for inst in data['instance']:
    otype = inst.get('objectTypeName', '')
    if otype in ot_to_delete:
        instances_to_remove_names.add(inst.get('nameCn', ''))
        print(f"  DELETE INSTANCE: {inst.get('nameCn','')} ({otype})")
        continue
    new_instances.append(inst)

# Move SOI and FD-SOI to 底衬技术
for inst in new_instances:
    if inst.get('nameCn', '') in ('SOI', 'FD-SOI'):
        old_type = inst.get('objectTypeName', '')
        inst['objectTypeName'] = '底衬技术'
        print(f"  MOVE INSTANCE: {inst.get('nameCn','')} ({old_type} → 底衬技术)")

data['instance'] = new_instances

# ── linkType modifications ──
# Delete linkTypes referencing deleted OTs
new_link_types = []
for lt in data['linkType']:
    src = lt.get('sourceObjectType', '')
    tgt = lt.get('targetObjectType', '')
    if src in ot_to_delete or tgt in ot_to_delete:
        print(f"  DELETE LT: {lt.get('name','')}")
        continue
    new_link_types.append(lt)

# Update linkType for 指令集架构 rename
for lt in new_link_types:
    if lt.get('targetObjectType', '') == '指令集架构世代':
        lt['targetObjectType'] = '指令集架构'
        print(f"  UPDATE LT target: {lt.get('name','')} (target → 指令集架构)")
    if lt.get('name', '') == 'CPU微架构世代对应指令集架构世代':
        lt['name'] = 'CPU微架构世代对应指令集架构'
        print(f"  UPDATE LT name: {lt.get('name','')}")

# Add new linkType for 底衬技术
new_lt = {
    "name": "晶体管架构采用底衬技术",
    "sourceObjectType": "晶体管架构",
    "targetObjectType": "底衬技术",
    "linkTypeCategory": "采用",
    "redix": "多对多（N:N）"
}
print(f"  ADD LT: 晶体管架构采用底衬技术")
new_link_types.append(new_lt)

data['linkType'] = new_link_types

# ── Write ──
with open(ONTOLOGY_FILE, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("\n✅ All modifications completed successfully!")
