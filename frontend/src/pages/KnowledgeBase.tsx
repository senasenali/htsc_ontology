import React, { useState, useEffect, useCallback } from 'react';
import { Button } from '@/src/components/ui/button';
import { Input } from '@/src/components/ui/input';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/src/components/ui/table';
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from '@/src/components/ui/dialog';
import { Sheet, SheetContent, SheetHeader, SheetTitle } from '@/src/components/ui/sheet';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/src/components/ui/select';
import { Label } from '@/src/components/ui/label';
import { Badge } from '@/src/components/ui/badge';
import { Search, Plus, Trash2, Pencil, Loader2, FolderOpen, ExternalLink, X } from 'lucide-react';
import { toast } from 'sonner';
import { api, KnowledgeBaseItem, KnowledgeBaseRef, KnowledgeBaseRecord } from '@/src/api/client';
import MarkdownRender from '@/src/components/MarkdownRender';

// ── Constants ────────────────────────────────────────────────────────────────

const SOURCE_TYPES = [
  { value: 'meeting_minutes', label: '会议纪要', color: 'bg-blue-100 text-blue-700' },
  { value: 'tech_report', label: '技术报告', color: 'bg-purple-100 text-purple-700' },
  { value: 'industry_news', label: '行业动态', color: 'bg-green-100 text-green-700' },
  { value: 'internal_note', label: '内部笔记', color: 'bg-amber-100 text-amber-700' },
  { value: 'other', label: '其他', color: 'bg-slate-100 text-slate-700' },
];

function getSourceTypeMeta(value?: string) {
  return SOURCE_TYPES.find(s => s.value === value) || SOURCE_TYPES[4];
}

// ── Date helpers ──────────────────────────────────────────────────────────────

function formatDate(dateStr?: string) {
  if (!dateStr) return '-';
  const d = new Date(dateStr);
  return d.toLocaleDateString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit' });
}

function toLocalDatetimeString(date: Date): string {
  const pad = (n: number) => n.toString().padStart(2, '0');
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

// ── Editable ref row ──────────────────────────────────────────────────────────

function emptyRef(): KnowledgeBaseRef {
  return { refObjectTypeId: '', refInstanceId: '', instanceName: '' };
}

// ── Main Component ────────────────────────────────────────────────────────────

export default function KnowledgeBase() {
  const [records, setRecords] = useState<KnowledgeBaseRecord[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(false);

  // Edit dialog state
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [formTitle, setFormTitle] = useState('');
  const [formSourceType, setFormSourceType] = useState('');
  const [formSourceName, setFormSourceName] = useState('');
  const [formAuthors, setFormAuthors] = useState('');
  const [formEntryDate, setFormEntryDate] = useState('');
  const [formContent, setFormContent] = useState('');
  const [formRefs, setFormRefs] = useState<KnowledgeBaseRef[]>([emptyRef()]);
  const [saving, setSaving] = useState(false);

  // Detail Sheet state
  const [detailOpen, setDetailOpen] = useState(false);
  const [detailDoc, setDetailDoc] = useState<KnowledgeBaseItem | null>(null);
  const [detailRefs, setDetailRefs] = useState<KnowledgeBaseRef[]>([]);

  // Delete confirm
  const [deleteId, setDeleteId] = useState<number | null>(null);

  const loadList = useCallback(async (p: number = page, s: string = search) => {
    setLoading(true);
    try {
      const res = await api.getKnowledgeBaseList(p, 10, s || undefined);
      if (res.success) {
        setRecords(res.data.records);
        setTotal(res.data.total);
        setPage(res.data.page);
        setTotalPages(res.data.totalPages);
      }
    } catch (err: any) {
      toast.error('加载失败: ' + err.message);
    } finally {
      setLoading(false);
    }
  }, [page, search]);

  useEffect(() => { loadList(1, search); }, []);

  const handleSearch = () => { loadList(1, search); };

  const openDetail = async (id: number) => {
    try {
      const res = await api.getKnowledgeBaseDetail(id);
      if (res.success) {
        setDetailDoc(res.data.doc);
        setDetailRefs(res.data.refs);
        setDetailOpen(true);
      }
    } catch (err: any) {
      toast.error('加载详情失败');
    }
  };

  // ── Open dialog for create/edit ──────────────────────────────────────────

  const openCreate = () => {
    setEditingId(null);
    setFormTitle('');
    setFormSourceType('');
    setFormSourceName('');
    setFormAuthors('');
    setFormEntryDate('');
    setFormContent('');
    setFormRefs([emptyRef()]);
    setDialogOpen(true);
  };

  const openEdit = async (id: number) => {
    try {
      const res = await api.getKnowledgeBaseDetail(id);
      if (res.success) {
        const doc = res.data.doc;
        setEditingId(id);
        setFormTitle(doc.title);
        setFormSourceType(doc.sourceType || '');
        setFormSourceName(doc.sourceName || '');
        setFormAuthors(doc.authors || '');
        setFormEntryDate(doc.entryDate ? doc.entryDate.substring(0, 16) : '');
        setFormContent(doc.content || '');
        setFormRefs(res.data.refs.length > 0 ? res.data.refs : [emptyRef()]);
        setDialogOpen(true);
      }
    } catch (err: any) {
      toast.error('加载详情失败');
    }
  };

  // ── Save ─────────────────────────────────────────────────────────────────

  const handleSave = async () => {
    if (!formTitle.trim()) {
      toast.error('请输入标题');
      return;
    }
    setSaving(true);
    try {
      const payload = {
        title: formTitle.trim(),
        content: formContent,
        sourceType: formSourceType || undefined,
        sourceName: formSourceName || undefined,
        authors: formAuthors || undefined,
        entryDate: formEntryDate ? new Date(formEntryDate).toISOString() : undefined,
        refs: formRefs.filter(r => r.refObjectTypeId || r.refInstanceId),
      };

      if (editingId) {
        const res = await api.updateKnowledgeBase(editingId, payload);
        if (res.success) toast.success('更新成功');
      } else {
        const res = await api.createKnowledgeBase(payload);
        if (res.success) toast.success('创建成功');
      }
      setDialogOpen(false);
      loadList(1, search);
    } catch (err: any) {
      toast.error('保存失败: ' + err.message);
    } finally {
      setSaving(false);
    }
  };

  // ── Delete ───────────────────────────────────────────────────────────────

  const handleDelete = async () => {
    if (deleteId === null) return;
    try {
      const res = await api.deleteKnowledgeBase(deleteId);
      if (res.success) {
        toast.success('已删除');
        setDeleteId(null);
        loadList(page, search);
      }
    } catch (err: any) {
      toast.error('删除失败: ' + err.message);
    }
  };

  // ── Ref helpers ──────────────────────────────────────────────────────────

  const updateRef = (idx: number, field: string, value: string) => {
    setFormRefs(prev => prev.map((r, i) => i === idx ? { ...r, [field]: value } : r));
  };

  const addRef = () => setFormRefs(prev => [...prev, emptyRef()]);
  const removeRef = (idx: number) => setFormRefs(prev => prev.filter((_, i) => i !== idx));

  // ── Render ───────────────────────────────────────────────────────────────

  return (
    <div className="flex flex-col h-full max-w-6xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-4 pb-4 border-b border-slate-200">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center shadow-sm">
            <FolderOpen className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-lg font-bold text-slate-900">资讯库</h1>
            <p className="text-xs text-slate-500">将私域信息挂载到图谱节点</p>
          </div>
        </div>
        <Button onClick={openCreate} className="gap-2">
          <Plus className="w-4 h-4" />
          新增资讯
        </Button>
      </div>

      {/* Search */}
      <div className="flex items-center gap-2 mb-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <Input
            placeholder="搜索标题..."
            value={search}
            onChange={e => setSearch(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && handleSearch()}
            className="pl-9"
          />
        </div>
        <Button variant="secondary" size="sm" onClick={handleSearch}>搜索</Button>
        <span className="text-xs text-slate-400 ml-2">共 {total} 条</span>
      </div>

      {/* Table */}
      <div className="flex-1 overflow-y-auto">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="w-[35%]">标题</TableHead>
              <TableHead>来源类型</TableHead>
              <TableHead>来源说明</TableHead>
              <TableHead>关联节点</TableHead>
              <TableHead>信息日期</TableHead>
              <TableHead className="text-right">操作</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-12">
                  <Loader2 className="w-6 h-6 animate-spin mx-auto text-slate-400" />
                </TableCell>
              </TableRow>
            ) : records.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-12 text-slate-400">
                  暂无资讯，点击"新增资讯"创建
                </TableCell>
              </TableRow>
            ) : (
              records.map(rec => {
                const doc = rec.doc;
                const st = getSourceTypeMeta(doc.sourceType);
                return (
                  <TableRow key={doc.id} className="group">
                    <TableCell>
                      <button
                        onClick={() => openDetail(doc.id)}
                        className="font-medium text-sm text-blue-600 hover:text-blue-800 hover:underline truncate max-w-md text-left"
                      >
                        {doc.title}
                      </button>
                    </TableCell>
                    <TableCell>
                      <Badge className={`${st.color} border-0 text-[10px]`} variant="outline">
                        {st.label}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-sm text-slate-500">{doc.sourceName || '-'}</TableCell>
                    <TableCell>
                      {rec.refs && rec.refs.length > 0 ? (
                        <div className="flex flex-wrap gap-1">
                          {rec.refs.slice(0, 3).map((ref, i) => (
                            <Badge key={i} variant="outline" className="text-[10px] bg-blue-50 text-blue-700 border-blue-200">
                              {ref.instanceName || ref.refObjectTypeId || '未知'}
                            </Badge>
                          ))}
                          {rec.refs.length > 3 && (
                            <span className="text-[10px] text-slate-400">+{rec.refs.length - 3}</span>
                          )}
                        </div>
                      ) : (
                        <span className="text-xs text-slate-400">-</span>
                      )}
                    </TableCell>
                    <TableCell className="text-sm text-slate-500">{formatDate(doc.entryDate)}</TableCell>
                    <TableCell className="text-right">
                      <div className="flex items-center justify-end gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                        <Button variant="ghost" size="icon" className="h-8 w-8" onClick={() => openEdit(doc.id)}>
                          <Pencil className="w-4 h-4 text-slate-500" />
                        </Button>
                        <Button variant="ghost" size="icon" className="h-8 w-8" onClick={() => setDeleteId(doc.id)}>
                          <Trash2 className="w-4 h-4 text-red-500" />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                );
              })
            )}
          </TableBody>
        </Table>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2 py-4 border-t border-slate-100">
          <Button variant="outline" size="sm" disabled={page <= 1} onClick={() => loadList(page - 1, search)}>
            上一页
          </Button>
          <span className="text-sm text-slate-500 px-3">
            {page} / {totalPages}
          </span>
          <Button variant="outline" size="sm" disabled={page >= totalPages} onClick={() => loadList(page + 1, search)}>
            下一页
          </Button>
        </div>
      )}

      {/* Create / Edit Dialog */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{editingId ? '编辑资讯' : '新增资讯'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            {/* Title */}
            <div className="space-y-1.5">
              <Label>标题 <span className="text-red-500">*</span></Label>
              <Input value={formTitle} onChange={e => setFormTitle(e.target.value)} placeholder="输入标题..." />
            </div>

            {/* Source type + Source name */}
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1.5">
                <Label>来源类型</Label>
                <Select value={formSourceType} onValueChange={setFormSourceType}>
                  <SelectTrigger>
                    <SelectValue placeholder="选择来源类型" />
                  </SelectTrigger>
                  <SelectContent>
                    {SOURCE_TYPES.map(st => (
                      <SelectItem key={st.value} value={st.value}>{st.label}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1.5">
                <Label>来源说明</Label>
                <Input value={formSourceName} onChange={e => setFormSourceName(e.target.value)} placeholder="如：Q2技术评审会" />
              </div>
            </div>

            {/* Authors + Entry date */}
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1.5">
                <Label>作者/提供者</Label>
                <Input value={formAuthors} onChange={e => setFormAuthors(e.target.value)} placeholder="可选" />
              </div>
              <div className="space-y-1.5">
                <Label>信息日期</Label>
                <Input type="datetime-local" value={formEntryDate} onChange={e => setFormEntryDate(e.target.value)} />
              </div>
            </div>

            {/* Content */}
            <div className="space-y-1.5">
              <Label>正文（支持 Markdown）</Label>
              <textarea
                value={formContent}
                onChange={e => setFormContent(e.target.value)}
                placeholder="输入资讯正文，支持 Markdown 格式..."
                rows={8}
                className="w-full resize-y outline-none rounded-lg border border-slate-200 px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400"
              />
            </div>

            {/* Linked nodes / Refs */}
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <Label>关联节点</Label>
                <Button variant="ghost" size="sm" onClick={addRef} className="h-7 text-xs gap-1">
                  <Plus className="w-3 h-3" /> 添加
                </Button>
              </div>
              {formRefs.map((ref, idx) => (
                <div key={idx} className="flex items-center gap-2 p-2 bg-slate-50 rounded-lg">
                  <div className="flex-1">
                    <Input
                      placeholder="对象类型ID（如：battery）"
                      value={ref.refObjectTypeId || ''}
                      onChange={e => updateRef(idx, 'refObjectTypeId', e.target.value)}
                      className="text-xs h-8"
                    />
                  </div>
                  <div className="flex-1">
                    <Input
                      placeholder="实例ID（可选，如：CATL）"
                      value={ref.refInstanceId || ''}
                      onChange={e => updateRef(idx, 'refInstanceId', e.target.value)}
                      className="text-xs h-8"
                    />
                  </div>
                  <div className="flex-1">
                    <Input
                      placeholder="实例名称（如：宁德时代）"
                      value={ref.instanceName || ''}
                      onChange={e => updateRef(idx, 'instanceName', e.target.value)}
                      className="text-xs h-8"
                    />
                  </div>
                  {formRefs.length > 1 && (
                    <Button variant="ghost" size="icon" className="h-8 w-8 shrink-0" onClick={() => removeRef(idx)}>
                      <Trash2 className="w-3.5 h-3.5 text-red-400" />
                    </Button>
                  )}
                </div>
              ))}
              <p className="text-[10px] text-slate-400">
                至少填写对象类型ID。实例ID和实例名称可选，填写后资讯会同时挂载到该实例。
              </p>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>取消</Button>
            <Button onClick={handleSave} disabled={saving}>
              {saving && <Loader2 className="w-4 h-4 animate-spin mr-1" />}
              {editingId ? '保存修改' : '创建'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Delete Confirm */}
      <Dialog open={deleteId !== null} onOpenChange={() => setDeleteId(null)}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle>确认删除</DialogTitle>
          </DialogHeader>
          <p className="text-sm text-slate-600">删除后无法恢复，确定要删除这条资讯吗？关联的节点引用也会被清理。</p>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteId(null)}>取消</Button>
            <Button variant="destructive" onClick={handleDelete}>删除</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Detail Sheet */}
      <Sheet open={detailOpen} onOpenChange={setDetailOpen}>
        <SheetContent side="right" className="w-[540px] sm:max-w-[540px] overflow-y-auto">
          <SheetHeader className="border-b border-slate-200 pb-4 mb-4">
            <SheetTitle className="text-lg font-bold text-slate-900 text-left pr-6">
              {detailDoc?.title}
            </SheetTitle>
          </SheetHeader>

          {detailDoc && (
            <div className="space-y-5">
              {/* Metadata */}
              <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
                <div>
                  <span className="text-slate-400 text-xs">来源类型</span>
                  <div className="mt-0.5">
                    <Badge className={`${getSourceTypeMeta(detailDoc.sourceType).color} border-0 text-[10px]`} variant="outline">
                      {getSourceTypeMeta(detailDoc.sourceType).label}
                    </Badge>
                  </div>
                </div>
                <div>
                  <span className="text-slate-400 text-xs">来源</span>
                  <div className="mt-0.5 text-slate-700">{detailDoc.sourceName || '-'}</div>
                </div>
                <div>
                  <span className="text-slate-400 text-xs">作者</span>
                  <div className="mt-0.5 text-slate-700">{detailDoc.authors || '-'}</div>
                </div>
                <div>
                  <span className="text-slate-400 text-xs">信息日期</span>
                  <div className="mt-0.5 text-slate-700">{formatDate(detailDoc.entryDate)}</div>
                </div>
              </div>

              {/* Linked nodes */}
              {detailRefs.length > 0 && (
                <div>
                  <span className="text-xs text-slate-400">关联节点</span>
                  <div className="flex flex-wrap gap-1.5 mt-1.5">
                    {detailRefs.map((ref, i) => (
                      <Badge key={i} variant="outline" className="bg-blue-50 text-blue-700 border-blue-200 text-[11px]">
                        {ref.instanceName || ref.refObjectTypeId || '未知'}
                      </Badge>
                    ))}
                  </div>
                </div>
              )}

              {/* Content */}
              {detailDoc.content && (
                <div className="border-t border-slate-100 pt-4">
                  <span className="text-xs text-slate-400">正文</span>
                  <div className="mt-2">
                    <MarkdownRender content={detailDoc.content} />
                  </div>
                </div>
              )}
            </div>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
}
