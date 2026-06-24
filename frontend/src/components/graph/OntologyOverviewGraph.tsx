import React, { useMemo, useCallback, useEffect, useState, useRef } from 'react';
import { OntologyData, ObjectType, LinkType } from '@/src/store/ontologyStore';
import {
  ReactFlow, MiniMap, Controls, Background,
  useNodesState, useEdgesState, Handle, Position,
  NodeProps, Edge, Panel, Node, useReactFlow,
} from '@xyflow/react';
import '@xyflow/react/dist/style.css';
import { Link as LinkIcon, Sparkles, Plus, Minus, ArrowLeft } from 'lucide-react';
import { Sheet, SheetContent, SheetTrigger } from '@/src/components/ui/sheet';
import { AiStudio } from '@/src/pages/AiStudio';
import { DandelionGraph } from '@/src/components/DandelionGraph';
import { cn } from '@/src/lib/utils';
import { api } from '@/src/api/client';

// ── Constants ─────────────────────────────────────────────────────────────────

const NODE_WIDTH = 170;
const NODE_HEIGHT = 56;
const LEVEL_X_GAP = 260;
const Y_GAP = 24;
const SIBLING_GAP = 16;
const ROOT_GAP = 120;
const MARGIN_TOP = 80;

const INDUSTRY_COLOR = '#10b981';
const TECH_ROUTE_COLOR = '#0891b2';
const COMPANY_COLOR = '#3b82f6';

const PROJECT_ROOT_ID = '__project_root__';

interface SavedLayout {
  x: number;
  y: number;
  width?: number;
  height?: number;
}

interface TreeNodeInfo {
  id: string;
  ot: ObjectType;
  children: TreeNodeInfo[];
  depth: number;
  parentId: string | null;
  hasChildren: boolean;
}

// ── Tree building ─────────────────────────────────────────────────────────────

function buildForest(allObjectTypes: ObjectType[], visibleSet: Set<string>): TreeNodeInfo[] {
  const otMap = new Map(allObjectTypes.map(ot => [ot.id, ot]));
  const childrenMap = new Map<string, string[]>();

  allObjectTypes.forEach(ot => {
    if (!ot.parentObjectType) return;
    if (!childrenMap.has(ot.parentObjectType)) {
      childrenMap.set(ot.parentObjectType, []);
    }
    childrenMap.get(ot.parentObjectType)!.push(ot.id);
  });

  function buildTree(id: string, parentId: string | null, depth: number): TreeNodeInfo {
    const ot = otMap.get(id)!;
    const childIds = (childrenMap.get(id) || []).filter(cid => visibleSet.has(cid));
    const children = childIds.map(cid => buildTree(cid, id, depth + 1));
    return {
      id,
      ot,
      children,
      depth,
      parentId,
      hasChildren: childIds.length > 0,
    };
  }

  const roots: TreeNodeInfo[] = [];
  allObjectTypes.forEach(ot => {
    if (!visibleSet.has(ot.id)) return;
    const parentId = ot.parentObjectType;
    if (!parentId || !visibleSet.has(parentId)) {
      roots.push(buildTree(ot.id, null, 0));
    }
  });

  return roots;
}

function buildProjectRootedForest(
  allObjectTypes: ObjectType[],
  visibleSet: Set<string>,
  projectName: string
): TreeNodeInfo {
  const realRoots = buildForest(allObjectTypes, visibleSet);

  const virtualOt: ObjectType = {
    id: PROJECT_ROOT_ID,
    name: projectName,
    description: '项目本体中心节点',
    icon: '',
    backingDataset: '',
    industryId: null,
    parentObjectType: null,
    showParentLink: true,
    objectTypeCategory: 'entity',
    properties: [],
    status: 'active',
    implementedInterfaces: [],
  };

  return {
    id: PROJECT_ROOT_ID,
    ot: virtualOt,
    children: realRoots,
    depth: 0,
    parentId: null,
    hasChildren: realRoots.length > 0,
  };
}

function computeSectionColors(allObjectTypes: ObjectType[], visibleSet: Set<string>): Map<string, string> {
  const colorMap = new Map<string, string>();

  function assignColor(nodeId: string, color: string) {
    colorMap.set(nodeId, color);
    allObjectTypes
      .filter(o => o.parentObjectType === nodeId && visibleSet.has(o.id))
      .forEach(child => assignColor(child.id, color));
  }

  allObjectTypes.forEach(ot => {
    if (!visibleSet.has(ot.id)) return;
    const parentId = ot.parentObjectType;
    const isTopLevel = !parentId || !visibleSet.has(parentId) || parentId === PROJECT_ROOT_ID;
    if (!isTopLevel) return;

    let color = '#6b7280';
    if (ot.id === 'company_entity') color = COMPANY_COLOR;
    else if (ot.id === 'semiconductor_industry_chain') color = INDUSTRY_COLOR;
    else if (ot.id === 'technology_route') color = TECH_ROUTE_COLOR;
    assignColor(ot.id, color);
  });

  return colorMap;
}

function getDefaultCollapsedSet(allObjectTypes: ObjectType[], visibleSet: Set<string>): Set<string> {
  const parentMap = new Map<string, string | null>();
  allObjectTypes.forEach(ot => {
    parentMap.set(ot.id, ot.parentObjectType || null);
  });

  const depths = new Map<string, number>();
  function computeDepth(id: string, d: number) {
    if (depths.has(id)) return;
    depths.set(id, d);
    allObjectTypes
      .filter(ot => ot.parentObjectType === id && visibleSet.has(ot.id))
      .forEach(child => computeDepth(child.id, d + 1));
  }

  allObjectTypes.forEach(ot => {
    if (!visibleSet.has(ot.id)) return;
    const parentId = ot.parentObjectType;
    if (!parentId || !visibleSet.has(parentId)) {
      computeDepth(ot.id, 0);
    }
  });

  const gpuId = allObjectTypes.find(
    ot => ot.id.toLowerCase().includes('gpu') || ot.name.toLowerCase().includes('gpu')
  )?.id;

  const gpuRelated = new Set<string>();
  if (gpuId && visibleSet.has(gpuId)) {
    let cur: string | null = gpuId;
    while (cur) {
      gpuRelated.add(cur);
      cur = parentMap.get(cur) ?? null;
      if (cur && !visibleSet.has(cur)) break;
    }
    const queue = [gpuId];
    while (queue.length > 0) {
      const id = queue.shift()!;
      gpuRelated.add(id);
      allObjectTypes
        .filter(ot => ot.parentObjectType === id && visibleSet.has(ot.id))
        .forEach(child => queue.push(child.id));
    }
  }

  const collapsed = new Set<string>();
  visibleSet.forEach(id => {
    const d = depths.get(id) ?? Infinity;
    if (d < 1) return;
    if (gpuRelated.has(id)) return;
    collapsed.add(id);
  });

  return collapsed;
}

function computeTempExpandedSet(
  selectedId: string | null,
  allObjectTypes: ObjectType[],
  visibleSet: Set<string>,
  userCollapsedSet: Set<string>,
  linkTypes: LinkType[]
): Set<string> {
  const tempExpanded = new Set<string>();
  if (!selectedId) return tempExpanded;

  const parentMap = new Map<string, string | null>();
  allObjectTypes.forEach(ot => parentMap.set(ot.id, ot.parentObjectType || null));

  const relatedIds = new Set<string>();
  relatedIds.add(selectedId);
  linkTypes.forEach(lt => {
    if (lt.sourceObjectId === selectedId) relatedIds.add(lt.targetObjectId);
    if (lt.targetObjectId === selectedId) relatedIds.add(lt.sourceObjectId);
  });

  relatedIds.forEach(id => {
    if (!visibleSet.has(id)) return;
    let cur: string | null = id;
    while (cur) {
      if (userCollapsedSet.has(cur)) {
        tempExpanded.add(cur);
      }
      cur = parentMap.get(cur) ?? null;
      if (cur && !visibleSet.has(cur)) break;
    }
  });

  return tempExpanded;
}

// ── Custom Node ───────────────────────────────────────────────────────────────

const ObjectTypeNode = ({ id, data, selected }: NodeProps) => {
  const color = (data.color as string) || '#3b82f6';
  const status = data.status as string | undefined;
  const isPending = status === 'pending';
  const hasChildren = data.hasChildren as boolean;
  const collapsed = data.collapsed as boolean;
  const onToggleCollapse = data.onToggleCollapse as (id: string) => void;
  const isProjectRoot = id === PROJECT_ROOT_ID;

  if (isProjectRoot) {
    return (
      <div
        className="rounded-full transition-all relative cursor-default flex flex-col justify-center items-center"
        style={{
          width: NODE_WIDTH + 30,
          height: NODE_HEIGHT + 16,
          borderWidth: selected ? 3 : 2,
          borderStyle: 'solid',
          borderColor: '#ffffff',
          boxShadow: selected ? '0 0 0 4px rgba(59,130,246,0.3)' : '0 4px 12px rgba(0,0,0,0.15)',
          background: 'linear-gradient(135deg, #1e40af 0%, #3b82f6 100%)',
        }}
      >
        <Handle type="target" position={Position.Left} id="left" className="!w-1.5 !h-1.5" style={{ background: '#ffffff' }} />
        <Handle type="source" position={Position.Left} id="left" className="!w-1.5 !h-1.5" style={{ background: '#ffffff' }} />
        <div className="px-3 text-center">
          <div className="font-bold text-[13px] text-white truncate leading-tight">{data.label as string}</div>
        </div>
        <Handle type="target" position={Position.Right} id="right" className="!w-1.5 !h-1.5" style={{ background: '#ffffff' }} />
        <Handle type="source" position={Position.Right} id="right" className="!w-1.5 !h-1.5" style={{ background: '#ffffff' }} />
      </div>
    );
  }

  return (
    <div
      className="rounded-lg transition-all relative cursor-pointer flex flex-col justify-center"
      style={{
        width: NODE_WIDTH,
        height: NODE_HEIGHT,
        borderWidth: selected ? 2 : 1.5,
        borderStyle: isPending ? 'dashed' : 'solid',
        borderColor: isPending ? '#9ca3af' : color,
        boxShadow: selected ? `0 0 0 3px ${color}33` : '0 1px 2px rgba(0,0,0,0.08)',
        backgroundColor: isPending ? '#f9fafb' : '#ffffff',
      }}
    >
      {isPending && (
        <div className="absolute -top-1.5 -right-1.5 bg-amber-100 text-amber-700 text-[8px] px-1 py-px rounded-full border border-amber-200 font-medium">
          待审核
        </div>
      )}
      <Handle type="target" position={Position.Top} id="top" className="!w-1.5 !h-1.5" style={{ background: color }} />
      <Handle type="target" position={Position.Left} id="left" className="!w-1.5 !h-1.5" style={{ background: color }} />
      <Handle type="source" position={Position.Left} id="left" className="!w-1.5 !h-1.5" style={{ background: color }} />
      <div className="px-2.5 flex-1 flex flex-col justify-center min-w-0">
        <div className="font-semibold text-[12px] text-slate-800 truncate leading-tight">{data.label as string}</div>
        <div className="text-[10px] text-slate-400 truncate leading-tight mt-0.5 font-mono">{id}</div>
      </div>
      <Handle type="target" position={Position.Right} id="right" className="!w-1.5 !h-1.5" style={{ background: color }} />
      <Handle type="source" position={Position.Right} id="right" className="!w-1.5 !h-1.5" style={{ background: color }} />
      <Handle type="source" position={Position.Bottom} id="bottom" className="!w-1.5 !h-1.5" style={{ background: color }} />

      {hasChildren && (
        <button
          className="absolute -right-3 top-1/2 -translate-y-1/2 w-6 h-6 rounded-full border flex items-center justify-center z-10 hover:scale-105 transition-transform"
          style={{
            backgroundColor: '#ffffff',
            borderColor: color,
            color: color,
          }}
          onClick={(e) => {
            e.stopPropagation();
            onToggleCollapse(id);
          }}
          title={collapsed ? '展开子类' : '折叠子类'}
        >
          {collapsed ? <Plus className="w-3 h-3" /> : <Minus className="w-3 h-3" />}
        </button>
      )}
    </div>
  );
};

const nodeTypes = { objectType: ObjectTypeNode };

// ── Mind map layout ───────────────────────────────────────────────────────────

function createFlowNode(
  treeNode: TreeNodeInfo,
  x: number,
  y: number,
  color: string,
  collapsed: boolean,
  onToggleCollapse: (id: string) => void
): Node {
  return {
    id: treeNode.id,
    type: 'objectType',
    position: { x, y },
    data: {
      label: treeNode.ot.name,
      id: treeNode.id,
      properties: treeNode.ot.properties,
      color,
      selected: false,
      status: treeNode.ot.status,
      depth: treeNode.depth,
      hasChildren: treeNode.hasChildren,
      collapsed,
      onToggleCollapse,
    },
  };
}

function estimateSubtreeHeight(treeNode: TreeNodeInfo, effectiveCollapsedSet: Set<string>): number {
  const isCollapsed = effectiveCollapsedSet.has(treeNode.id);
  if (isCollapsed || treeNode.children.length === 0) {
    return NODE_HEIGHT + Y_GAP;
  }
  let total = 0;
  treeNode.children.forEach(child => {
    total += estimateSubtreeHeight(child, effectiveCollapsedSet);
  });
  return Math.max(total, NODE_HEIGHT + Y_GAP);
}

function splitChildrenByHeight(
  children: TreeNodeInfo[],
  effectiveCollapsedSet: Set<string>
): { left: TreeNodeInfo[]; right: TreeNodeInfo[] } {
  const scored = children.map(child => ({
    child,
    height: estimateSubtreeHeight(child, effectiveCollapsedSet),
  }));
  scored.sort((a, b) => b.height - a.height);

  const left: TreeNodeInfo[] = [];
  const right: TreeNodeInfo[] = [];
  let leftHeight = 0;
  let rightHeight = 0;

  scored.forEach(({ child, height }) => {
    if (leftHeight <= rightHeight) {
      left.push(child);
      leftHeight += height;
    } else {
      right.push(child);
      rightHeight += height;
    }
  });

  return { left, right };
}

function layoutMindMapSide(
  children: TreeNodeInfo[],
  side: 'left' | 'right',
  depth: number,
  startY: number,
  effectiveCollapsedSet: Set<string>,
  sectionColors: Map<string, string>,
  onToggleCollapse: (id: string) => void,
  childSideMap: Map<string, 'left' | 'right'>
): { nodes: Node[]; height: number } {
  let nodes: Node[] = [];
  let currentY = startY;

  children.forEach(child => {
    childSideMap.set(child.id, side);
    const result = layoutMindMapNode(
      child,
      side,
      currentY,
      effectiveCollapsedSet,
      sectionColors,
      onToggleCollapse,
      childSideMap,
      depth
    );
    nodes.push(...result.nodes);
    currentY += result.height;
  });

  return { nodes, height: currentY - startY };
}

function layoutMindMapNode(
  treeNode: TreeNodeInfo,
  side: 'left' | 'right' | null,
  startY: number,
  effectiveCollapsedSet: Set<string>,
  sectionColors: Map<string, string>,
  onToggleCollapse: (id: string) => void,
  childSideMap: Map<string, 'left' | 'right'>,
  depth: number
): { nodes: Node[]; height: number } {
  const color = sectionColors.get(treeNode.id) || '#6b7280';
  const isCollapsed = effectiveCollapsedSet.has(treeNode.id);
  const x = side === 'left' ? -depth * LEVEL_X_GAP : (side === 'right' ? depth * LEVEL_X_GAP : 0);

  if (isCollapsed || treeNode.children.length === 0) {
    return {
      nodes: [createFlowNode(treeNode, x, startY, color, isCollapsed, onToggleCollapse)],
      height: NODE_HEIGHT + Y_GAP,
    };
  }

  let leftChildren: TreeNodeInfo[] = [];
  let rightChildren: TreeNodeInfo[] = [];

  if (side === null) {
    const split = splitChildrenByHeight(treeNode.children, effectiveCollapsedSet);
    leftChildren = split.left;
    rightChildren = split.right;
  } else {
    if (side === 'left') {
      leftChildren = treeNode.children;
    } else {
      rightChildren = treeNode.children;
    }
  }

  leftChildren.forEach(c => childSideMap.set(c.id, 'left'));
  rightChildren.forEach(c => childSideMap.set(c.id, 'right'));

  const leftResult = layoutMindMapSide(
    leftChildren, 'left', depth + 1, startY, effectiveCollapsedSet, sectionColors, onToggleCollapse, childSideMap
  );
  const rightResult = layoutMindMapSide(
    rightChildren, 'right', depth + 1, startY, effectiveCollapsedSet, sectionColors, onToggleCollapse, childSideMap
  );

  const leftHeight = leftResult.height;
  const rightHeight = rightResult.height;
  const totalHeight = Math.max(leftHeight, rightHeight, NODE_HEIGHT + Y_GAP);

  const nodeCenterY = startY + totalHeight / 2;
  const nodeY = nodeCenterY - NODE_HEIGHT / 2;

  const leftOffset = nodeCenterY - (startY + leftHeight / 2);
  const rightOffset = nodeCenterY - (startY + rightHeight / 2);

  const leftNodes = leftResult.nodes.map(n => ({
    ...n,
    position: { ...n.position, y: n.position.y + leftOffset },
  }));
  const rightNodes = rightResult.nodes.map(n => ({
    ...n,
    position: { ...n.position, y: n.position.y + rightOffset },
  }));

  const parentNode = createFlowNode(treeNode, x, nodeY, color, false, onToggleCollapse);

  return {
    nodes: [parentNode, ...leftNodes, ...rightNodes],
    height: totalHeight,
  };
}

function layoutMindMapForest(
  roots: TreeNodeInfo[],
  centerX: number,
  startY: number,
  effectiveCollapsedSet: Set<string>,
  sectionColors: Map<string, string>,
  onToggleCollapse: (id: string) => void
): { nodes: Node[]; childSideMap: Map<string, 'left' | 'right'> } {
  const nodes: Node[] = [];
  const childSideMap = new Map<string, 'left' | 'right'>();
  let currentY = startY;

  roots.forEach(root => {
    const result = layoutMindMapNode(
      root, null, currentY, effectiveCollapsedSet, sectionColors, onToggleCollapse, childSideMap, 0
    );
    nodes.push(...result.nodes);
    currentY += result.height + ROOT_GAP;
  });

  return { nodes, childSideMap };
}

// ── Edge generation ───────────────────────────────────────────────────────────

type LayerId = 'company' | 'finance' | 'industry' | 'relation';

const LAYER_COLORS: Record<LayerId, string> = {
  company: '#3b82f6',
  finance: '#f59e0b',
  industry: '#10b981',
  relation: '#8b5cf6',
};

function classifyToLayer(ot: ObjectType): LayerId {
  if (ot.objectTypeCategory === 'relation') return 'relation';
  if (ot.id === 'company_entity') return 'company';
  if (['business_perspective', 'financial_perspective'].includes(ot.id)) return 'finance';
  return 'industry';
}

function getLayerColor(layer: LayerId): string {
  return LAYER_COLORS[layer];
}

function buildClassEdges(
  renderedNodeIds: Set<string>,
  allObjectTypes: ObjectType[],
  childSideMap: Map<string, 'left' | 'right'>
): Edge[] {
  const edges: Edge[] = [];

  allObjectTypes.forEach(ot => {
    if (!ot.parentObjectType) return;
    if (!renderedNodeIds.has(ot.id) || !renderedNodeIds.has(ot.parentObjectType)) return;

    const side = childSideMap.get(ot.id) || 'right';
    const sourceHandle = side === 'left' ? 'left' : 'right';
    const targetHandle = side === 'left' ? 'right' : 'left';

    edges.push({
      id: `class-${ot.parentObjectType}-${ot.id}`,
      source: ot.parentObjectType,
      target: ot.id,
      type: 'smoothstep',
      sourceHandle,
      targetHandle,
      style: {
        stroke: '#64748b',
        strokeWidth: 1.5,
        opacity: 0.25,
        strokeDasharray: '4,4',
      },
      markerEnd: { type: 'arrowclosed', color: '#64748b', width: 10, height: 10 },
      selectable: false,
    });
  });

  allObjectTypes.forEach(ot => {
    if (!renderedNodeIds.has(ot.id)) return;
    const parentId = ot.parentObjectType;
    const isTopLevel = !parentId || !renderedNodeIds.has(parentId);
    if (!isTopLevel) return;

    const side = childSideMap.get(ot.id) || 'right';
    const sourceHandle = side === 'left' ? 'left' : 'right';
    const targetHandle = side === 'left' ? 'right' : 'left';

    edges.push({
      id: `class-${PROJECT_ROOT_ID}-${ot.id}`,
      source: PROJECT_ROOT_ID,
      target: ot.id,
      type: 'smoothstep',
      sourceHandle,
      targetHandle,
      style: {
        stroke: '#64748b',
        strokeWidth: 1.5,
        opacity: 0.25,
        strokeDasharray: '4,4',
      },
      markerEnd: { type: 'arrowclosed', color: '#64748b', width: 10, height: 10 },
      selectable: false,
    });
  });

  return edges;
}

function buildLinkEdges(
  linkTypes: LinkType[],
  objectTypes: ObjectType[],
  renderedNodeIds: Set<string>,
  selectedObjectId: string | null,
  categoryFilter: 'all' | 'entity'
): Edge[] {
  const edges: Edge[] = [];

  const getLayer = (id: string): LayerId => {
    const ot = objectTypes.find(o => o.id === id);
    return ot ? classifyToLayer(ot) : 'industry';
  };

  const isHiddenByCategory = (id: string) => {
    if (categoryFilter !== 'entity') return false;
    const ot = objectTypes.find(o => o.id === id);
    return ot?.objectTypeCategory === 'relation';
  };

  linkTypes.forEach(lt => {
    if (isHiddenByCategory(lt.sourceObjectId) || isHiddenByCategory(lt.targetObjectId)) return;
    const src = lt.sourceObjectId;
    const tgt = lt.targetObjectId;
    if (!src || !tgt || src === tgt) return;
    if (!renderedNodeIds.has(src) || !renderedNodeIds.has(tgt)) return;

    const isPending = lt.status === 'pending';
    const cat = lt.linkCategory || '';
    const srcLayer = getLayer(lt.sourceObjectId);
    const tgtLayer = getLayer(lt.targetObjectId);

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
    } else if (srcLayer !== tgtLayer) {
      edgeColor = '#94a3b8';
      sourceHandle = 'right';
      targetHandle = 'left';
    } else {
      edgeColor = getLayerColor(srcLayer);
      sourceHandle = 'right';
      targetHandle = 'left';
    }

    if (isPending) edgeColor = '#9ca3af';

    const isConnected = selectedObjectId && (src === selectedObjectId || tgt === selectedObjectId);

    edges.push({
      id: lt.id,
      source: src,
      target: tgt,
      sourceHandle,
      targetHandle,
      type: 'smoothstep',
      label: `${lt.name} (${lt.cardinality})${isPending ? ' [待审核]' : ''}`,
      animated: false,
      style: {
        stroke: edgeColor,
        strokeWidth: isConnected ? 2.5 : 2,
        opacity: isConnected ? 0.9 : 0,
      },
      labelStyle: {
        fill: isPending ? '#9ca3af' : '#475569',
        fontWeight: 500,
        fontSize: 11,
        opacity: isConnected ? 1 : 0,
      },
      labelBgStyle: { fill: '#ffffff', fillOpacity: isConnected ? 0.95 : 0, stroke: 'none' },
      labelBgPadding: [6, 3] as [number, number],
      labelBgBorderRadius: 4,
      selectable: false,
    });
  });

  return edges;
}

// ── Fit view controller ───────────────────────────────────────────────────────

function FitViewController({ nodeCount }: { nodeCount: number }) {
  const { fitView } = useReactFlow();
  const prevCountRef = useRef(nodeCount);

  useEffect(() => {
    if (nodeCount !== prevCountRef.current) {
      prevCountRef.current = nodeCount;
      const timer = setTimeout(() => {
        fitView({ duration: 300, padding: 0.15 });
      }, 50);
      return () => clearTimeout(timer);
    }
  }, [nodeCount, fitView]);

  return null;
}

// ── Main Component ────────────────────────────────────────────────────────────

export interface OntologyOverviewGraphProps {
  data: OntologyData;
  projectName: string;
  selectedObjectId: string | null;
  onSelectObject: (id: string | null) => void;
  categoryFilter: 'all' | 'entity';
  aiSheetOpen: boolean;
  setAiSheetOpen: (open: boolean) => void;
  onUpdate?: (data: OntologyData) => void;
}

export const OntologyOverviewGraph: React.FC<OntologyOverviewGraphProps> = ({
  data,
  projectName,
  selectedObjectId,
  onSelectObject,
  categoryFilter,
  aiSheetOpen,
  setAiSheetOpen,
  onUpdate,
}) => {
  const [isOperationMode, setIsOperationMode] = useState(false);
  const [savedLayouts, setSavedLayouts] = useState<Map<string, SavedLayout>>(new Map());
  const [dandelionCenterId, setDandelionCenterId] = useState<string | null>(null);

  // Load saved layouts
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

  const visibleObjectTypes = useMemo(() =>
    data.objectTypes.filter(ot => {
      if (categoryFilter === 'entity' && ot.objectTypeCategory === 'relation') return false;
      return true;
    }),
  [data.objectTypes, categoryFilter]);

  const visibleSet = useMemo(
    () => new Set(visibleObjectTypes.map(ot => ot.id)),
    [visibleObjectTypes]
  );

  const defaultCollapsedSet = useMemo(
    () => getDefaultCollapsedSet(data.objectTypes, visibleSet),
    [data.objectTypes, visibleSet]
  );

  const [userCollapsedSet, setUserCollapsedSet] = useState<Set<string>>(new Set());
  const [tempExpandedSet, setTempExpandedSet] = useState<Set<string>>(new Set());

  useEffect(() => {
    setUserCollapsedSet(new Set(defaultCollapsedSet));
    setTempExpandedSet(new Set());
  }, [defaultCollapsedSet]);

  useEffect(() => {
    const next = computeTempExpandedSet(selectedObjectId, data.objectTypes, visibleSet, userCollapsedSet, data.linkTypes);
    setTempExpandedSet(next);
  }, [selectedObjectId, data.objectTypes, visibleSet, userCollapsedSet, data.linkTypes]);

  const effectiveCollapsedSet = useMemo(() => {
    const set = new Set(userCollapsedSet);
    tempExpandedSet.forEach(id => set.delete(id));
    return set;
  }, [userCollapsedSet, tempExpandedSet]);

  const effectiveCollapsedRef = useRef(effectiveCollapsedSet);
  effectiveCollapsedRef.current = effectiveCollapsedSet;

  const techRouteRoot = useMemo(() => {
    return data.objectTypes.find(ot => ot.id === 'technology_route' && !ot.parentObjectType) || null;
  }, [data.objectTypes]);

  const techRouteAllIds = useMemo(() => {
    if (!techRouteRoot) return new Set<string>();
    const ids = new Set<string>([techRouteRoot.id]);
    const queue = [techRouteRoot.id];
    while (queue.length > 0) {
      const id = queue.shift()!;
      data.objectTypes
        .filter(ot => ot.parentObjectType === id)
        .forEach(ot => {
          ids.add(ot.id);
          queue.push(ot.id);
        });
    }
    return ids;
  }, [techRouteRoot, data.objectTypes]);

  const onToggleCollapse = useCallback((id: string) => {
    if (id === PROJECT_ROOT_ID) return;
    const isCollapsed = effectiveCollapsedRef.current.has(id);
    if (isCollapsed) {
      setUserCollapsedSet(prev => {
        const next = new Set(prev);
        next.delete(id);
        return next;
      });
      setTempExpandedSet(prev => {
        const next = new Set(prev);
        next.add(id);
        return next;
      });
    } else {
      setUserCollapsedSet(prev => {
        const next = new Set(prev);
        next.add(id);
        return next;
      });
      setTempExpandedSet(prev => {
        const next = new Set(prev);
        next.delete(id);
        return next;
      });
    }
  }, []);

  const forest = useMemo(
    () => buildProjectRootedForest(data.objectTypes, visibleSet, projectName),
    [data.objectTypes, visibleSet, projectName]
  );

  const sectionColors = useMemo(
    () => computeSectionColors(data.objectTypes, visibleSet),
    [data.objectTypes, visibleSet]
  );

  const layoutResult = useMemo(
    () => layoutMindMapForest([forest], 0, MARGIN_TOP, effectiveCollapsedSet, sectionColors, onToggleCollapse),
    [forest, effectiveCollapsedSet, sectionColors, onToggleCollapse]
  );
  const initialNodes = layoutResult.nodes;
  const childSideMap = layoutResult.childSideMap;

  const renderedNodeIds = useMemo(
    () => new Set(initialNodes.map(n => n.id)),
    [initialNodes]
  );

  const classEdges = useMemo(
    () => buildClassEdges(renderedNodeIds, data.objectTypes, childSideMap),
    [renderedNodeIds, data.objectTypes, childSideMap]
  );

  const linkEdges = useMemo(
    () => buildLinkEdges(data.linkTypes, data.objectTypes, renderedNodeIds, selectedObjectId, categoryFilter),
    [data.linkTypes, data.objectTypes, renderedNodeIds, selectedObjectId, categoryFilter]
  );

  const initialEdges = useMemo<Edge[]>(() => [...classEdges, ...linkEdges], [classEdges, linkEdges]);

  const [nodes, setNodes, _onNodesChange] = useNodesState(initialNodes);
  const [edges, setEdges, onEdgesChange] = useEdgesState(initialEdges);

  useEffect(() => {
    const updatedNodes = initialNodes.map(n => ({
      ...n,
      data: { ...n.data, selected: n.id === selectedObjectId },
    }));
    setNodes(updatedNodes);
    setEdges(initialEdges);
  }, [initialNodes, initialEdges, selectedObjectId, setNodes, setEdges]);

  const onNodeClick = useCallback((_event: any, node: Node) => {
    if (node.id === PROJECT_ROOT_ID) return;

    const isLeaf = !data.objectTypes.some(ot => ot.parentObjectType === node.id);
    const hasLinks = data.linkTypes.some(
      lt => lt.sourceObjectId === node.id || lt.targetObjectId === node.id
    );

    onSelectObject(selectedObjectId === node.id ? null : node.id);

    if (isLeaf && hasLinks) {
      setDandelionCenterId(node.id);
    }
  }, [data.objectTypes, data.linkTypes, onSelectObject, selectedObjectId]);

  const onPaneClick = useCallback(() => {
    onSelectObject(null);
  }, [onSelectObject]);

  const onNodesChange = useCallback((changes: any[]) => {
    _onNodesChange(changes);
  }, [_onNodesChange]);

  const handleResetLayout = useCallback(() => {
    setUserCollapsedSet(new Set(defaultCollapsedSet));
    setSavedLayouts(new Map());
    onSelectObject(null);
    api.saveObjectTypeLayouts([]).catch(() => {});
  }, [defaultCollapsedSet, onSelectObject]);

  const sectionLabels = useMemo(() => {
    const labels: { key: string; label: string; color: string; x: number; y: number }[] = [];
    const sections = [
      { key: 'company', label: '公司', color: COMPANY_COLOR, nodeId: 'company_entity' },
      { key: 'industry', label: '产业链', color: INDUSTRY_COLOR, nodeId: 'semiconductor_industry_chain' },
      { key: 'tech_route', label: '技术路线', color: TECH_ROUTE_COLOR, nodeId: 'technology_route' },
    ];
    sections.forEach(sec => {
      const node = nodes.find(n => n.id === sec.nodeId);
      if (node) {
        labels.push({
          key: sec.key, label: sec.label, color: sec.color,
          x: node.position.x, y: node.position.y,
        });
      }
    });
    labels.sort((a, b) => a.x - b.x);
    return labels;
  }, [nodes]);

  const dandelionCenterObject = dandelionCenterId
    ? data.objectTypes.find(o => o.id === dandelionCenterId) || null
    : null;

  const relatedLinks = dandelionCenterId
    ? data.linkTypes.filter(lt => lt.sourceObjectId === dandelionCenterId || lt.targetObjectId === dandelionCenterId)
    : [];

  return (
    <div className="flex-1 flex flex-col overflow-hidden bg-slate-50">
      {/* Toolbar */}
      <div className="px-4 py-2 border-b border-slate-200 bg-white flex items-center gap-2 shrink-0">
        <button
          onClick={() => setIsOperationMode(prev => !prev)}
          className={cn(
            "h-7 px-3 rounded-md text-xs font-medium transition-colors border",
            isOperationMode
              ? "bg-blue-50 text-blue-600 border-blue-200 hover:bg-blue-100"
              : "bg-slate-50 text-slate-500 border-slate-200 hover:bg-slate-100"
          )}
        >
          {isOperationMode ? '编辑态' : '只读态'}
        </button>
        {dandelionCenterId && (
          <button
            onClick={() => setDandelionCenterId(null)}
            className="h-7 px-3 rounded-md text-xs font-medium transition-colors border bg-indigo-50 text-indigo-600 border-indigo-200 hover:bg-indigo-100 flex items-center gap-1"
          >
            <ArrowLeft className="w-3.5 h-3.5" />
            返回树状图谱
          </button>
        )}
        <button
          onClick={handleResetLayout}
          className="h-7 px-3 rounded-md text-xs font-medium transition-colors border bg-slate-50 text-slate-500 border-slate-200 hover:bg-red-50 hover:text-red-500 hover:border-red-200"
        >
          重置布局
        </button>
        <div className="flex-1" />
        <div className="flex items-center gap-4 text-xs text-slate-500">
          {data.objectTypes.some(ot => ot.id === 'company_entity') && (
            <div className="flex items-center gap-1.5">
              <div className="w-2.5 h-2.5 rounded-sm" style={{ backgroundColor: COMPANY_COLOR }}></div>
              <span>公司</span>
            </div>
          )}
          {data.objectTypes.some(ot => ot.id === 'semiconductor_industry_chain') && (
            <div className="flex items-center gap-1.5">
              <div className="w-2.5 h-2.5 rounded-sm" style={{ backgroundColor: INDUSTRY_COLOR }}></div>
              <span>产业链</span>
            </div>
          )}
          {techRouteRoot && visibleObjectTypes.some(ot => techRouteAllIds.has(ot.id)) && (
            <div className="flex items-center gap-1.5">
              <div className="w-2.5 h-2.5 rounded-sm" style={{ backgroundColor: TECH_ROUTE_COLOR }}></div>
              <span>技术路线</span>
            </div>
          )}
        </div>
      </div>

      {/* Graph area */}
      <div className="flex-1 flex overflow-hidden relative">
        {!dandelionCenterId && (
          <div className="flex-1 bg-slate-50">
            <ReactFlow
              nodes={nodes}
              edges={edges}
              onNodesChange={onNodesChange}
              onEdgesChange={onEdgesChange}
              onNodeClick={onNodeClick}
              onPaneClick={onPaneClick}
              nodeTypes={nodeTypes}
              nodesDraggable={isOperationMode}
              fitView
              attributionPosition="bottom-right"
              minZoom={0.1}
              maxZoom={2}
            >
              <Panel position="top-left" className="!m-2">
                <Controls className="bg-white border-slate-200 shadow-sm !static" showInteractive={false} />
              </Panel>

              <Panel position="bottom-left" className="!m-2">
                <MiniMap
                  nodeColor={node => {
                    if (techRouteAllIds.has(node.id)) return TECH_ROUTE_COLOR;
                    const ot = data.objectTypes.find(o => o.id === node.id);
                    if (ot?.id === 'company_entity') return COMPANY_COLOR;
                    if (ot?.id === 'semiconductor_industry_chain') return INDUSTRY_COLOR;
                    return '#6b7280';
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

              <FitViewController nodeCount={nodes.length} />

              <Panel position="top-left" className="!ml-4 !mt-2" style={{ pointerEvents: 'none' }}>
                <div className="flex flex-col gap-0" style={{ marginTop: 30 }}>
                  {sectionLabels.map(sl => (
                    <div
                      key={sl.key}
                      className="text-xs font-semibold px-3 py-1.5 rounded-md mb-1 whitespace-nowrap"
                      style={{
                        color: sl.color,
                        backgroundColor: sl.color + '15',
                        border: `1px solid ${sl.color}40`,
                        position: 'absolute',
                        top: sl.y - 28,
                        left: sl.x - 30,
                      }}
                    >
                      {sl.label}
                    </div>
                  ))}
                </div>
              </Panel>
            </ReactFlow>
          </div>
        )}

        {dandelionCenterObject && (
          <div className="flex-1 bg-slate-50 flex flex-col overflow-hidden">
            <div className="px-6 py-3 border-b border-slate-200 bg-white flex items-center justify-between shrink-0">
              <div className="flex items-center gap-3">
                <button
                  onClick={() => setDandelionCenterId(null)}
                  className="flex items-center gap-1 text-xs text-indigo-600 hover:text-indigo-700 font-medium"
                >
                  <ArrowLeft className="w-3.5 h-3.5" />
                  返回树状图谱
                </button>
                <span className="text-slate-300">|</span>
                <h2 className="text-sm font-semibold text-slate-800">
                  {dandelionCenterObject.name} 的关系蒲公英图
                </h2>
              </div>
              <p className="text-xs text-slate-500">
                蓝色 = 上游，绿色 = 下游，点击花瓣查看其蒲公英图
              </p>
            </div>
            <div className="flex-1 flex items-center justify-center overflow-auto">
              <DandelionGraph
                center={dandelionCenterObject}
                relatedLinks={relatedLinks}
                allObjects={data.objectTypes}
                onNodeClick={ot => {
                  onSelectObject(ot.id);
                  setDandelionCenterId(ot.id);
                }}
              />
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
