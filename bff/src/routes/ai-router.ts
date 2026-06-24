import { Router } from 'express';
import fetch from 'node-fetch';

const router = Router();

// ── Configuration ──────────────────────────────────────────────────────────────
const DEEPSEEK_API_KEY = process.env.DEEPSEEK_API_KEY;
const DEEPSEEK_BASE_URL = process.env.DEEPSEEK_BASE_URL || 'https://api.deepseek.com';
const MODEL = 'deepseek-chat';
const JAVA_BACKEND = process.env.JAVA_BACKEND_URL || 'http://localhost:8080';
const MCP_CLIENT_URL = process.env.MCP_CLIENT_URL || 'http://localhost:8001';

// ── Session Store ──────────────────────────────────────────────────────────────
interface RouterSession {
  id: string;
  history: { role: string; content: string }[];
  currentOntology: any;
  mcpSessionId?: string;
  lastIntent?: string;
  createdAt: number;
}

const sessions = new Map<string, RouterSession>();

// Session cleanup (every 30 minutes)
const SESSION_TTL = 60 * 60 * 1000; // 1 hour
setInterval(() => {
  const now = Date.now();
  for (const [id, session] of sessions) {
    if (now - session.createdAt > SESSION_TTL) {
      sessions.delete(id);
    }
  }
}, 30 * 60 * 1000);

// ── Helpers ────────────────────────────────────────────────────────────────────

function getProjectId(req: any): string {
  return (req.query?.projectId as string) || 'project_public';
}

function checkAI(): boolean {
  return !!DEEPSEEK_API_KEY;
}

// ── Intent Classification ─────────────────────────────────────────────────────
async function classifyIntent(
  message: string,
  lastExchanges: { role: string; content: string }[],
  lastIntent?: string
): Promise<{ intent: string; reason: string }> {
  const SYSTEM_PROMPT = `你是一个意图分类器。根据用户的消息和历史上下文，判断其核心意图。

输出格式（仅JSON，不要其他内容）：
{"intent":"<intent>","reason":"<简短理由>"}

intent 可选值：
- ontology_design: 用户想要构建、修改、查询或讨论本体图谱（对象类型、属性、关系、动作），或与图谱建模相关
- knowledge_mount: 用户想将非结构化资讯/知识提取并挂载到图谱节点上，或与资讯提取、知识库相关
- general_chat: 普通对话、查询、闲聊，或不确定时使用`;

  let contextText = '';
  if (lastExchanges.length > 0) {
    contextText = '\n\n最近对话：\n' + lastExchanges
      .map(e => `${e.role === 'user' ? '用户' : '助手'}: ${e.content.slice(0, 500)}`)
      .join('\n');
  }
  if (lastIntent) {
    contextText += `\n\n上轮意图：${lastIntent}`;
  }

  const messages = [
    { role: 'system', content: SYSTEM_PROMPT },
    { role: 'user', content: `用户消息：${message}${contextText}` },
  ];

  const response = await fetch(`${DEEPSEEK_BASE_URL}/chat/completions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
    },
    body: JSON.stringify({
      model: MODEL,
      messages,
      temperature: 0.1,
      max_tokens: 150,
    }),
  });

  if (!response.ok) throw new Error(`Classification API error: ${await response.text()}`);

  const data = await response.json() as any;
  const text = data.choices?.[0]?.message?.content || '';

  try {
    return JSON.parse(text);
  } catch {
    const match = text.match(/\{[\s\S]*?"intent"[\s\S]*?\}/);
    if (match) return JSON.parse(match[0]);
    return { intent: 'general_chat', reason: '分类解析失败，默认兜底' };
  }
}

function buildClassificationContext(session: RouterSession): { role: string; content: string }[] {
  return session.history.slice(-4);
}

// ── Finish helper (shared across handlers) ────────────────────────────────────
function finish(session: RouterSession, res: any, emit: (data: any) => void, fullContent?: string) {
  if (fullContent) {
    session.history.push({ role: 'assistant', content: fullContent });
  }
  emit({ type: 'done', session_id: session.id });
  try { res.end(); } catch { /* ignore if already closed */ }
}

// ── Handlers ──────────────────────────────────────────────────────────────────

async function handleGeneralChat(
  session: RouterSession,
  _message: string,
  _projectId: string,
  emit: (data: any) => void,
  res: any
) {
  const GENERAL_PROMPT = `你是一位知识图谱领域的 AI 助手。你可以：
1. 回答用户关于图谱建模、数据分析的问题
2. 处理各种查询和对话任务
3. 提供建议和分析

请用中文回复用户。`;

  const messages: { role: string; content: string }[] = [
    { role: 'system', content: GENERAL_PROMPT },
    ...session.history.slice(0, -1).map(h => ({ role: h.role, content: h.content })),
  ];

  const response = await fetch(`${DEEPSEEK_BASE_URL}/chat/completions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
    },
    body: JSON.stringify({ model: MODEL, messages, temperature: 0.7, max_tokens: 4096, stream: true }),
  });

  if (!response.ok) {
    emit({ type: 'error', content: `DeepSeek API error: ${await response.text()}` });
    finish(session, res, emit);
    return;
  }

  await streamDeepSeek(response, session, emit, res, true);
}

async function handleOntologyDesign(
  session: RouterSession,
  message: string,
  projectId: string,
  emit: (data: any) => void,
  res: any
) {
  const ONTOLOGY_PROMPT = `你是 Palantir Foundry Ontology 专家。你的任务是帮助用户设计和完善本体（Ontology）。

本体包含以下核心概念：
1. Object Type（对象类型）- 业务实体，如公司、产品、订单
2. Property（属性）- 对象的特征，如名称、价格、状态
3. Link Type（关系类型）- 对象间的关联，如公司拥有产品
4. Action Type（动作类型）- 可执行的业务操作

设计原则：
- 每个 Object Type 应有明确的数据集支持（backing_dataset）
- 属性应包含类型、是否主键、描述
- 关系应定义源对象、目标对象、基数（1:1, 1:N, N:M）
- 动作应定义参数和规则

请用中文与用户交流，但生成的本体 ID 使用英文。`;

  // Build messages
  const messages: { role: string; content: string }[] = [
    { role: 'system', content: ONTOLOGY_PROMPT },
  ];

  for (const h of session.history.slice(0, -1)) {
    messages.push({ role: h.role, content: h.content });
  }

  if (session.history.length === 1) {
    let contextPrefix = '';
    try {
      const resp = await fetch(`${JAVA_BACKEND}/api/ontology?projectId=${encodeURIComponent(projectId)}`);
      const dbOntology = await resp.json() as any;
      if (dbOntology.objectTypes?.length > 0) {
        contextPrefix = `\n\n[当前已有本体]\n\`\`\`json\n${JSON.stringify(dbOntology, null, 2)}\n\`\`\`\n\n在此基础上进行修改。`;
      }
    } catch { /* ignore fetch errors */ }
    messages.push({ role: 'user', content: message + contextPrefix });
  } else {
    messages.push({ role: 'user', content: message });
  }

  const response = await fetch(`${DEEPSEEK_BASE_URL}/chat/completions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
    },
    body: JSON.stringify({ model: MODEL, messages, temperature: 0.7, max_tokens: 4096, stream: true }),
  });

  if (!response.ok) {
    emit({ type: 'error', content: `DeepSeek API error: ${await response.text()}` });
    finish(session, res, emit);
    return;
  }

  await streamDeepSeek(response, session, emit, res, true, (fullContent) => {
    // Extract ontology JSON from full response
    let ontology: any = null;
    const jsonMatch = fullContent.match(/```json\s*([\s\S]*?)```/);
    if (jsonMatch) {
      try {
        ontology = JSON.parse(jsonMatch[1]);
        session.currentOntology = ontology;
      } catch { /* ignore parse error */ }
    }
    if (ontology) {
      emit({ type: 'ontology', data: ontology });
    }
  });
}

async function handleKnowledgeMount(
  session: RouterSession,
  message: string,
  projectId: string,
  emit: (data: any) => void,
  res: any
) {
  // Build context seed from recent history so MCP agent understands the conversation
  let contextMsg = message;
  const recentHistory = session.history.slice(-3, -1);
  if (recentHistory.length > 0) {
    const contextText = recentHistory
      .map(h => `${h.role === 'user' ? '用户' : '助手'}：${h.content.slice(0, 1000)}`)
      .join('\n');
    contextMsg = `[对话上下文]\n${contextText}\n\n[用户当前消息]\n${message}`;
  }

  let mcpResponse;
  try {
    mcpResponse = await fetch(`${MCP_CLIENT_URL}/api/chat/stream`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        message: contextMsg,
        session_id: session.mcpSessionId,
        project_id: projectId,
      }),
    });
  } catch (err: any) {
    // MCP unavailable → fallback to general chat
    emit({ type: 'notice', content: '资讯挂载服务暂不可用，已切换为通用对话模式。' });
    return handleGeneralChat(session, message, projectId, emit, res);
  }

  if (!mcpResponse.ok) {
    emit({ type: 'notice', content: '资讯挂载服务暂不可用，已切换为通用对话模式。' });
    return handleGeneralChat(session, message, projectId, emit, res);
  }

  const reader = mcpResponse.body;
  if (!reader) {
    emit({ type: 'error', content: 'No response body from MCP' });
    finish(session, res, emit);
    return;
  }

  let fullContent = '';
  let finished = false;

  // MCP stream timeout: 120 seconds
  const MCP_TIMEOUT = 120_000;
  const mcpTimeout = setTimeout(() => {
    if (finished) return;
    finished = true;
    console.error('[KnowledgeMount] Stream timeout');
    emit({ type: 'notice', content: '资讯分析超时，已切换为通用对话模式。' });
    finish(session, res, emit, fullContent);
  }, MCP_TIMEOUT);

  reader.on('data', (chunk: Buffer) => {
    if (finished) return;
    const text = chunk.toString();
    const lines = text.split('\n');

    for (const line of lines) {
      if (line.startsWith('data: ')) {
        try {
          const data = JSON.parse(line.slice(6));
          if (data.type === 'done') {
            if (data.session_id) {
              session.mcpSessionId = data.session_id;
            }
            fullContent = data.fullContent || fullContent;
          }
          emit(data);
        } catch { /* skip malformed */ }
      }
    }
  });

  reader.on('end', () => {
    clearTimeout(mcpTimeout);
    if (!finished) {
      finished = true;
      finish(session, res, emit, fullContent);
    }
  });

  reader.on('error', (err: any) => {
    clearTimeout(mcpTimeout);
    if (finished) return;
    finished = true;
    console.error('[KnowledgeMount] Stream error:', err.message);
    emit({ type: 'error', content: err.message });
    finish(session, res, emit, fullContent);
  });
}

// ── DeepSeek Stream Processor (shared by general_chat & ontology_design) ─────
async function streamDeepSeek(
  deepseekResponse: any,
  session: RouterSession,
  emit: (data: any) => void,
  res: any,
  extractOntology: boolean,
  onComplete?: (fullContent: string) => void
) {
  const reader = deepseekResponse.body;
  if (!reader) {
    emit({ type: 'error', content: 'No response body from DeepSeek' });
    finish(session, res, emit);
    return;
  }

  let fullContent = '';
  let finished = false;
  const decoder = new TextDecoder();

  reader.on('data', (chunk: Buffer) => {
    if (finished) return;
    const text = decoder.decode(chunk, { stream: true });
    const lines = text.split('\n');

    for (const line of lines) {
      if (finished) return;
      if (line.startsWith('data: ')) {
        const data = line.slice(6);
        if (data === '[DONE]') {
          finished = true;
          if (extractOntology && onComplete) {
            onComplete(fullContent);
          }
          finish(session, res, emit, fullContent);
          return;
        }

        try {
          const parsed = JSON.parse(data);
          const content = parsed.choices?.[0]?.delta?.content || '';
          if (content) {
            fullContent += content;
            emit({ type: 'token', content });
          }
        } catch { /* skip incomplete chunks */ }
      }
    }
  });

  reader.on('error', (err: any) => {
    if (finished) return;
    finished = true;
    console.error('[DeepSeek Stream] Error:', err.message);
    emit({ type: 'error', content: err.message });
    finish(session, res, emit, fullContent);
  });
}

// ── Main Router Endpoint ──────────────────────────────────────────────────────

router.post('/stream', async (req, res) => {
  if (!checkAI()) {
    return res.status(503).json({ error: 'DEEPSEEK_API_KEY not configured' });
  }

  try {
    const projectId = getProjectId(req);
    const { message, sessionId } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    // 1. Get or create session
    let session = sessionId ? sessions.get(sessionId) : null;
    if (!session) {
      session = {
        id: crypto.randomUUID(),
        history: [],
        currentOntology: null,
        createdAt: Date.now(),
      };
      sessions.set(session.id, session);
    }

    // SSE headers
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('X-Accel-Buffering', 'no');
    res.flushHeaders();

    const emit = (data: any) => {
      try { res.write(`data: ${JSON.stringify(data)}\n\n`); } catch { /* ignore write errors */ }
    };

    // Store user message in history before processing
    session.history.push({ role: 'user', content: message });

    // 2. Intent classification
    // If we have an active MCP session, continue knowledge_mount for follow-ups
    let classification: { intent: string; reason: string };

    if (session.lastIntent === 'knowledge_mount' && session.mcpSessionId) {
      // Still re-classify, but for short follow-ups ("确认", "是的", etc.) keep knowledge_mount
      const context = buildClassificationContext(session);
      try {
        classification = await classifyIntent(message, context, session.lastIntent);
      } catch (err: any) {
        classification = { intent: 'general_chat', reason: '分类服务异常，默认兜底' };
      }
      // Short follow-ups in an active MCP conversation → stay in knowledge_mount
      if (classification.intent !== 'knowledge_mount' && message.length < 30) {
        classification = { intent: 'knowledge_mount', reason: '延续上轮资讯挂载对话' };
      }
    } else {
      const context = buildClassificationContext(session);
      try {
        classification = await classifyIntent(message, context, session.lastIntent);
      } catch (err: any) {
        console.error('[Router] Classification error:', err.message);
        classification = { intent: 'general_chat', reason: '分类服务异常，默认兜底' };
      }
    }

    session.lastIntent = classification.intent;
    emit({ type: 'intent', intent: classification.intent, reason: classification.reason });

    // 3. Route based on intent
    switch (classification.intent) {
      case 'ontology_design':
        await handleOntologyDesign(session, message, projectId, emit, res);
        break;
      case 'knowledge_mount':
        await handleKnowledgeMount(session, message, projectId, emit, res);
        break;
      case 'general_chat':
      default:
        await handleGeneralChat(session, message, projectId, emit, res);
        break;
    }
  } catch (err: any) {
    console.error('[Router] Fatal error:', err.message);
    if (!res.headersSent) {
      res.status(500).json({ error: err.message });
    } else {
      try { res.write(`data: ${JSON.stringify({ type: 'error', content: err.message })}\n\n`); } catch {}
      try { res.end(); } catch {}
    }
  }
});

// Apply router session ontology to the database
router.post('/apply', async (req, res) => {
  try {
    const { sessionId } = req.body;
    if (!sessionId) {
      return res.status(400).json({ error: 'sessionId is required' });
    }
    const session = sessions.get(sessionId);
    if (!session || !session.currentOntology) {
      return res.status(404).json({ error: 'No ontology in this session' });
    }

    const ont = session.currentOntology;
    const projectId = getProjectId(req);

    // Import object types
    for (const ot of ont.objectTypes || []) {
      await fetch(`${JAVA_BACKEND}/api/object-types?projectId=${encodeURIComponent(projectId)}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(ot),
      });
    }

    // Import link types
    for (const lt of ont.linkTypes || []) {
      await fetch(`${JAVA_BACKEND}/api/link-types?projectId=${encodeURIComponent(projectId)}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(lt),
      });
    }

    // Get updated ontology
    const response = await fetch(`${JAVA_BACKEND}/api/ontology?projectId=${encodeURIComponent(projectId)}`);
    const data = await response.json();

    res.json({ success: true, data });
  } catch (err: any) {
    console.error('[Router Apply] Error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

export default router;
