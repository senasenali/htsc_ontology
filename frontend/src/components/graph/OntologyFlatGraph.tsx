import React, { useMemo, useCallback, useEffect, useState, useRef } from 'react';
import { OntologyData, ObjectType, LinkType } from '@/src/store/ontologyStore';
import {
  ReactFlow, MiniMap, Controls, Background,
  useNodesState, useEdgesState, Handle, Position,
  NodeProps, Edge, Panel, Node, NodeResizer,
} from '@xyflow/react';
import '@xyflow/react/dist/style.css';
import { Database, Key, Sparkles } from 'lucide-react';
import { Sheet, SheetContent, SheetTrigger } from '@/src/components/ui/sheet';
import { AiStudio } from '@/src/pages/AiStudio';
import { cn } from '@/src/lib/utils';
import { api } from '@/src/api/client';

// ── Layer definitions ─────────────────────────────────────────────────────────

type LayerId = 'company' | 'finance' | 'industry' | 'relation';

const LAYER_COLORS: Record<LayerId, string> = {
  company: '#3b82f6',
  finance: '#f59e0b',
  industry: '#10b981',
  relation: '#8b5cf6',
};

const TECH_ROUTE_COLOR = '#0891b2';

export const LAYER_LABELS: Record<LayerId, string> = {
  company: '公司层',
  finance: '经营财务指标层',
  industry: '产业链层',
  relation: '关系对象层',
};

export const LAYER_ORDER: LayerId[] = ['company', 'finance', 'industry', 'relation'];

export function classifyToLayer(ot: ObjectType): LayerId {
  if (ot.objectTypeCategory === 'relation') return 'relation';
  if (ot.id === 'company_entity' || ot.id === 'company') return 'company';
  if (['business_perspective', 'financial_perspective'].includes(ot.id)) return 'finance';
  return 'industry';
}

export function getLayerColor(layer: LayerId): string {
  return LAYER_COLORS[layer];
}

// ── Layout Constants ──────────────────────────────────────────────────────────

const NODE_WIDTH = 150;
const NODE_HEIGHT_BASE = 50;
const NODE_HEIGHT_PER_PROP = 12;
const LAYER_Y_GAP = 240;
const MARGIN_LEFT = 80;
const MARGIN_TOP = 60;
const ROOT_GROUP_GAP_X = 80;
const ROOT_GROUP_GAP_Y = 48;

const GROUP_MIN_WIDTH = 260;
const GROUP_TITLE_HEIGHT = 30;
const GROUP_PADDING = 16;
const GROUP_CHILD_GAP = 24;

interface SavedLayout {
  x: number;
  y: number;
  width?: number;
  height?: number;
}

function getNodeHeight(ot: ObjectType): number {
  return NODE_HEIGHT_BASE + Math.min(ot.properties.length, 2) * NODE_HEIGHT_PER_PROP;
}

function getParentFlowProps(parentObjectType?: string | null) {
  return parentObjectType
    ? { parentId: parentObjectType, extent: 'parent' as const }
    : {};
}

function getSavedGroupSize(saved: SavedLayout | undefined, autoSize: { width: number; height: number }) {
  return {
    width: Math.max(saved?.width ?? 0, autoSize.width),
    height: Math.max(saved?.height ?? 0, autoSize.height),
  };
}

function sortByParentDepth(objectTypes: ObjectType[], allObjectTypes: ObjectType[]): ObjectType[] {
  const byId = new Map(allObjectTypes.map(ot => [ot.id, ot]));
  const depthCache = new Map<string, number>();

  const getDepth = (ot: ObjectType): number => {
    if (depthCache.has(ot.id)) return depthCache.get(ot.id)!;

    const visited = new Set<string>();
    let depth = 0;
    let current = ot;
    while (current.parentObjectType && !visited.has(current.id)) {
      visited.add(current.id);
      const parent = byId.get(current.parentObjectType);
      if (!parent) break;
      depth += 1;
      current = parent;
    }

    depthCache.set(ot.id, depth);
    return depth;
  };

  return [...objectTypes].sort((a, b) => getDepth(a) - getDepth(b));
}

interface GroupLayout {
  width: number;
  height: number;
  positions: Map<string, { x: number; y: number }>;
}

function calculateGroupLayout(
  parentId: string,
  objectTypes: ObjectType[],
  visibleSet: Set<string>,
  nodeHeightMap: Map<string, number>,
  cache?: Map<string, GroupLayout>
): GroupLayout {
  if (cache?.has(parentId)) return cache.get(parentId)!;

  const hasChildren = (id: string) =>
    objectTypes.some(ot => ot.parentObjectType === id && visibleSet.has(ot.id));

  const children = objectTypes.filter(ot => ot.parentObjectType === parentId && visibleSet.has(ot.id));

  // Recursively compute layouts for child groups first
  const childInfos = children.map(child => {
    if (hasChildren(child.id)) {
      const layout = calculateGroupLayout(child.id, objectTypes, visibleSet, nodeHeightMap, cache);
      return { id: child.id, width: layout.width, height: layout.height, isGroup: true };
    }
    return {
      id: child.id,
      width: NODE_WIDTH,
      height: nodeHeightMap.get(child.id) || NODE_HEIGHT_BASE,
      isGroup: false,
    };
  });

  // Masonry-like column layout inside group: children are placed into columns,
  // with each column stacking independently. This keeps every child (leaf or
  // nested group) strictly inside the parent group's bounds while still packing
  // tightly.
  const cols = Math.min(Math.max(Math.ceil(Math.sqrt(children.length)), 1), 6);
  const positions = new Map<string, { x: number; y: number }>();

  type Col = { infos: typeof childInfos; height: number; width: number };
  const columns: Col[] = Array.from({ length: cols }, () => ({ infos: [], height: GROUP_TITLE_HEIGHT + GROUP_PADDING, width: 0 }));

  childInfos.forEach(info => {
    const shortest = columns.reduce((min, col) => (col.height < min.height ? col : min), columns[0]);
    shortest.infos.push(info);
    shortest.height += info.height + GROUP_CHILD_GAP;
    shortest.width = Math.max(shortest.width, info.width);
  });

  let currentX = GROUP_PADDING;
  columns.forEach(col => {
    let currentY = GROUP_TITLE_HEIGHT + GROUP_PADDING;
    col.infos.forEach(info => {
      positions.set(info.id, { x: currentX, y: currentY });
      currentY += info.height + GROUP_CHILD_GAP;
    });
    currentX += col.width + GROUP_CHILD_GAP;
  });

  const width = Math.max(GROUP_MIN_WIDTH, currentX + GROUP_PADDING - GROUP_CHILD_GAP);
  const height = Math.max(...columns.map(c => c.height)) + GROUP_PADDING;
  const result = { width, height, positions };
  cache?.set(parentId, result);
  return result;
}

function calculateGroupSize(
  parentId: string,
  objectTypes: ObjectType[],
  visibleSet: Set<string>,
  nodeHeightMap: Map<string, number>
): { width: number; height: number } {
  const layout = calculateGroupLayout(parentId, objectTypes, visibleSet, nodeHeightMap);
  return { width: layout.width, height: layout.height };
}

// ── Custom Nodes ──────────────────────────────────────────────────────────────

const GroupNode = ({ id, data, selected }: NodeProps) => {
  const color = data.color as string || '#3b82f6';
  const isOperationMode = data.isOperationMode as boolean ?? true;
  const onResizeEnd = data.onResizeEnd as ((nodeId: string, w: number, h: number) => void) | undefined;
  return (
    <div
      className="rounded-lg border-2"
      style={{
        width: '100%',
        height: '100%',
        backgroundColor: color + '06',
        borderColor: color + '35',
      }}
    >
      <NodeResizer
        minWidth={GROUP_MIN_WIDTH}
        minHeight={120}
        isVisible={selected && isOperationMode}
        lineStyle={{ borderColor: color + '80' }}
        handleStyle={{ backgroundColor: color, borderColor: 'white' }}
        onResizeEnd={(_event, params) => {
          if (onResizeEnd) {
            onResizeEnd(id, params.width, params.height);
          }
        }}
      />
      <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" style={{ background: color }} />
      <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" style={{ background: color }} />
      <div
        className="px-3 py-1.5 text-xs font-bold rounded-t-lg truncate"
        style={{
          backgroundColor: color + '16',
          color: color,
          borderBottom: `1px solid ${color}28`,
        }}
      >
        {data.label as string}
      </div>
      <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" style={{ background: color }} />
      <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" style={{ background: color }} />
    </div>
  );
};

const ObjectTypeNode = ({ data }: NodeProps) => {
  const color = data.color as string || '#3b82f6';
  const properties = data.properties as any[] || [];
  const selected = data.selected as boolean;
  const status = data.status as string;
  const isPending = status === 'pending';
  const compact = (data.compact as boolean) ?? false;
  const showAll = (data.showAllProperties as boolean) ?? false;
  const visibleProps = showAll ? properties : properties.slice(0, 2);

  return (
    <div
      className={cn("shadow rounded-lg transition-all relative min-w-[118px] max-w-[150px]", compact && "min-h-[50px]")}
      style={{
        borderWidth: 1.5,
        borderStyle: isPending ? 'dashed' : 'solid',
        borderColor: isPending ? '#9ca3af' : (selected ? color : '#e2e8f0'),
        boxShadow: selected ? `0 0 0 3px ${color}33` : undefined,
        backgroundColor: isPending ? '#f9fafb' : 'white',
      }}
    >
      {isPending && (
        <div className="absolute -top-2 -right-2 bg-amber-100 text-amber-700 text-[9px] px-1.5 py-0.5 rounded-full border border-amber-200 font-medium">
          待审核
        </div>
      )}
      <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" style={{ background: color }} />
      <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" style={{ background: color }} />

      <div className="flex items-center gap-1.5 cursor-pointer px-2 py-1.5" style={{ borderBottom: '1px solid #f1f5f9', backgroundColor: color + '08' }}>
        <div className="w-5 h-5 rounded flex items-center justify-center shrink-0" style={{ backgroundColor: color + '18' }}>
          <Database className="w-3 h-3 shrink-0" style={{ color }} />
        </div>
        <div className="flex-1 min-w-0">
          <div className="font-bold text-slate-900 truncate text-[10px]">{data.label as string}</div>
          <div className="text-slate-500 font-mono truncate text-[8px]">{data.id as string}</div>
        </div>
      </div>

      {!compact && (
        <div className="px-2 py-1">
          <div className="space-y-0">
            {visibleProps.map((p: any) => (
              <div key={p.id} className="flex items-center gap-1 text-[9px] py-0.5">
                {!!p.isPrimaryKey && <Key className="w-2 h-2 text-amber-500 shrink-0" />}
                <span className="text-slate-600 truncate flex-1">{p.name}</span>
                <span className="text-slate-400 font-mono text-[8px] shrink-0 bg-slate-50 px-1 rounded">{p.type}</span>
              </div>
            ))}
            {!showAll && properties.length > 2 && (
              <div className="text-[8px] text-slate-400 italic pt-0.5">+{properties.length - 2} 更多</div>
            )}
          </div>
        </div>
      )}

      <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" style={{ background: color }} />
      <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" style={{ background: color }} />
    </div>
  );
};

const nodeTypes = { objectType: ObjectTypeNode, group: GroupNode };

// ── Topological Sort for industry chain ───────────────────────────────────────

function computeIndustryRanks(
  industryIds: string[],
  linkTypes: LinkType[]
): Map<string, number> {
  const industrySet = new Set(industryIds);
  const ranks = new Map<string, number>();

  const inDegree = new Map<string, number>();
  const outEdges = new Map<string, string[]>();

  industryIds.forEach(id => {
    inDegree.set(id, 0);
    outEdges.set(id, []);
  });

  linkTypes.forEach(lt => {
    if (!industrySet.has(lt.sourceObjectId) || !industrySet.has(lt.targetObjectId)) return;
    const cat = lt.linkCategory || '';
    if (cat !== '是...原材料' && cat !== '组成') return;
    outEdges.get(lt.targetObjectId)?.push(lt.sourceObjectId);
    inDegree.set(lt.sourceObjectId, (inDegree.get(lt.sourceObjectId) || 0) + 1);
  });

  const queue: string[] = [];
  industryIds.forEach(id => {
    if ((inDegree.get(id) || 0) === 0) queue.push(id);
  });

  let currentRank = 0;
  while (queue.length > 0) {
    const levelSize = queue.length;
    for (let i = 0; i < levelSize; i++) {
      const node = queue.shift()!;
      if (ranks.has(node)) continue;
      ranks.set(node, currentRank);
      (outEdges.get(node) || []).forEach(target => {
        const d = (inDegree.get(target) || 1) - 1;
        inDegree.set(target, d);
        if (d === 0) queue.push(target);
      });
    }
    currentRank++;
  }

  industryIds.forEach(id => {
    if (!ranks.has(id)) ranks.set(id, currentRank++);
  });

  return ranks;
}

// ── Semiconductor-specific flat layout ───────────────────────────────────────

function isSemiconductorProject(allObjectTypes: ObjectType[]): boolean {
  return allObjectTypes.some(ot => ot.id === 'semiconductor_industry_chain');
}

function getNodeColor(ot: ObjectType, allObjectTypes: ObjectType[]): string {
  // Semiconductor-specific coloring: tech route subtree is cyan, company is blue,
  // industry chain subtree is green, relations are purple.
  if (ot.id === 'technology_route' || ot.id === 'company' || ot.id === 'company_entity') {
    return ot.id === 'technology_route' ? TECH_ROUTE_COLOR : getLayerColor('company');
  }
  let current: ObjectType | undefined = ot;
  const visited = new Set<string>();
  while (current?.parentObjectType && !visited.has(current.id)) {
    visited.add(current.id);
    if (current.parentObjectType === 'technology_route') return TECH_ROUTE_COLOR;
    current = allObjectTypes.find(o => o.id === current?.parentObjectType);
  }
  return getLayerColor(classifyToLayer(ot));
}

function layoutSemiconductorGraph(
  allObjectTypes: ObjectType[],
  visibleObjectTypes: ObjectType[],
  _savedLayouts: Map<string, SavedLayout>,
  isOperationMode: boolean,
  compactMode: boolean,
  onGroupResizeEnd?: (nodeId: string, width: number, height: number) => void
) {
  const visibleSet = new Set(visibleObjectTypes.map(ot => ot.id));
  const nodeHeightMap = new Map<string, number>();
  visibleObjectTypes.forEach(ot => nodeHeightMap.set(ot.id, getNodeHeight(ot)));

  const hasChildren = (id: string) =>
    allObjectTypes.some(ot => ot.parentObjectType === id && visibleSet.has(ot.id));

  const roots = visibleObjectTypes.filter(ot => !ot.parentObjectType);
  const companyRoot = roots.find(ot => ot.id === 'company' || ot.id === 'company_entity');
  const industryRoot = roots.find(ot => ot.id === 'semiconductor_industry_chain');
  const techRouteRoot = roots.find(ot => ot.id === 'technology_route');

  // Calculate nested group layouts for roots that have children
  const groupLayouts = new Map<string, GroupLayout>();
  visibleObjectTypes.filter(ot => hasChildren(ot.id)).forEach(group => {
    groupLayouts.set(group.id, calculateGroupLayout(group.id, allObjectTypes, visibleSet, nodeHeightMap, groupLayouts));
  });

  const positions = new Map<string, { x: number; y: number }>();

  // Triangular arrangement:
  //   [company]                    [tech route]
  //        [      semiconductor industry chain      ]
  const ROOT_GAP_X = 40;
  const ROOT_GAP_Y = 40;

  const companySize = companyRoot
    ? { width: NODE_WIDTH, height: nodeHeightMap.get(companyRoot.id) || NODE_HEIGHT_BASE }
    : { width: 0, height: 0 };
  const industrySize = industryRoot
    ? (groupLayouts.get(industryRoot.id) || { width: GROUP_MIN_WIDTH, height: 200 })
    : { width: 0, height: 0 };
  const techRouteSize = techRouteRoot
    ? (groupLayouts.get(techRouteRoot.id) || { width: GROUP_MIN_WIDTH, height: 200 })
    : { width: 0, height: 0 };

  const topRowHeight = Math.max(companySize.height, techRouteSize.height, 120);

  // Center the industry chain; place company/tech route above-left and above-right
  const totalTopWidth = companySize.width + ROOT_GAP_X + industrySize.width + ROOT_GAP_X + techRouteSize.width;
  const leftOriginX = MARGIN_LEFT;

  if (companyRoot) {
    positions.set(companyRoot.id, { x: leftOriginX, y: MARGIN_TOP });
  }
  if (techRouteRoot) {
    positions.set(techRouteRoot.id, { x: leftOriginX + totalTopWidth - techRouteSize.width, y: MARGIN_TOP });
  }
  if (industryRoot) {
    const centerX = leftOriginX + totalTopWidth / 2;
    positions.set(industryRoot.id, { x: centerX - industrySize.width / 2, y: MARGIN_TOP + topRowHeight + ROOT_GAP_Y });
  }

  // Any other root (unlikely in semiconductor) falls back to a row below the industry chain
  const otherRoots = roots.filter(r => r !== companyRoot && r !== industryRoot && r !== techRouteRoot);
  let otherX = MARGIN_LEFT;
  const otherY = MARGIN_TOP + topRowHeight + ROOT_GAP_Y + industrySize.height + ROOT_GAP_Y;
  otherRoots.forEach(ot => {
    positions.set(ot.id, { x: otherX, y: otherY });
    otherX += (groupLayouts.get(ot.id)?.width || NODE_WIDTH) + ROOT_GAP_X;
  });

  const nodes: any[] = [];
  const groups = sortByParentDepth(visibleObjectTypes.filter(ot => hasChildren(ot.id)), allObjectTypes);
  const leaves = sortByParentDepth(visibleObjectTypes.filter(ot => !hasChildren(ot.id)), allObjectTypes);

  groups.forEach(ot => {
    const autoPos = ot.parentObjectType ? groupLayouts.get(ot.parentObjectType)?.positions.get(ot.id) : positions.get(ot.id);
    const pos = autoPos || { x: 0, y: 0 };
    const autoSize = groupLayouts.get(ot.id) || { width: GROUP_MIN_WIDTH, height: 120 };
    const color = getNodeColor(ot, allObjectTypes);
    nodes.push({
      id: ot.id,
      type: 'group',
      position: pos,
      ...getParentFlowProps(ot.parentObjectType),
      style: {
        width: autoSize.width,
        height: autoSize.height,
        backgroundColor: color + '06',
        borderColor: color + '35',
      },
      data: {
        label: ot.name,
        color,
        isOperationMode: isOperationMode,
        onResizeEnd: onGroupResizeEnd,
      },
    });
  });

  leaves.forEach(ot => {
    const autoPos = ot.parentObjectType ? groupLayouts.get(ot.parentObjectType)?.positions.get(ot.id) : positions.get(ot.id);
    const pos = autoPos || { x: 0, y: 0 };
    const color = getNodeColor(ot, allObjectTypes);
    nodes.push({
      id: ot.id,
      type: 'objectType',
      position: pos,
      ...getParentFlowProps(ot.parentObjectType),
      style: { width: NODE_WIDTH },
      data: {
        label: ot.name,
        id: ot.id,
        properties: ot.properties,
        color,
        selected: false,
        status: ot.status,
        showAllProperties: false,
        compact: compactMode,
      },
    });
  });

  return nodes;
}

// ── Layered Layout ────────────────────────────────────────────────────────────

function layoutGraph(
  allObjectTypes: ObjectType[],
  visibleObjectTypes: ObjectType[],
  linkTypes: LinkType[],
  savedLayouts: Map<string, SavedLayout>,
  isOperationMode: boolean,
  compactMode: boolean,
  onGroupResizeEnd?: (nodeId: string, width: number, height: number) => void
) {
  if (isSemiconductorProject(allObjectTypes)) {
    return layoutSemiconductorGraph(allObjectTypes, visibleObjectTypes, savedLayouts, isOperationMode, compactMode, onGroupResizeEnd);
  }

  const visibleSet = new Set(visibleObjectTypes.map(ot => ot.id));
  const nodeHeightMap = new Map<string, number>();
  visibleObjectTypes.forEach(ot => nodeHeightMap.set(ot.id, getNodeHeight(ot)));

  const hasChildren = (id: string) =>
    allObjectTypes.some(ot => ot.parentObjectType === id && visibleSet.has(ot.id));

  const layerMap = new Map<string, LayerId>();
  visibleObjectTypes.forEach(ot => layerMap.set(ot.id, classifyToLayer(ot)));

  const rootObjectTypes = visibleObjectTypes.filter(ot => !ot.parentObjectType);

  const groupLayouts = new Map<string, GroupLayout>();
  visibleObjectTypes.filter(ot => hasChildren(ot.id)).forEach(group => {
    groupLayouts.set(group.id, calculateGroupLayout(group.id, allObjectTypes, visibleSet, nodeHeightMap, groupLayouts));
  });

  const getRootSize = (ot: ObjectType) =>
    groupLayouts.get(ot.id) || {
      width: NODE_WIDTH,
      height: nodeHeightMap.get(ot.id) || NODE_HEIGHT_BASE,
    };

  const layerGroups = new Map<LayerId, ObjectType[]>();
  LAYER_ORDER.forEach(l => layerGroups.set(l, []));
  rootObjectTypes.forEach(ot => {
    const layer = layerMap.get(ot.id) || 'industry';
    layerGroups.get(layer)?.push(ot);
  });

  const positions = new Map<string, { x: number; y: number }>();
  let currentY = MARGIN_TOP;

  LAYER_ORDER.forEach(layerId => {
    const items = layerGroups.get(layerId) || [];
    if (items.length === 0) return;

    if (layerId === 'industry') {
      const industryIds = items.map(ot => ot.id);
      const ranks = computeIndustryRanks(industryIds, linkTypes);

      const rankGroups = new Map<number, ObjectType[]>();
      items.forEach(ot => {
        const r = ranks.get(ot.id) || 0;
        if (!rankGroups.has(r)) rankGroups.set(r, []);
        rankGroups.get(r)?.push(ot);
      });

      const maxRank = Math.max(...Array.from(rankGroups.keys()), 0);
      let currentX = MARGIN_LEFT;
      let maxLayerHeight = 0;

      for (let r = 0; r <= maxRank; r++) {
        const group = rankGroups.get(r) || [];
        if (group.length === 0) continue;

        const rankWidth = Math.max(...group.map(ot => getRootSize(ot).width), NODE_WIDTH);
        let currentColumnY = currentY;

        group.forEach((ot, idx) => {
          positions.set(ot.id, { x: currentX, y: currentColumnY });
          currentColumnY += getRootSize(ot).height + ROOT_GROUP_GAP_Y;
        });

        maxLayerHeight = Math.max(maxLayerHeight, currentColumnY - currentY - ROOT_GROUP_GAP_Y);
        currentX += rankWidth + ROOT_GROUP_GAP_X;
      }
      currentY += Math.max(maxLayerHeight, 300) + LAYER_Y_GAP;
    } else {
      let currentX = MARGIN_LEFT;
      let rowHeight = 0;

      items.forEach((ot, idx) => {
        const size = getRootSize(ot);
        positions.set(ot.id, { x: currentX, y: currentY });
        currentX += size.width + ROOT_GROUP_GAP_X;
        rowHeight = Math.max(rowHeight, size.height);
      });
      currentY += Math.max(rowHeight, NODE_HEIGHT_BASE) + LAYER_Y_GAP;
    }
  });

  const nodes: any[] = [];
  const groups = sortByParentDepth(visibleObjectTypes.filter(ot => hasChildren(ot.id)), allObjectTypes);
  const leaves = sortByParentDepth(visibleObjectTypes.filter(ot => !hasChildren(ot.id)), allObjectTypes);

  groups.forEach(ot => {
    const saved = savedLayouts.get(ot.id);
    const autoPos = ot.parentObjectType ? groupLayouts.get(ot.parentObjectType)?.positions.get(ot.id) : positions.get(ot.id);
    const pos = saved || autoPos || { x: 0, y: 0 };
    const autoSize = groupLayouts.get(ot.id) || { width: GROUP_MIN_WIDTH, height: 120 };
    const layer = layerMap.get(ot.id) || 'industry';
    nodes.push({
      id: ot.id,
      type: 'group',
      position: pos,
      ...getParentFlowProps(ot.parentObjectType),
      style: {
        ...getSavedGroupSize(saved, autoSize),
        backgroundColor: getLayerColor(layer) + '06',
        borderColor: getLayerColor(layer) + '35',
      },
      data: {
        label: ot.name,
        color: getLayerColor(layer),
        isOperationMode: isOperationMode,
        onResizeEnd: onGroupResizeEnd,
      },
    });
  });

  leaves.forEach(ot => {
    const saved = savedLayouts.get(ot.id);
    const autoPos = ot.parentObjectType ? groupLayouts.get(ot.parentObjectType)?.positions.get(ot.id) : positions.get(ot.id);
    const pos = saved || autoPos || { x: 0, y: 0 };
    const layer = layerMap.get(ot.id) || 'industry';
    nodes.push({
      id: ot.id,
      type: 'objectType',
      position: pos,
      ...getParentFlowProps(ot.parentObjectType),
      style: { width: NODE_WIDTH },
      data: {
        label: ot.name,
        id: ot.id,
        properties: ot.properties,
        color: getLayerColor(layer),
        selected: false,
        status: ot.status,
        showAllProperties: false,
        compact: compactMode,
      },
    });
  });

  return nodes;
}

// ── Main Component ────────────────────────────────────────────────────────────

export interface OntologyFlatGraphProps {
  data: OntologyData;
  selectedObjectId: string | null;
  onSelectObject: (id: string | null) => void;
  categoryFilter: 'all' | 'entity';
  isOperationMode: boolean;
  compactMode?: boolean;
  resetTrigger?: number;
  aiSheetOpen: boolean;
  setAiSheetOpen: (open: boolean) => void;
  onUpdate?: (data: OntologyData) => void;
}

export const OntologyFlatGraph: React.FC<OntologyFlatGraphProps> = ({
  data,
  selectedObjectId,
  onSelectObject,
  categoryFilter,
  isOperationMode,
  compactMode = false,
  resetTrigger = 0,
  aiSheetOpen,
  setAiSheetOpen,
  onUpdate,
}) => {
  const [savedLayouts, setSavedLayouts] = useState<Map<string, SavedLayout>>(new Map());

  // Load saved layouts from backend
  useEffect(() => {
    api.getObjectTypeLayouts().then(res => {
      if (res.success && res.data) {
        const map = new Map<string, SavedLayout>();
        res.data.forEach((item: any) => {
          map.set(item.objectTypeId, { x: item.x, y: item.y, width: item.width, height: item.height });
        });
        setSavedLayouts(map);
      }
    }).catch(console.error);
  }, []);

  // Reset layouts when trigger changes
  useEffect(() => {
    if (resetTrigger > 0) {
      setSavedLayouts(new Map());
      api.saveObjectTypeLayouts([]).catch(() => {});
    }
  }, [resetTrigger]);

  const visibleObjectTypes = useMemo(() =>
    data.objectTypes.filter(ot => {
      if (categoryFilter === 'entity' && ot.objectTypeCategory === 'relation') return false;
      return true;
    }),
  [data.objectTypes, categoryFilter]);

  const saveTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const pendingSavesRef = useRef<Map<string, SavedLayout>>(new Map());

  const flushSaves = useCallback(() => {
    if (saveTimerRef.current) {
      clearTimeout(saveTimerRef.current);
    }
    saveTimerRef.current = setTimeout(() => {
      const layouts = Array.from(pendingSavesRef.current.entries()).map(([objectTypeId, layout]) => ({
        objectTypeId,
        x: layout.x,
        y: layout.y,
        width: layout.width,
        height: layout.height,
      }));
      api.saveObjectTypeLayouts(layouts).catch(console.error);
      pendingSavesRef.current.clear();
    }, 500);
  }, []);

  const handleGroupResizeEnd = useCallback((nodeId: string, width: number, height: number) => {
    const existing = pendingSavesRef.current.get(nodeId) || {} as SavedLayout;
    pendingSavesRef.current.set(nodeId, { ...existing, width, height });
    flushSaves();
  }, [flushSaves]);

  const initialNodes = useMemo(() => {
    return layoutGraph(data.objectTypes, visibleObjectTypes, data.linkTypes, savedLayouts, isOperationMode, compactMode, handleGroupResizeEnd);
  }, [data.objectTypes, visibleObjectTypes, data.linkTypes, savedLayouts, isOperationMode, compactMode, handleGroupResizeEnd]);

  const initialEdges: Edge[] = useMemo(() => {
    const edges: Edge[] = [];

    const getColor = (id: string): string => {
      const ot = data.objectTypes.find(o => o.id === id);
      return ot ? getNodeColor(ot, data.objectTypes) : getLayerColor('industry');
    };

    const isHiddenByCategory = (id: string) => {
      if (categoryFilter !== 'entity') return false;
      const ot = data.objectTypes.find(o => o.id === id);
      return ot?.objectTypeCategory === 'relation';
    };

    data.linkTypes.forEach(lt => {
      if (isHiddenByCategory(lt.sourceObjectId) || isHiddenByCategory(lt.targetObjectId)) return;
      const src = lt.sourceObjectId;
      const tgt = lt.targetObjectId;
      if (src && tgt && src !== tgt) {
        const isPending = lt.status === 'pending';
        const cat = lt.linkCategory || '';
        const srcColor = getColor(lt.sourceObjectId);
        const tgtColor = getColor(lt.targetObjectId);

        let edgeColor: string;
        let sourceHandle: string | undefined;
        let targetHandle: string | undefined;

        if (cat === '是...原材料' || cat === '组成') {
          edgeColor = getLayerColor('industry');
          sourceHandle = 'right';
          targetHandle = 'left';
        } else if (cat === '组成项') {
          edgeColor = getLayerColor('relation');
          sourceHandle = 'bottom';
          targetHandle = 'top';
        } else if (cat === '描述') {
          edgeColor = getLayerColor('finance');
          sourceHandle = 'bottom';
          targetHandle = 'top';
        } else if (srcColor !== tgtColor) {
          edgeColor = '#94a3b8';
          sourceHandle = 'bottom';
          targetHandle = 'top';
        } else {
          edgeColor = srcColor;
        }

        if (isPending) edgeColor = '#9ca3af';

        edges.push({
          id: lt.id,
          source: src,
          target: tgt,
          sourceHandle,
          targetHandle,
          type: 'default',
          label: `${lt.name} (${lt.cardinality})${isPending ? ' [待审核]' : ''}`,
          animated: false,
          style: {
            stroke: edgeColor,
            strokeWidth: 2,
            opacity: 0.7,
            strokeDasharray: isPending ? '5,5' : undefined,
          },
          labelStyle: { fill: isPending ? '#9ca3af' : '#475569', fontWeight: 500, fontSize: 11 },
          labelBgStyle: { fill: '#ffffff', fillOpacity: 0.95 },
          labelBgPadding: [6, 3] as [number, number],
          labelBgBorderRadius: 4,
        });
      }
    });

    return edges;
  }, [data.linkTypes, data.objectTypes, categoryFilter]);

  const [nodes, setNodes, _onNodesChange] = useNodesState(initialNodes);
  const allEdgesRef = useRef<Edge[]>([]);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);

  useEffect(() => {
    setNodes(initialNodes);
    allEdgesRef.current = initialEdges;
  }, [initialNodes, setNodes]);

  useEffect(() => {
    setNodes(nds =>
      nds.map(n => ({
        ...n,
        data: { ...n.data, selected: n.id === selectedObjectId },
      }))
    );
    setEdges(selectedObjectId
      ? allEdgesRef.current.filter(e => e.source === selectedObjectId || e.target === selectedObjectId)
      : []
    );
  }, [selectedObjectId, setNodes, setEdges]);

  const onNodeClick = useCallback((_event: any, node: any) => {
    onSelectObject(selectedObjectId === node.id ? null : node.id);
  }, [onSelectObject, selectedObjectId]);

  const onPaneClick = useCallback(() => {
    onSelectObject(null);
  }, [onSelectObject]);

  const onNodeDragStop = useCallback((_event: any, node: Node) => {
    const update: SavedLayout = { x: node.position.x, y: node.position.y };
    setSavedLayouts(prev => {
      const next = new Map(prev);
      const existing = next.get(node.id) || { x: 0, y: 0 };
      next.set(node.id, { ...existing, ...update });
      return next;
    });
    const existing = pendingSavesRef.current.get(node.id) || {} as SavedLayout;
    pendingSavesRef.current.set(node.id, { ...existing, ...update });
    flushSaves();
  }, [flushSaves]);

  const onNodesChange = useCallback((changes: any[]) => {
    _onNodesChange(changes);
  }, [_onNodesChange]);

  return (
    <div className="flex-1 flex flex-col overflow-hidden bg-slate-50">
      {/* Graph */}
      <div className="flex-1 flex overflow-hidden relative">
        <ReactFlow
          nodes={nodes}
          edges={edges}
          onNodesChange={onNodesChange}
          onEdgesChange={onEdgesChange}
          onNodeClick={onNodeClick}
          onPaneClick={onPaneClick}
          onNodeDragStop={onNodeDragStop}
          nodeTypes={nodeTypes}
          nodesDraggable={isOperationMode}
          fitView
          fitViewOptions={{ padding: 0.05, includeHiddenNodes: false, minZoom: 0.25, maxZoom: 1.5 }}
          attributionPosition="bottom-right"
          minZoom={0.25}
          maxZoom={1.5}
        >
          <Panel position="top-left" className="!m-2">
            <Controls className="bg-white border-slate-200 shadow-sm !static" showInteractive={false} />
          </Panel>

          <Panel position="bottom-left" className="!m-2">
            <MiniMap
              nodeColor={node => {
                const ot = data.objectTypes.find(o => o.id === node.id);
                const layer = ot ? classifyToLayer(ot) : 'industry';
                return getLayerColor(layer);
              }}
              maskColor="rgba(248, 250, 252, 0.7)"
              className="bg-white border border-slate-200 rounded-lg shadow-sm"
            />
          </Panel>

          <Panel position="bottom-right" className="!m-4">
            <Sheet open={aiSheetOpen} onOpenChange={setAiSheetOpen}>
              <SheetTrigger asChild>
                <button
                  className={cn(
                    "w-12 h-12 rounded-full bg-gradient-to-br from-purple-500 to-blue-600",
                    "flex items-center justify-center gap-1",
                    "text-white text-xs font-medium",
                    "shadow-lg hover:shadow-xl hover:scale-105",
                    "transition-all duration-300",
                    "group relative"
                  )}
                >
                  <Sparkles className="w-5 h-5" />
                  <span className="text-[10px]">AI</span>
                  <div className={cn(
                    "absolute right-full mr-3 top-1/2 -translate-y-1/2",
                    "bg-slate-800 text-white text-xs px-2 py-1 rounded whitespace-nowrap",
                    "opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none"
                  )}>
                    AI本体建模
                  </div>
                </button>
              </SheetTrigger>
              <SheetContent
                side="right"
                className="w-[600px] sm:max-w-[600px] p-0 bg-slate-50/95 backdrop-blur-sm"
                style={{ '--sheet-overlay-opacity': '0.3' } as React.CSSProperties}
              >
                <AiStudio data={data} onUpdate={onUpdate || (() => {})} embedded />
              </SheetContent>
            </Sheet>
          </Panel>

          <Background color="#cbd5e1" gap={20} />

          <Panel position="top-left" className="!ml-4 !mt-2" style={{ pointerEvents: 'none' }}>
            <div className="flex flex-col gap-0" style={{ marginTop: 30 }}>
              {(() => {
                const layerPositions = new Map<LayerId, number>();
                nodes.forEach(n => {
                  const ot = data.objectTypes.find(o => o.id === n.id);
                  if (!ot) return;
                  const layer = classifyToLayer(ot);
                  const existing = layerPositions.get(layer);
                  if (existing === undefined || n.position.y < existing) {
                    layerPositions.set(layer, n.position.y);
                  }
                });
                return LAYER_ORDER
                  .filter(lid => layerPositions.has(lid))
                  .map(lid => (
                    <div
                      key={lid}
                      className="text-xs font-semibold px-3 py-1.5 rounded-md mb-1 whitespace-nowrap"
                      style={{
                        color: getLayerColor(lid),
                        backgroundColor: getLayerColor(lid) + '15',
                        border: `1px solid ${getLayerColor(lid)}40`,
                        position: 'absolute',
                        top: (layerPositions.get(lid) || 0) - 30,
                        left: -20,
                      }}
                    >
                      {LAYER_LABELS[lid]}
                    </div>
                  ));
              })()}
            </div>
          </Panel>
        </ReactFlow>
      </div>
    </div>
  );
};
