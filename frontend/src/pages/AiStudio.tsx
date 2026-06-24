import React, { useState, useRef, useEffect, useMemo, useCallback } from 'react';
import { OntologyData } from '@/src/store/ontologyStore';
import { Button } from '@/src/components/ui/button';
import { Badge } from '@/src/components/ui/badge';
import {
  Sparkles, Loader2, Database, Link as LinkIcon, ArrowRight, Plus,
  CheckCircle2, Send, RotateCcw, Download, MessageSquare, Eye, X,
  ChevronDown, ChevronRight, Key, Layers, Trash2, Clock, PenLine,
  History, Square, FileText, Bookmark, Save,
} from 'lucide-react';
import { toast } from 'sonner';
import { api, ConversationResponse } from '@/src/api/client';
import { streamRouterChat } from '@/src/api/streamClient';

import {
  ReactFlow,
  MiniMap,
  Controls,
  Background,
  useNodesState,
  useEdgesState,
  Handle,
  Position,
  NodeProps,
  Edge,
} from '@xyflow/react';
import '@xyflow/react/dist/style.css';
import dagre from 'dagre';
import { cn } from '@/src/lib/utils';

// ── Mini graph components for preview ─────────────────────────────────────────

const MiniObjectNode = ({ data }: NodeProps) => (
  <div className="px-3 py-2 shadow-md rounded-lg bg-white border-2 min-w-[160px]"
    style={{ borderColor: data.color as string || '#3b82f6' }}>
    <Handle type="target" position={Position.Top} className="w-1.5 h-1.5" style={{ background: data.color as string }} />
    <Handle type="target" position={Position.Left} className="w-1.5 h-1.5" style={{ background: data.color as string }} />
    <div className="flex items-center gap-1.5 mb-1">
      <Database className="w-3 h-3" style={{ color: data.color as string }} />
      <span className="font-bold text-xs text-slate-900">{data.label as string}</span>
    </div>
    <div className="text-[10px] text-slate-400 font-mono">{data.id as string}</div>
    <div className="text-[10px] text-slate-500 mt-1">{(data.propCount as number) || 0} properties</div>
    <Handle type="source" position={Position.Bottom} className="w-1.5 h-1.5" style={{ background: data.color as string }} />
    <Handle type="source" position={Position.Right} className="w-1.5 h-1.5" style={{ background: data.color as string }} />
  </div>
);

const miniNodeTypes = { objectType: MiniObjectNode };

const COLORS = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#06b6d4', '#ec4899', '#f97316'];

function buildGraphFromOntology(ontology: any) {
  if (!ontology?.objectTypes) return { nodes: [], edges: [] };

  const g = new dagre.graphlib.Graph();
  g.setDefaultEdgeLabel(() => ({}));
  g.setGraph({ rankdir: 'TB', nodesep: 80, ranksep: 100 });

  ontology.objectTypes.forEach((ot: any) => {
    g.setNode(ot.id, { width: 180, height: 70 });
  });
  (ontology.linkTypes || []).forEach((lt: any) => {
    g.setEdge(lt.sourceObjectId, lt.targetObjectId);
  });

  dagre.layout(g);

  const nodes = ontology.objectTypes.map((ot: any, i: number) => {
    const pos = g.node(ot.id);
    return {
      id: ot.id,
      type: 'objectType',
      position: { x: pos?.x || i * 220, y: pos?.y || i * 120 },
      data: {
        label: ot.name,
        id: ot.id,
        propCount: ot.properties?.length || 0,
        color: COLORS[i % COLORS.length],
      },
    };
  });

  const edges: Edge[] = (ontology.linkTypes || []).map((lt: any) => ({
    id: lt.id,
    source: lt.sourceObjectId,
    target: lt.targetObjectId,
    label: `${lt.name} (${lt.cardinality})`,
    animated: true,
    style: { stroke: '#94a3b8', strokeWidth: 1.5 },
    labelStyle: { fill: '#475569', fontWeight: 500, fontSize: 10 },
    labelBgStyle: { fill: '#f8fafc', fillOpacity: 0.9 },
    labelBgPadding: [3, 3] as [number, number],
    labelBgBorderRadius: 3,
  }));

  return { nodes, edges };
}

// ── Types ─────────────────────────────────────────────────────────────────────

interface ChatMessage {
  role: 'user' | 'assistant' | 'system';
  text: string;
  ontology?: any;
  streaming?: boolean;
}

interface ConvRecord {
  id: string;
  title: string;
  created_at: string;
  updated_at: string;
}

function timeLabel(dateStr: string) {
  if (!dateStr) return '';
  const d = new Date(dateStr.includes('T') ? dateStr : dateStr + 'Z');
  const now = new Date();
  const diff = Math.floor((now.getTime() - d.getTime()) / 1000);
  if (diff < 60) return '刚刚';
  if (diff < 3600) return `${Math.floor(diff / 60)} 分钟前`;
  if (diff < 86400) return `${Math.floor(diff / 3600)} 小时前`;
  if (diff < 604800) return `${Math.floor(diff / 86400)} 天前`;
  return d.toLocaleDateString('zh-CN', { month: 'short', day: 'numeric' });
}

const WELCOME_MSG: ChatMessage = {
  role: 'system',
  text: '欢迎使用 AI图谱！我是你的图谱助手。\n\n你可以：\n• 描述你的业务领域，我来生成完整的数据本体\n• 要求我添加、修改或删除实体和关系\n• 让我为已有本体添加语义层信息\n• 提问关于本体设计的最佳实践\n\n每次对话我都会在已有本体基础上迭代改进。'
};

// ── Main Component ────────────────────────────────────────────────────────────

export function AiStudio({ data, onUpdate, embedded = false }: { data: OntologyData; onUpdate: (data: OntologyData) => void; embedded?: boolean }) {
  // History
  const [conversations, setConversations] = useState<ConvRecord[]>([]);
  const [activeConvId, setActiveConvId] = useState<string | null>(null);
  const [loadingHistory, setLoadingHistory] = useState(true);
  const [renamingId, setRenamingId] = useState<string | null>(null);
  const [renameVal, setRenameVal] = useState('');

  // Conversation
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [messages, setMessages] = useState<ChatMessage[]>([WELCOME_MSG]);
  const [input, setInput] = useState('');
  const [sending, setSending] = useState(false);
  const [applying, setApplying] = useState(false);
  const [pendingExtraction, setPendingExtraction] = useState<any>(null);
  const [pendingSaving, setPendingSaving] = useState(false);
  const [toolCalls, setToolCalls] = useState<{ name: string; label: string; status: 'running' | 'done' }[]>([]);
  const chatEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLTextAreaElement>(null);
  // AbortController for cancelling in-flight AI requests
  const abortControllerRef = useRef<AbortController | null>(null);
  // Track pending requests per conversation (for background generation)
  const pendingConvRef = useRef<Map<string, { msgs: ChatMessage[]; ontology: any }>>(new Map());

  // Preview ontology
  const [previewOntology, setPreviewOntology] = useState<any>(null);
  const [showPreview, setShowPreview] = useState(true);
  const [expandedObjects, setExpandedObjects] = useState<Set<string>>(new Set());

  // Preview graph
  const graphData = useMemo(() => buildGraphFromOntology(previewOntology), [previewOntology]);
  const [nodes, setNodes, onNodesChange] = useNodesState(graphData.nodes);
  const [edges, setEdges, onEdgesChange] = useEdgesState(graphData.edges);

  // Save timer ref for debouncing
  const saveTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  // Track last activity time for 24h session expiry
  const lastActivityRef = useRef<number>(Date.now());

  useEffect(() => {
    setNodes(graphData.nodes);
    setEdges(graphData.edges);
  }, [graphData, setNodes, setEdges]);

  // Auto scroll
  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // ── Load conversation list on mount, restore active if saved ──────────────
  useEffect(() => {
    api.getConversations()
      .then(async (res) => {
        setConversations(res.conversations);
        // Restore previously active conversation from localStorage
        const savedId = localStorage.getItem('aistudio_active_conv');
        if (savedId && res.conversations.some((c: any) => c.id === savedId)) {
          try {
            const conv = await api.getConversation(savedId);
            const msgs = parseConvMessages(conv.messages);
            const ontology = parseConvOntology(conv.preview_ontology);
            setActiveConvId(savedId);
            setMessages(msgs.length > 0 ? msgs : [WELCOME_MSG]);
            setPreviewOntology(ontology);
            if (ontology) setShowPreview(true);
          } catch {}
        }
      })
      .catch(() => {})
      .finally(() => setLoadingHistory(false));
  }, []);

  // Refs to track latest values for unmount save
  const activeConvIdRef = useRef(activeConvId);
  const messagesRef = useRef(messages);
  const previewOntologyRef = useRef(previewOntology);
  activeConvIdRef.current = activeConvId;
  messagesRef.current = messages;
  previewOntologyRef.current = previewOntology;

  // Persist activeConvId to localStorage
  useEffect(() => {
    if (activeConvId) {
      localStorage.setItem('aistudio_active_conv', activeConvId);
    }
  }, [activeConvId]);

  // Save messages before unmount (via refs to capture latest values)
  useEffect(() => {
    return () => {
      const cid = activeConvIdRef.current;
      const msgs = messagesRef.current;
      if (cid && msgs.length > 1) {
        api.updateConversation(cid, {
          messages: msgs,
          preview_ontology: previewOntologyRef.current,
        }).catch(() => {});
      }
    };
  }, []);

  // ── Helpers for conversation message parsing ──────────────────────────────
  function parseConvMessages(messages: any): ChatMessage[] {
    if (!messages) return [];
    if (Array.isArray(messages)) return messages as ChatMessage[];
    if (typeof messages === 'string') {
      try { return JSON.parse(messages); } catch { return []; }
    }
    return [];
  }

  function parseConvOntology(ontology: any): any {
    if (!ontology) return null;
    if (typeof ontology === 'string') {
      try { return JSON.parse(ontology); } catch { return null; }
    }
    return ontology;
  }

  // ── Auto-save conversation (debounced) ──────────────────────────────────────
  const saveConversation = useCallback((convId: string, msgs: ChatMessage[], ontology: any) => {
    if (saveTimerRef.current) clearTimeout(saveTimerRef.current);
    saveTimerRef.current = setTimeout(() => {
      api.updateConversation(convId, {
        messages: msgs,
        preview_ontology: ontology,
      }).catch(() => {});
    }, 1000);
  }, []);

  // Immediate save (for unmount)
  const saveConversationImmediate = (convId: string, msgs: ChatMessage[], ontology: any) => {
    api.updateConversation(convId, {
      messages: msgs,
      preview_ontology: ontology,
    }).catch(() => {});
  };

  // ── Load a conversation ─────────────────────────────────────────────────────
  const loadConversation = async (convId: string) => {
    try {
      const conv = await api.getConversation(convId);
      const msgs = parseConvMessages(conv.messages);
      const ontology = parseConvOntology(conv.preview_ontology);
      setPendingExtraction(null); // clear any pending extraction from previous conversation

      // Auto-delete conversations with no real messages (corrupted or empty)
      if (msgs.length === 0 && conv.created_at) {
        const age = Date.now() - new Date(conv.created_at).getTime();
        if (age > 60 * 1000) { // older than 1 minute
          api.deleteConversation(convId).catch(() => {});
          setConversations(prev => prev.filter(c => c.id !== convId));
          setActiveConvId(null);
          setMessages([WELCOME_MSG]);
          setPreviewOntology(null);
          return;
        }
      }

      setActiveConvId(convId);
      setMessages(msgs.length > 0 ? msgs : [WELCOME_MSG]);
      setPreviewOntology(ontology);
      setSessionId(null); // Will start new session on next message
      if (ontology) setShowPreview(true);
    } catch (err: any) {
      toast.error('加载对话失败');
    }
  };

  // ── Create new conversation ─────────────────────────────────────────────────
  const handleNewConversation = async () => {
    try {
      const conv = await api.createConversation('新对话');
      setConversations(prev => [conv, ...prev]);
      setActiveConvId(conv.id);
      setSessionId(null);
      setPreviewOntology(null);
      setMessages([WELCOME_MSG]);
      setPendingExtraction(null);
    } catch (err: any) {
      toast.error(err.message);
    }
  };

  // ── Delete conversation ─────────────────────────────────────────────────────
  const handleDeleteConv = async (convId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    try {
      await api.deleteConversation(convId);
      setConversations(prev => prev.filter(c => c.id !== convId));
      if (activeConvId === convId) {
        setActiveConvId(null);
        setSessionId(null);
        setPreviewOntology(null);
        setMessages([WELCOME_MSG]);
        setPendingExtraction(null);
      }
      toast.success('对话已删除');
    } catch (err: any) {
      toast.error(err.message);
    }
  };

  // ── Rename conversation ─────────────────────────────────────────────────────
  const handleRename = async (convId: string) => {
    if (!renameVal.trim()) { setRenamingId(null); return; }
    try {
      await api.updateConversation(convId, { title: renameVal.trim() });
      setConversations(prev => prev.map(c => c.id === convId ? { ...c, title: renameVal.trim() } : c));
      setRenamingId(null);
    } catch (err: any) {
      toast.error(err.message);
    }
  };

  // ── Auto-title from first user message ──────────────────────────────────────
  const autoTitle = (convId: string, userMsg: string) => {
    const title = userMsg.slice(0, 30) + (userMsg.length > 30 ? '…' : '');
    api.updateConversation(convId, { title }).catch(() => {});
    setConversations(prev => prev.map(c => c.id === convId ? { ...c, title } : c));
  };

  // Stop the current in-flight request
  const handleStop = () => {
    abortControllerRef.current?.abort();
    abortControllerRef.current = null;
    setSending(false);
  };


  const handleSend = async () => {
    if (!input.trim() || sending) return;
    const msg = input.trim();

    // If there's a pending extraction and user is confirming, save directly
    if (pendingExtraction && /^(确认|是的|对|好|保存|yes|ok|是|嗯|可以|正确|没问题)\b/i.test(msg) && msg.length < 20) {
      setInput('');
      handleKbSave();
      return;
    }

    setInput('');
    // Auto-create conversation if none active
    let convId = activeConvId;
    const now = Date.now();
    if (convId && (now - lastActivityRef.current > 24 * 60 * 60 * 1000)) {
      convId = null; // expired session
    }
    if (!convId) {
      try {
        const conv = await api.createConversation('新对话');
        setConversations(prev => [conv, ...prev]);
        convId = conv.id;
        setActiveConvId(conv.id);
      } catch {
        toast.error('创建对话失败');
        return;
      }
    }
    lastActivityRef.current = now;

    const newMessages = [...messages, { role: 'user' as const, text: msg }];
    setMessages(newMessages);
    setSending(true);

    // Auto-title on first user message
    const userMsgCount = newMessages.filter(m => m.role === 'user').length;
    if (userMsgCount === 1 && convId) {
      autoTitle(convId, msg);
    }

    // Create abort controller for this request
    const abortController = new AbortController();
    abortControllerRef.current = abortController;

    // Snapshot for background generation
    const capturedConvId = convId;
    const capturedSessionId = sessionId;
    const capturedOntology = previewOntology;

    // Create streaming assistant message placeholder
    const streamingMsg: ChatMessage = { role: 'assistant', text: '', streaming: true };
    setMessages([...newMessages, streamingMsg]);

    let fullResponse = '';
    let newSessionId = capturedSessionId;

    try {
      streamLoop: for await (const chunk of streamRouterChat(msg, capturedSessionId || undefined)) {
        if (abortController.signal.aborted) break;

        switch (chunk.type) {
          case 'done':
            newSessionId = chunk.session_id || newSessionId;
            fullResponse = chunk.fullContent || fullResponse;
            break streamLoop;

          case 'intent':
            break;

          case 'token':
            fullResponse += chunk.content || '';
            setMessages(prev => {
              const msgs = [...prev];
              const last = msgs[msgs.length - 1];
              if (last && last.role === 'assistant' && last.streaming) {
                last.text = fullResponse;
              }
              return msgs;
            });
            break;

          case 'tool_start': {
            const toolLabel = chunk.tool === 'queryConceptGraph' ? '查询概念图谱' : chunk.tool === 'queryInstanceGraph' ? '查询实例数据' : '处理';
            setToolCalls(prev => [...prev.filter(t => t.name !== chunk.tool), { name: chunk.tool || '', label: toolLabel, status: 'running' }]);
            break;
          }

          case 'tool_end': {
            setToolCalls(prev => prev.map(t => t.name === chunk.tool ? { ...t, status: 'done' } : t));
            break;
          }

          case 'ontology':
            if (!capturedOntology) {
              setPreviewOntology(chunk.data);
              setShowPreview(true);
            }
            break;

          case 'notice':
            fullResponse += `\n[${chunk.content || ''}]\n`;
            setMessages(prev => {
              const msgs = [...prev];
              const last = msgs[msgs.length - 1];
              if (last && last.role === 'assistant' && last.streaming) {
                last.text = fullResponse;
              }
              return msgs;
            });
            break;

          case 'error':
            throw new Error(chunk.content || 'Unknown error');
        }
      }

      // Clear tool calls after stream ends
      setToolCalls([]);

      // Try to parse extraction JSON from response
      let parsedExtraction: any = null;
      if (fullResponse) {
        const jsonBlockMatch = fullResponse.match(/```json\s*([\s\S]*?)```/);
        if (jsonBlockMatch) {
          try { parsedExtraction = JSON.parse(jsonBlockMatch[1]); } catch {}
        }
        if (!parsedExtraction) {
          try { parsedExtraction = JSON.parse(fullResponse); } catch {}
        }
        if (!parsedExtraction) {
          const braceMatch = fullResponse.match(/\{(?:[^{}]|(?:\{[^{}]*\}))*"nodeRefs"(?:[^{}]|(?:\{[^{}]*\}))*\}/);
          if (braceMatch) {
            try { parsedExtraction = JSON.parse(braceMatch[0]); } catch {}
          }
        }
        if (parsedExtraction && parsedExtraction.title) {
          setPendingExtraction(parsedExtraction);
        }
      }

      // Determine final ontology from response
      let finalOntology: any = null;
      if (!parsedExtraction) {
        const jsonMatch = fullResponse.match(/```json\s*([\s\S]*?)```/);
        if (jsonMatch) {
          try {
            const parsed = JSON.parse(jsonMatch[1]);
            if (parsed.objectTypes || parsed.linkTypes) {
              finalOntology = parsed;
            }
          } catch {}
        }
      }

      const isStillActive = activeConvId === capturedConvId;

      // Update streaming placeholder
      const updatedMessages = newMessages.map((m, i) =>
        i === newMessages.length - 1 && m.role === 'assistant' && (m as any).streaming
          ? { ...m, text: fullResponse, streaming: false }
          : m
      ) as ChatMessage[];
      if (!updatedMessages.some(m => m.role === 'assistant' && m.text === fullResponse)) {
        updatedMessages.push({ role: 'assistant', text: fullResponse, streaming: false });
      }

      if (isStillActive) {
        setMessages(updatedMessages);
      }

      let newOntology = capturedOntology;
      if (finalOntology) {
        newOntology = finalOntology;
        if (isStillActive) {
          setPreviewOntology(finalOntology);
          setShowPreview(true);
        }
      }

      // Persist conversation
      if (capturedConvId) {
        saveConversation(capturedConvId, updatedMessages, newOntology);
      }

      // Store sessionId for next call
      setSessionId(newSessionId);

      if (!isStillActive) {
        toast.success('后台对话已完成，点击查看结果', {
          action: { label: '查看', onClick: () => loadConversation(capturedConvId!) },
        });
      }
    } catch (err: any) {
      if (err.name === 'AbortError' || abortController.signal.aborted) {
        const cancelledMessages = [...newMessages, {
          role: 'assistant' as const,
          text: '⏹ 已停止生成。',
        }];
        setMessages(cancelledMessages);
      } else {
        const errMessages = [...newMessages, { role: 'assistant' as const, text: `Error: ${err.message}` }];
        setMessages(errMessages);
      }
    } finally {
      abortControllerRef.current = null;
      setSending(false);
    }
  };

  const handleKbSave = async () => {
    if (!pendingExtraction) return;
    setPendingSaving(true);
    try {
      const refs = (pendingExtraction.nodeRefs || []).map((ref: any) => ({
        refObjectTypeId: ref.objectTypeId,
        refInstanceId: ref.instanceId || "",
        instanceName: ref.instanceName || "",
      }));
      const payload = {
        title: pendingExtraction.title || "未命名资讯",
        content: pendingExtraction.content || "",
        sourceType: pendingExtraction.sourceType || "other",
        sourceName: pendingExtraction.sourceName || "AI 录入",
        authors: pendingExtraction.authors || "AI",
        entryDate: pendingExtraction.entryDate || undefined,
        refs,
      };
      const res = await api.createKnowledgeBase(payload);
      if (res.success) {
        toast.success("资讯已保存到资讯库");
        setPendingExtraction(null);
      }
    } catch (err: any) {
      toast.error("保存失败: " + err.message);
    } finally {
      setPendingSaving(false);
    }
  };

  const handleApply = async () => {
    if (!sessionId || !previewOntology) return;
    setApplying(true);
    try {
      const result = await api.applyConversationOntology(sessionId);
      onUpdate(result.data);
      toast.success(`已导入 ${previewOntology.objectTypes?.length || 0} 个对象类型和 ${previewOntology.linkTypes?.length || 0} 个关系到数据库。`);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setApplying(false);
    }
  };

  const toggleExpand = (id: string) => {
    setExpandedObjects(prev => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  // Quick action buttons

  return (
    <div className={cn("flex h-full gap-0", !embedded && "-m-6")}>
      {/* ── Left: Conversation History Sidebar ────────────────────────────── */}
      <div className="w-56 bg-slate-50 border-r border-slate-200 flex flex-col shrink-0">
        {/* Sidebar Header */}
        <div className="p-3 border-b border-slate-200">
          <Button size="sm" className="w-full gap-1.5 h-8 text-xs bg-purple-600 hover:bg-purple-700" onClick={handleNewConversation}>
            <Plus className="w-3 h-3" /> 新建对话
          </Button>
        </div>

        {/* Conversation List */}
        <div className="flex-1 overflow-y-auto">
          {loadingHistory ? (
            <div className="flex items-center justify-center py-8 text-slate-400">
              <Loader2 className="w-4 h-4 animate-spin" />
            </div>
          ) : conversations.length === 0 ? (
            <div className="text-center py-8 px-3 text-slate-400">
              <History className="w-6 h-6 mx-auto mb-2 opacity-40" />
              <p className="text-xs">暂无对话记录</p>
              <p className="text-[10px] mt-1">点击上方按钮开始新对话</p>
            </div>
          ) : (
            <div className="py-1">
              {conversations.map(conv => (
                <div
                  key={conv.id}
                  onClick={() => loadConversation(conv.id)}
                  className={cn(
                    'group mx-1 my-0.5 px-3 py-2.5 rounded-lg cursor-pointer transition-all',
                    activeConvId === conv.id
                      ? 'bg-purple-100 border border-purple-200'
                      : 'hover:bg-slate-100 border border-transparent'
                  )}
                >
                  {renamingId === conv.id ? (
                    <input
                      autoFocus
                      className="w-full text-xs px-1 py-0.5 border border-purple-300 rounded bg-white focus:outline-none"
                      value={renameVal}
                      onChange={e => setRenameVal(e.target.value)}
                      onBlur={() => handleRename(conv.id)}
                      onKeyDown={e => { if (e.key === 'Enter') handleRename(conv.id); if (e.key === 'Escape') setRenamingId(null); }}
                      onClick={e => e.stopPropagation()}
                    />
                  ) : (
                    <div className="flex items-start gap-2">
                      <MessageSquare className={cn('w-3.5 h-3.5 shrink-0 mt-0.5',
                        activeConvId === conv.id ? 'text-purple-600' : 'text-slate-400')} />
                      <div className="flex-1 min-w-0">
                        <p className={cn('text-xs font-medium truncate',
                          activeConvId === conv.id ? 'text-purple-800' : 'text-slate-700')}>
                          {conv.title}
                        </p>
                        <p className="text-[10px] text-slate-400 mt-0.5">{timeLabel(conv.updated_at)}</p>
                      </div>
                      <div className="flex items-center gap-0.5 opacity-0 group-hover:opacity-100 transition-opacity shrink-0">
                        <button
                          onClick={(e) => { e.stopPropagation(); setRenamingId(conv.id); setRenameVal(conv.title); }}
                          className="p-0.5 rounded hover:bg-slate-200 text-slate-400 hover:text-slate-600"
                        >
                          <PenLine className="w-2.5 h-2.5" />
                        </button>
                        <button
                          onClick={(e) => handleDeleteConv(conv.id, e)}
                          className="p-0.5 rounded hover:bg-red-100 text-slate-400 hover:text-red-500"
                        >
                          <Trash2 className="w-2.5 h-2.5" />
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="p-2 border-t border-slate-200 text-center">
          <span className="text-[10px] text-slate-400">{conversations.length} 个对话</span>
        </div>
      </div>

      {/* ── Middle: Chat Panel ─────────────────────────────────────────────── */}
      <div className="flex flex-col bg-white border-r border-slate-200 flex-1"
        style={{ maxWidth: showPreview && previewOntology ? '50%' : '100%', minWidth: 380 }}>
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-slate-200 shrink-0">
          <div className="flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-purple-600" />
            <h1 className="font-bold text-lg text-slate-900">AI图谱</h1>
            {sessionId && (
              <Badge variant="outline" className="font-mono text-[10px] text-purple-600 border-purple-200">
                会话中
              </Badge>
            )}
          </div>
          <div className="flex gap-1.5">
            {previewOntology && (
              <Button variant="outline" size="sm" className="gap-1 text-xs h-7"
                onClick={() => setShowPreview(!showPreview)}>
                <Eye className="w-3 h-3" /> {showPreview ? '隐藏预览' : '显示预览'}
              </Button>
            )}
          </div>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-4 space-y-4">
          {messages.map((msg, i) => (
            <div key={i}>
              {msg.role === 'system' && (
                <div className="bg-purple-50 border border-purple-100 rounded-xl p-4 text-sm text-purple-800 whitespace-pre-wrap">
                  {msg.text}
                </div>
              )}
              {msg.role === 'user' && (
                <div className="flex justify-end">
                  <div className="bg-blue-600 text-white rounded-2xl rounded-tr-sm px-4 py-2.5 text-sm max-w-[85%] whitespace-pre-wrap">
                    {msg.text}
                  </div>
                </div>
              )}
              {msg.role === 'assistant' && (
                <div className="flex justify-start gap-2">
                  <div className="w-7 h-7 rounded-full bg-purple-100 text-purple-600 flex items-center justify-center shrink-0 mt-0.5">
                    <Sparkles className="w-3.5 h-3.5" />
                  </div>
                  <div className="bg-slate-50 text-slate-800 rounded-2xl rounded-tl-sm px-4 py-2.5 text-sm max-w-[85%] whitespace-pre-wrap leading-relaxed">
                    {msg.text}
                    {msg.ontology && (
                      <div className="mt-3 pt-2 border-t border-slate-200">
                        <div className="flex items-center gap-2 text-xs text-purple-600 font-medium">
                          <Layers className="w-3 h-3" />
                          生成了 {msg.ontology.objectTypes?.length || 0} 个实体，
                          {msg.ontology.linkTypes?.length || 0} 个关系
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          ))}
          {sending && !messages.some(m => m.role === 'assistant' && (m as any).streaming) && (
            <div className="flex justify-start gap-2">
              <div className="w-7 h-7 rounded-full bg-purple-100 text-purple-600 flex items-center justify-center shrink-0">
                <Sparkles className="w-3.5 h-3.5" />
              </div>
              <div className="bg-slate-50 rounded-2xl rounded-tl-sm px-4 py-3 text-sm flex items-center gap-3 text-slate-500">
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
                <span>思考中...</span>
                <button
                  onClick={handleStop}
                  className="flex items-center gap-1 text-xs text-red-500 hover:text-red-700 border border-red-200 hover:border-red-300 rounded-md px-2 py-0.5 transition-colors bg-white"
                >
                  <Square className="w-2.5 h-2.5" /> 停止
                </button>
              </div>
            </div>
          )}
            <div ref={chatEndRef} />
          </div>

        {/* ── Tool Call Activity Indicator ──────────────────────────── */}
        {sending && toolCalls.length > 0 && (
          <div className="px-4 py-2 border-t border-slate-100 shrink-0">
            <div className="flex items-center gap-3">
              {toolCalls.slice(-3).map((tc, i) => (
                <div key={i} className="flex items-center gap-1.5 text-xs">
                  {tc.status === 'running' ? (
                    <Loader2 className="w-3 h-3 animate-spin text-blue-500" />
                  ) : (
                    <span className="w-3 h-3 flex items-center justify-center text-green-600">✓</span>
                  )}
                  <span className={tc.status === 'running' ? 'text-slate-600' : 'text-slate-400 line-through'}>{tc.label}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* ── Knowledge Base Extraction Confirmation ────────────────── */}
        {pendingExtraction && (
          <div className="px-4 py-3 border-t border-slate-200 bg-amber-50 shrink-0">
            <div className="flex items-center justify-between mb-2">
              <h3 className="text-sm font-semibold text-slate-800 flex items-center gap-1.5">
                <FileText className="w-4 h-4 text-amber-600" />
                提取结果
              </h3>
            </div>
            <div className="space-y-1.5">
              <div className="text-xs">
                <span className="font-medium text-slate-500">标题：</span>
                <span className="text-slate-800">{pendingExtraction.title || '未命名'}</span>
              </div>
              {pendingExtraction.content && (
                <div className="text-xs">
                  <span className="font-medium text-slate-500">内容：</span>
                  <span className="text-slate-600 line-clamp-2">{pendingExtraction.content.substring(0, 200)}</span>
                </div>
              )}
              {pendingExtraction.nodeRefs && pendingExtraction.nodeRefs.length > 0 && (
                <div className="text-xs">
                  <span className="font-medium text-slate-500">关联节点：</span>
                  <div className="flex flex-wrap gap-1 mt-1">
                    {pendingExtraction.nodeRefs.map((ref: any, i: number) => (
                      <Badge key={i} variant="outline" className="text-[10px] bg-amber-100 text-amber-700 border-amber-200">
                        {ref.instanceName || ref.objectTypeId || '未知'}
                      </Badge>
                    ))}
                  </div>
                </div>
              )}
              <div className="flex items-center gap-2 pt-1.5">
                <Button size="sm" className="gap-1 h-8 text-xs bg-amber-600 hover:bg-amber-700"
                  onClick={handleKbSave} disabled={pendingSaving}>
                  {pendingSaving ? <Loader2 className="w-3 h-3 animate-spin" /> : <Save className="w-3 h-3" />}
                  {pendingSaving ? '保存中...' : '保存资讯'}
                </Button>
                <Button variant="outline" size="sm" className="gap-1 h-8 text-xs"
                  onClick={() => setPendingExtraction(null)} disabled={pendingSaving}>
                  取消
                </Button>
              </div>
            </div>
          </div>
        )}

        {/* Input */}
        <div className="p-4 border-t border-slate-200 shrink-0">
          {previewOntology && (
            <div className="flex items-center gap-2 mb-3 p-2 bg-green-50 border border-green-200 rounded-lg">
              <CheckCircle2 className="w-4 h-4 text-green-600 shrink-0" />
              <span className="text-xs text-green-700 flex-1">
                本体预览就绪 ({previewOntology.objectTypes?.length || 0} 实体, {previewOntology.linkTypes?.length || 0} 关系)
              </span>
              <Button size="sm" className="gap-1 h-7 text-xs bg-green-600 hover:bg-green-700"
                onClick={handleApply} disabled={applying}>
                {applying ? <Loader2 className="w-3 h-3 animate-spin" /> : <Download className="w-3 h-3" />}
                导入数据库
              </Button>
            </div>
          )}
          {/* Shortcut buttons (pre-fill input, no mode lock) */}
          <div className="flex items-center gap-2 mb-3">
            <button
              onClick={() => { setInput("根据以下信息来修改图谱："); inputRef.current?.focus(); }}
              className="px-3 py-1.5 text-xs font-medium rounded-full bg-purple-50 text-purple-700 hover:bg-purple-100 transition-colors">
              <Sparkles className="w-3 h-3 inline mr-1" />AI图谱
            </button>
            <button
              onClick={() => { setInput("请解析以下资讯并挂载到图谱对应节点中："); inputRef.current?.focus(); }}
              className="px-3 py-1.5 text-xs font-medium rounded-full bg-amber-50 text-amber-700 hover:bg-amber-100 transition-colors">
              <FileText className="w-3 h-3 inline mr-1" />资讯挂载
            </button>
          </div>

          <div className="flex gap-2">
            <textarea
              ref={inputRef}
              className="flex-1 min-h-[44px] max-h-[120px] p-3 rounded-xl border border-slate-200 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-purple-200 focus:border-purple-400"
              placeholder="描述你的业务领域、修改图谱，或粘贴资讯文本..."
              value={input}
              onChange={e => setInput(e.target.value)}
              onKeyDown={e => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault();
                  handleSend();
                }
              }}
              rows={1}
            />
            {sending ? (
              <Button onClick={handleStop}
                className="shrink-0 h-[44px] w-[44px] rounded-xl bg-red-500 hover:bg-red-600 p-0">
                <Square className="w-4 h-4" />
              </Button>
            ) : (
              <Button onClick={handleSend} disabled={!input.trim()}
                className="shrink-0 h-[44px] w-[44px] rounded-xl bg-purple-600 hover:bg-purple-700 p-0">
                <Send className="w-4 h-4" />
              </Button>
            )}
          </div>
        </div>
      </div>

      {/* ── Right: Preview Panel ───────────────────────────────────────────── */}
      {showPreview && previewOntology && (
        <div className="flex-1 flex flex-col bg-[#FAFBFC] min-w-[360px]">
          {/* Preview Header */}
          <div className="flex items-center justify-between p-4 border-b border-slate-200 bg-white shrink-0">
            <div className="flex items-center gap-2">
              <Eye className="w-4 h-4 text-slate-500" />
              <span className="font-semibold text-sm text-slate-900">本体预览</span>
            </div>
            <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => setShowPreview(false)}>
              <X className="w-3.5 h-3.5" />
            </Button>
          </div>

          {/* Mini Graph */}
          <div className="h-[280px] border-b border-slate-200 bg-white">
            <ReactFlow
              nodes={nodes}
              edges={edges}
              onNodesChange={onNodesChange}
              onEdgesChange={onEdgesChange}
              nodeTypes={miniNodeTypes}
              fitView
              attributionPosition="bottom-right"
              minZoom={0.3}
              maxZoom={1.5}
            >
              <Controls showInteractive={false} className="bg-white border-slate-200 shadow-sm" />
              <Background color="#e2e8f0" gap={20} />
            </ReactFlow>
          </div>

          {/* Object Types Detail List */}
          <div className="flex-1 overflow-y-auto p-4 space-y-3">
            {/* Stats */}
            <div className="grid grid-cols-2 gap-2">
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-2.5 text-center">
                <div className="text-lg font-bold text-blue-700">{previewOntology.objectTypes?.length || 0}</div>
                <div className="text-[10px] font-medium text-blue-600">实体类型</div>
              </div>
              <div className="bg-emerald-50 border border-emerald-200 rounded-lg p-2.5 text-center">
                <div className="text-lg font-bold text-emerald-700">{previewOntology.linkTypes?.length || 0}</div>
                <div className="text-[10px] font-medium text-emerald-600">语义关系</div>
              </div>
            </div>

            {/* Object Types Accordion */}
            <div className="space-y-2">
              <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-wider px-1">实体类型</h3>
              {(previewOntology.objectTypes || []).map((ot: any, i: number) => {
                const expanded = expandedObjects.has(ot.id);
                return (
                  <div key={ot.id} className="bg-white rounded-lg border border-slate-200 shadow-sm overflow-hidden">
                    <button
                      className="w-full flex items-center gap-2 p-3 text-left hover:bg-slate-50 transition-colors"
                      onClick={() => toggleExpand(ot.id)}>
                      {expanded ? <ChevronDown className="w-3.5 h-3.5 text-slate-400" /> : <ChevronRight className="w-3.5 h-3.5 text-slate-400" />}
                      <Database className="w-3.5 h-3.5" style={{ color: COLORS[i % COLORS.length] }} />
                      <span className="font-medium text-sm text-slate-900 flex-1">{ot.name}</span>
                      <Badge variant="secondary" className="text-[10px]">{ot.properties?.length || 0}</Badge>
                    </button>
                    {expanded && (
                      <div className="px-3 pb-3 border-t border-slate-100">
                        <p className="text-xs text-slate-500 py-2">{ot.description}</p>
                        <div className="space-y-1">
                          {(ot.properties || []).map((p: any) => (
                            <div key={p.id} className="flex items-center gap-2 text-xs py-1 px-2 rounded bg-slate-50">
                              {!!p.isPrimaryKey && <Key className="w-2.5 h-2.5 text-amber-500" />}
                              <span className="font-medium text-slate-700 flex-1 truncate">{p.name}</span>
                              <Badge variant="outline" className="text-[9px] font-mono h-4 px-1">{p.type}</Badge>
                              {p.typeClasses?.map((tc: string) => (
                                <Badge key={tc} variant="outline" className="text-[8px] font-mono h-4 px-1 text-purple-500 border-purple-200">{tc}</Badge>
                              ))}
                            </div>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>

            {/* Link Types */}
            {previewOntology.linkTypes?.length > 0 && (
              <div className="space-y-2">
                <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-wider px-1">语义关系</h3>
                {previewOntology.linkTypes.map((lt: any) => {
                  const src = previewOntology.objectTypes?.find((o: any) => o.id === lt.sourceObjectId)?.name || lt.sourceObjectId;
                  const tgt = previewOntology.objectTypes?.find((o: any) => o.id === lt.targetObjectId)?.name || lt.targetObjectId;
                  return (
                    <div key={lt.id} className="bg-white rounded-lg border border-slate-200 p-3 shadow-sm">
                      <div className="flex items-center gap-2">
                        <LinkIcon className="w-3.5 h-3.5 text-emerald-500" />
                        <span className="font-medium text-sm text-slate-900">{lt.name}</span>
                        <Badge variant="outline" className="font-mono text-[10px] h-4">{lt.cardinality}</Badge>
                      </div>
                      <div className="flex items-center gap-1 text-xs text-slate-500 mt-1 ml-5">
                        <span>{src}</span><ArrowRight className="w-3 h-3" /><span>{tgt}</span>
                      </div>
                      {lt.description && (
                        <p className="text-xs text-slate-400 mt-1 ml-5 italic">{lt.description}</p>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
