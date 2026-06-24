import React from 'react';
import { ObjectType, LinkType } from '@/src/store/ontologyStore';
import { Database, Link as LinkIcon, Key, X, ArrowRight, ChevronRight } from 'lucide-react';
import { Badge } from '@/src/components/ui/badge';
import { Button } from '@/src/components/ui/button';

interface DetailPanelProps {
  objectType: ObjectType;
  relatedLinks: LinkType[];
  allObjects: ObjectType[];
  onClose: () => void;
  onNavigate: (id: string) => void;
  onOpenDandelion?: () => void;
  viewMode?: 'flat' | 'overview';
}

export const DetailPanel: React.FC<DetailPanelProps> = ({
  objectType,
  relatedLinks,
  allObjects,
  onClose,
  onNavigate,
  onOpenDandelion,
  viewMode,
}) => {
  const inbound = relatedLinks.filter(lt => lt.targetObjectId === objectType.id);
  const outbound = relatedLinks.filter(lt => lt.sourceObjectId === objectType.id);
  const getName = (id: string) => allObjects.find(o => o.id === id)?.name || id;

  return (
    <div className="w-[360px] bg-white border-l border-slate-200 flex flex-col shrink-0 shadow-lg overflow-hidden">
      {/* Header */}
      <div className="p-4 border-b border-slate-200 flex items-center gap-3">
        <div className="w-10 h-10 rounded-lg bg-blue-100 text-blue-600 flex items-center justify-center">
          <Database className="w-5 h-5" />
        </div>
        <div className="flex-1 min-w-0">
          <h2 className="font-bold text-lg text-slate-900 truncate">{objectType.name}</h2>
          <p className="text-xs text-slate-400 font-mono truncate">{objectType.id}</p>
        </div>
        <div className="flex items-center gap-1">
          {onOpenDandelion && relatedLinks.length > 0 && viewMode === 'flat' && (
            <Button
              variant="ghost"
              size="sm"
              className="h-8 text-xs text-indigo-600 hover:bg-indigo-50 hover:text-indigo-700"
              onClick={onOpenDandelion}
              title="以蒲公英图形式查看关系"
            >
              蒲公英图
            </Button>
          )}
          <Button variant="ghost" size="icon" className="h-8 w-8 shrink-0" onClick={onClose}>
            <X className="w-4 h-4" />
          </Button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto">
        {/* Description */}
        {objectType.description && (
          <div className="px-4 py-3 border-b border-slate-100">
            <p className="text-sm text-slate-600">{objectType.description}</p>
          </div>
        )}

        {/* Properties */}
        <div className="px-4 py-3 border-b border-slate-100">
          <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">
            属性 ({objectType.properties.length})
          </h3>
          <div className="space-y-1">
            {objectType.properties.map(p => (
              <div key={p.id} className="flex items-center gap-2 text-sm py-1.5 px-2 rounded-lg hover:bg-slate-50">
                {!!p.isPrimaryKey && <Key className="w-3 h-3 text-amber-500 shrink-0" />}
                <div className="flex-1 min-w-0">
                  <div className="font-medium text-slate-800 text-xs truncate">{p.name}</div>
                  {p.description && <div className="text-[10px] text-slate-400 truncate">{p.description}</div>}
                </div>
                <Badge variant="secondary" className="font-mono text-[9px] h-4 px-1.5 shrink-0">{p.type}</Badge>
              </div>
            ))}
          </div>
        </div>

        {/* Outbound Links */}
        {outbound.length > 0 && (
          <div className="px-4 py-3 border-b border-slate-100">
            <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">
              出站链接 ({outbound.length})
            </h3>
            <div className="space-y-1.5">
              {outbound.map(lt => (
                <button key={lt.id} className="w-full text-left p-2 rounded-lg hover:bg-emerald-50 transition-colors flex items-center gap-2 group"
                  onClick={() => onNavigate(lt.targetObjectId)}>
                  <LinkIcon className="w-3 h-3 text-emerald-500 shrink-0" />
                  <div className="flex-1 min-w-0">
                    <div className="text-xs font-medium text-slate-700 flex items-center gap-1">
                      {lt.name}
                      <ArrowRight className="w-3 h-3 text-slate-400" />
                      <span className="text-blue-600">{getName(lt.targetObjectId)}</span>
                    </div>
                    <div className="text-[10px] text-slate-400">{lt.description}</div>
                  </div>
                  <Badge variant="outline" className="font-mono text-[9px] h-4 shrink-0">{lt.cardinality}</Badge>
                  <ChevronRight className="w-3 h-3 text-slate-300 group-hover:text-blue-500 shrink-0" />
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Inbound Links */}
        {inbound.length > 0 && (
          <div className="px-4 py-3">
            <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">
              入站链接 ({inbound.length})
            </h3>
            <div className="space-y-1.5">
              {inbound.map(lt => (
                <button key={lt.id} className="w-full text-left p-2 rounded-lg hover:bg-blue-50 transition-colors flex items-center gap-2 group"
                  onClick={() => onNavigate(lt.sourceObjectId)}>
                  <LinkIcon className="w-3 h-3 text-blue-500 shrink-0" />
                  <div className="flex-1 min-w-0">
                    <div className="text-xs font-medium text-slate-700 flex items-center gap-1">
                      <span className="text-blue-600">{getName(lt.sourceObjectId)}</span>
                      <ArrowRight className="w-3 h-3 text-slate-400" />
                      {lt.name}
                    </div>
                    <div className="text-[10px] text-slate-400">{lt.description}</div>
                  </div>
                  <Badge variant="outline" className="font-mono text-[9px] h-4 shrink-0">{lt.cardinality}</Badge>
                  <ChevronRight className="w-3 h-3 text-slate-300 group-hover:text-blue-500 shrink-0" />
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Backing Dataset */}
        {objectType.backingDataset && (
          <div className="px-4 py-3 border-t border-slate-100">
            <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Dataset</h3>
            <div className="flex items-center gap-2 p-2 bg-slate-50 rounded-lg">
              <Database className="w-3 h-3 text-slate-400" />
              <span className="font-mono text-[10px] text-slate-500 truncate">{objectType.backingDataset}</span>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
