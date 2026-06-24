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

export const LAYER_LABELS: Record<LayerId, string> = {
  company: '公司层',
  finance: '经营财务指标层',
  industry: '产业链层',
  relation: '关系对象层',
};

export const LAYER_ORDER: LayerId[] = ['company', 'finance', 'industry', 'relation'];

export function classifyToLayer(ot: ObjectType): LayerId {
  if (ot.objectTypeCategory === 'relation') return 'relation';
  if (ot.id === 'company_entity') return 'company';
  if (['business_perspective', 'financial_perspective'].includes(ot.id)) return 'finance';
  return 'industry';
}

export function getLayerColor(layer: LayerId): string {
  return LAYER_COLORS[layer];
}

// ── Layout Constants ──────────────────────────────────────────────────────────

const NODE_WIDTH = 240;
const NODE_HEIGHT_BASE = 90;
const NODE_HEIGHT_PER_PROP = 18;
const LAYER_Y_GAP = 280;
const INDUSTRY_X_GAP = 340;
const SAME_RANK_Y_GAP = 160;
const MARGIN_LEFT = 100;
const MARGIN_TOP = 80;

const GROUP_MIN_WIDTH = 280;
const GROUP_TITLE_HEIGHT = 32;
const GROUP_PADDING = 16;
const GROUP_CHILD_GAP = 16;

interface SavedLayout {
  x: number;
  y: number;
  width?: number;
  height?: number;
}

function getNodeHeight(ot: ObjectType): number {
  return NODE_HEIGHT_BASE + Math.min(ot.properties.length, 5) * NODE_HEIGHT_PER_PROP;
}

function calculateGroupSize(
  parentId: string,
  objectTypes: ObjectType[],
  visibleSet: Set<string>,
  nodeHeightMap: Map<string, number>
): { width: number; height: number } {
  const children = objectTypes.filter(ot => ot.parentObjectType === parentId && visibleSet.has(ot.id));
  let totalHeight = GROUP_TITLE_HEIGHT + GROUP_PADDING;
  let maxWidth = GROUP_MIN_WIDTH;

  children.forEach(child => {
    const isParent = objectTypes.some(ot => ot.parentObjectType === child.id && visibleSet.has(ot.id));
    if (isParent) {
      const childSize = calculateGroupSize(child.id, objectTypes, visibleSet, nodeHeightMap);
      totalHeight += childSize.height + GROUP_CHILD_GAP;
      maxWidth = Math.max(maxWidth, childSize.width + GROUP_PADDING * 2);
    } else {
      totalHeight += (nodeHeightMap.get(child.id) || NODE_HEIGHT_BASE) + GROUP_CHILD_GAP;
    }
  });

  totalHeight += GROUP_PADDING;
  return { width: maxWidth, height: totalHeight };
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
        backgroundColor: color + '08',
        borderColor: color + '40',
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
          backgroundColor: color + '20',
          color: color,
          borderBottom: `1px solid ${color}30`,
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

  return (
    <div
      className="shadow-lg rounded-xl min-w-[220px] max-w-[260px] transition-all relative"
      style={{
        borderWidth: 2,
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

      <div className="px-3 py-2.5 flex items-center gap-2 cursor-pointer" style={{ borderBottom: '1px solid #f1f5f9' }}>
        <div className="w-8 h-8 rounded-lg flex items-center justify-center" style={{ backgroundColor: color + '15' }}>
          <Database className="w-4 h-4" style={{ color }} />
        </div>
        <div className="flex-1 min-w-0">
          <div className="font-bold text-sm text-slate-900 truncate">{data.label as string}</div>
          <div className="text-[10px] text-slate-400 font-mono truncate">{data.id as string}</div>
        </div>
      </div>

      <div className="px-3 py-2">
        <div className="text-[10px] font-semibold text-slate-400 uppercase tracking-wider mb-1.5">
          属性 ({properties.length})
        </div>
        <div className="space-y-0.5">
          {properties.slice(0, 5).map((p: any) => (
            <div key={p.id} className="flex items-center gap-1.5 text-[11px] py-0.5">
              {!!p.isPrimaryKey && <Key className="w-2.5 h-2.5 text-amber-500 shrink-0" />}
              <span className="text-slate-700 truncate flex-1">{p.name}</span>
              <span className="text-slate-400 font-mono text-[9px] shrink-0 bg-slate-50 px-1 rounded">{p.type}</span>
            </div>
          ))}
          {properties.length > 5 && (
            <div className="text-[10px] text-slate-400 italic pt-0.5">+{properties.length - 5} 更多</div>
          )}
        </div>
      </div>

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

// ── Layered Layout ────────────────────────────────────────────────────────────

function layoutGraph(
  allObjectTypes: ObjectType[],
  visibleObjectTypes: ObjectType[],
  linkTypes: LinkType[],
  savedLayouts: Map<string, SavedLayout>,
  isOperationMode: boolean,
  onGroupResizeEnd?: (nodeId: string, width: number, height: number) => void
) {
  const visibleSet = new Set(visibleObjectTypes.map(ot => ot.id));
  const nodeHeightMap = new Map<string, number>();
  visibleObjectTypes.forEach(ot => nodeHeightMap.set(ot.id, getNodeHeight(ot)));

  const hasChildren = (id: string) =>
    allObjectTypes.some(ot => ot.parentObjectType === id && visibleSet.has(ot.id));

  const layerMap = new Map<string, LayerId>();
  visibleObjectTypes.forEach(ot => layerMap.set(ot.id, classifyToLayer(ot)));

  const rootObjectTypes = visibleObjectTypes.filter(ot => !ot.parentObjectType);

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
      for (let r = 0; r <= maxRank; r++) {
        const group = rankGroups.get(r) || [];
        group.forEach((ot, idx) => {
          const x = MARGIN_LEFT + r * INDUSTRY_X_GAP;
          const y = currentY + idx * SAME_RANK_Y_GAP;
          positions.set(ot.id, { x, y });
        });
      }
      currentY += Math.max(items.length * SAME_RANK_Y_GAP, 300) + LAYER_Y_GAP;
    } else {
      items.forEach((ot, idx) => {
        const x = MARGIN_LEFT + idx * (NODE_WIDTH + 60);
        const y = currentY;
        positions.set(ot.id, { x, y });
      });
      currentY += LAYER_Y_GAP;
    }
  });

  const childPositions = new Map<string, { x: number; y: number }>();
  visibleObjectTypes.filter(ot => hasChildren(ot.id)).forEach(parent => {
    const children = visibleObjectTypes.filter(ot => ot.parentObjectType === parent.id);
    let cy = GROUP_TITLE_HEIGHT + GROUP_PADDING;
    children.forEach(child => {
      childPositions.set(child.id, { x: GROUP_PADDING, y: cy });
      if (hasChildren(child.id)) {
        const childSize = calculateGroupSize(child.id, allObjectTypes, visibleSet, nodeHeightMap);
        cy += childSize.height + GROUP_CHILD_GAP;
      } else {
        cy += (nodeHeightMap.get(child.id) || NODE_HEIGHT_BASE) + GROUP_CHILD_GAP;
      }
    });
  });

  const nodes: any[] = [];

  visibleObjectTypes.filter(ot => hasChildren(ot.id)).forEach(ot => {
    const saved = savedLayouts.get(ot.id);
    const autoPos = ot.parentObjectType ? childPositions.get(ot.id) : positions.get(ot.id);
    const pos = saved || autoPos || { x: 0, y: 0 };
    const autoSize = calculateGroupSize(ot.id, allObjectTypes, visibleSet, nodeHeightMap);
    const layer = layerMap.get(ot.id) || 'industry';
    nodes.push({
      id: ot.id,
      type: 'group',
      position: pos,
      parentNode: ot.parentObjectType || undefined,
      style: {
        width: saved?.width ?? autoSize.width,
        height: saved?.height ?? autoSize.height,
        backgroundColor: getLayerColor(layer) + '08',
        borderColor: getLayerColor(layer) + '40',
      },
      data: {
        label: ot.name,
        color: getLayerColor(layer),
        isOperationMode: isOperationMode,
        onResizeEnd: onGroupResizeEnd,
      },
    });
  });

  visibleObjectTypes.filter(ot => !hasChildren(ot.id)).forEach(ot => {
    const saved = savedLayouts.get(ot.id);
    const autoPos = ot.parentObjectType ? childPositions.get(ot.id) : positions.get(ot.id);
    const pos = saved || autoPos || { x: 0, y: 0 };
    const layer = layerMap.get(ot.id) || 'industry';
    nodes.push({
      id: ot.id,
      type: 'objectType',
      position: pos,
      parentNode: ot.parentObjectType || undefined,
      data: {
        label: ot.name,
        id: ot.id,
        properties: ot.properties,
        color: getLayerColor(layer),
        selected: false,
        status: ot.status,
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
    return layoutGraph(data.objectTypes, visibleObjectTypes, data.linkTypes, savedLayouts, isOperationMode, handleGroupResizeEnd);
  }, [data.objectTypes, visibleObjectTypes, data.linkTypes, savedLayouts, isOperationMode, handleGroupResizeEnd]);

  const initialEdges: Edge[] = useMemo(() => {
    const edges: Edge[] = [];

    const getLayer = (id: string): LayerId => {
      const ot = data.objectTypes.find(o => o.id === id);
      return ot ? classifyToLayer(ot) : 'industry';
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
          sourceHandle = 'bottom';
          targetHandle = 'top';
        } else {
          edgeColor = getLayerColor(srcLayer);
        }

        if (isPending) edgeColor = '#9ca3af';

        edges.push({
          id: lt.id,
          source: src,
          target: tgt,
          sourceHandle,
          targetHandle,
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
  const [edges, setEdges, onEdgesChange] = useEdgesState(initialEdges);

  useEffect(() => {
    setNodes(initialNodes);
    setEdges(initialEdges);
  }, [initialNodes, initialEdges, setNodes, setEdges]);

  useEffect(() => {
    setNodes(nds =>
      nds.map(n => ({
        ...n,
        data: { ...n.data, selected: n.id === selectedObjectId },
      }))
    );
    setEdges(eds =>
      eds.map(e => {
        const connected = selectedObjectId && (e.source === selectedObjectId || e.target === selectedObjectId);
        return {
          ...e,
          style: {
            ...e.style,
            strokeWidth: connected ? 3 : 2,
            opacity: selectedObjectId ? (connected ? 1 : 0.3) : 0.7,
          },
        };
      })
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
          attributionPosition="bottom-right"
          minZoom={0.2}
          maxZoom={2}
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
