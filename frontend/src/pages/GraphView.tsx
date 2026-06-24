import React, { useEffect, useState, useMemo } from 'react';
import { OntologyData } from '@/src/store/ontologyStore';
import { Database, Link as LinkIcon, Filter, LayoutGrid, GitBranch } from 'lucide-react';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/src/components/ui/select';
import { OntologyOverviewGraph } from '@/src/components/graph/OntologyOverviewGraph';
import { OntologyFlatGraph, classifyToLayer, getLayerColor, LAYER_ORDER, LAYER_LABELS } from '@/src/components/graph/OntologyFlatGraph';
import { DetailPanel } from '@/src/components/graph/DetailPanel';
import { api } from '@/src/api/client';
import { cn } from '@/src/lib/utils';

const FLAT_MODE_THRESHOLD = 30;

export function GraphView({ data, onUpdate }: { data: OntologyData; onUpdate?: (data: OntologyData) => void }) {
  const [viewMode, setViewMode] = useState<'flat' | 'overview'>('overview');
  const [selectedObjectId, setSelectedObjectId] = useState<string | null>(null);
  const [categoryFilter, setCategoryFilter] = useState<'all' | 'entity'>('all');
  const [aiSheetOpen, setAiSheetOpen] = useState(false);
  const [projectName, setProjectName] = useState<string>('项目本体');
  const [flatOperationMode, setFlatOperationMode] = useState(true);
  const [flatResetTrigger, setFlatResetTrigger] = useState(0);

  // Load current project name
  useEffect(() => {
    api.getProjects().then(res => {
      if (res.success && res.projects) {
        const currentProjectId = api.getCurrentProjectId();
        const currentProject = res.projects.find((p: any) => p.id === currentProjectId);
        if (currentProject?.name) {
          setProjectName(currentProject.name);
        }
      }
    }).catch(console.error);
  }, []);

  // Auto-select view mode based on OT count
  useEffect(() => {
    if (data.objectTypes.length < FLAT_MODE_THRESHOLD) {
      setViewMode('flat');
    } else {
      setViewMode('overview');
    }
  }, [data.objectTypes.length]);

  const visibleObjectTypes = useMemo(() =>
    data.objectTypes.filter(ot => {
      if (categoryFilter === 'entity' && ot.objectTypeCategory === 'relation') return false;
      return true;
    }),
  [data.objectTypes, categoryFilter]);

  const selectedObject = data.objectTypes.find(o => o.id === selectedObjectId) || null;
  const relatedLinks = selectedObjectId
    ? data.linkTypes.filter(lt => lt.sourceObjectId === selectedObjectId || lt.targetObjectId === selectedObjectId)
    : [];

  return (
    <div className="h-full w-full flex flex-col -m-6">
      {/* Header */}
      <div className="flex items-center justify-between px-6 py-4 bg-white border-b border-slate-200 shrink-0">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-900">本体图谱</h1>
          <p className="text-slate-500 text-sm mt-0.5">
            {viewMode === 'overview'
              ? '点击任意实体查看其详情和关系。带 +/- 的节点可展开/折叠子类。'
              : '平铺模式：按层级展示所有对象类型及其属性。'}
          </p>
        </div>
        <div className="flex items-center gap-3 text-sm">
          {/* View mode toggle */}
          <div className="flex items-center bg-slate-100 rounded-lg p-0.5 border border-slate-200">
            <button
              onClick={() => setViewMode('flat')}
              className={`
                flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-medium transition-all
                ${viewMode === 'flat'
                  ? 'bg-white text-slate-800 shadow-sm'
                  : 'text-slate-500 hover:text-slate-700'
                }
              `}
              title="平铺模式：适合 OT 较少的项目"
            >
              <LayoutGrid className="w-3.5 h-3.5" />
              平铺模式
            </button>
            <button
              onClick={() => setViewMode('overview')}
              className={`
                flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-medium transition-all
                ${viewMode === 'overview'
                  ? 'bg-white text-slate-800 shadow-sm'
                  : 'text-slate-500 hover:text-slate-700'
                }
              `}
              title="概览模式：适合 OT 较多的项目"
            >
              <GitBranch className="w-3.5 h-3.5" />
              概览模式
            </button>
          </div>

          {/* Category filter */}
          <div className="flex items-center gap-1.5">
            <Filter className="w-3.5 h-3.5 text-slate-400" />
            <Select value={categoryFilter} onValueChange={(v: any) => setCategoryFilter(v)}>
              <SelectTrigger className="h-7 text-xs w-[140px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">全部对象类型</SelectItem>
                <SelectItem value="entity">仅实体对象类型</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Flat mode operation toggle & reset */}
          {viewMode === 'flat' && (
            <>
              <button
                onClick={() => setFlatOperationMode(prev => !prev)}
                className={cn(
                  "h-7 px-3 rounded-md text-xs font-medium transition-colors border",
                  flatOperationMode
                    ? "bg-blue-50 text-blue-600 border-blue-200 hover:bg-blue-100"
                    : "bg-slate-50 text-slate-500 border-slate-200 hover:bg-slate-100"
                )}
                title={flatOperationMode ? '当前为操作态，可拖动节点和调整区域框大小' : '当前为只读态，仅可缩放和移动画布'}
              >
                {flatOperationMode ? '操作态' : '只读态'}
              </button>
              <button
                onClick={() => setFlatResetTrigger(prev => prev + 1)}
                className="h-7 px-3 rounded-md text-xs font-medium transition-colors border bg-slate-50 text-slate-500 border-slate-200 hover:bg-red-50 hover:text-red-500 hover:border-red-200"
              >
                重置布局
              </button>
            </>
          )}

          {/* Stats */}
          <div className="flex items-center gap-1.5 text-slate-500">
            <Database className="w-3.5 h-3.5 text-blue-500" />
            <span>{visibleObjectTypes.length} 个实体</span>
            {visibleObjectTypes.length !== data.objectTypes.length && (
              <span className="text-xs text-slate-400">(共 {data.objectTypes.length})</span>
            )}
          </div>
          <div className="flex items-center gap-1.5 text-slate-500">
            <LinkIcon className="w-3.5 h-3.5 text-emerald-500" />
            <span>{data.linkTypes.length} 个关系</span>
          </div>

          {/* Layer legend for flat mode */}
          {viewMode === 'flat' && (
            <div className="flex items-center gap-4 ml-4 pl-4 border-l border-slate-200">
              {LAYER_ORDER.map(layerId => {
                const items = visibleObjectTypes.filter(ot => classifyToLayer(ot) === layerId);
                if (items.length === 0) return null;
                return (
                  <div key={layerId} className="flex items-center gap-1.5 text-xs text-slate-500">
                    <div className="w-3 h-3 rounded-sm" style={{ backgroundColor: getLayerColor(layerId) }}></div>
                    <span>{LAYER_LABELS[layerId]}</span>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

      {/* Main content */}
      <div className="flex-1 flex overflow-hidden">
        {viewMode === 'overview' && (
          <OntologyOverviewGraph
            data={data}
            projectName={projectName}
            selectedObjectId={selectedObjectId}
            onSelectObject={setSelectedObjectId}
            categoryFilter={categoryFilter}
            aiSheetOpen={aiSheetOpen}
            setAiSheetOpen={setAiSheetOpen}
            onUpdate={onUpdate}
          />
        )}

        {viewMode === 'flat' && (
          <OntologyFlatGraph
            data={data}
            selectedObjectId={selectedObjectId}
            onSelectObject={setSelectedObjectId}
            categoryFilter={categoryFilter}
            isOperationMode={flatOperationMode}
            resetTrigger={flatResetTrigger}
            aiSheetOpen={aiSheetOpen}
            setAiSheetOpen={setAiSheetOpen}
            onUpdate={onUpdate}
          />
        )}

        {/* Detail Panel */}
        {selectedObject && (
          <DetailPanel
            objectType={selectedObject}
            relatedLinks={relatedLinks}
            allObjects={data.objectTypes}
            onClose={() => setSelectedObjectId(null)}
            onNavigate={id => setSelectedObjectId(id)}
            onOpenDandelion={viewMode === 'flat' ? () => {
              setViewMode('overview');
              setSelectedObjectId(selectedObject.id);
            } : undefined}
            viewMode={viewMode}
          />
        )}
      </div>
    </div>
  );
}
