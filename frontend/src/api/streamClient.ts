// 流式API客户端
function currentProjectQuery() {
  const projectId =
    typeof window !== 'undefined'
      ? window.localStorage.getItem('currentProjectId') || 'project_public'
      : 'project_public';
  return `projectId=${encodeURIComponent(projectId)}`;
}

export interface StreamMessage {
  content?: string;
  done?: boolean;
  ontology?: any;
  error?: string;
  fullContent?: string;
  json?: any;
  parseError?: string;
  // Knowledge chat stream fields
  type?: string;
  tool?: string;
  input?: string;
  output?: string;
  session_id?: string;
  // Router stream fields
  intent?: string;
  reason?: string;
  data?: any;
  notice?: string;
}

// AI工作室流式对话
export async function* streamConversation(
  message: string,
  sessionId?: string,
  includeCurrentOntology?: boolean
): AsyncGenerator<StreamMessage, void, unknown> {
  const response = await fetch(`/api/ai/conversation/stream?${currentProjectQuery()}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message,
      sessionId,
      includeCurrentOntology,
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(error);
  }

  const reader = response.body?.getReader();
  if (!reader) {
    throw new Error('No response body');
  }

  const decoder = new TextDecoder();
  let buffer = '';

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.slice(6);
          if (data) {
            try {
              const parsed = JSON.parse(data);
              yield parsed;
            } catch (e) {
              // Ignore parse errors
            }
          }
        }
      }
    }
  } finally {
    reader.releaseLock();
  }
}

// 数据飞轮本体抽取流式输出
export async function* streamOntologyExtraction(
  title: string,
  content: string
): AsyncGenerator<StreamMessage, void, unknown> {
  const response = await fetch(`/api/data-wheel/extract?${currentProjectQuery()}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ title, content }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(error);
  }

  const reader = response.body?.getReader();
  if (!reader) {
    throw new Error('No response body');
  }

  const decoder = new TextDecoder();
  let buffer = '';

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.slice(6);
          if (data) {
            try {
              const parsed = JSON.parse(data);
              yield parsed;
            } catch (e) {
              // Ignore parse errors
            }
          }
        }
      }
    }
  } finally {
    reader.releaseLock();
  }
}

// 研究智能体产业链问答流式对话
export async function* streamResearchChat(
  agentId: string,
  message: string
): AsyncGenerator<StreamMessage, void, unknown> {
  const response = await fetch(`/api/research-agents/${agentId}/chat/stream?${currentProjectQuery()}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message,
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(error);
  }

  const reader = response.body?.getReader();
  if (!reader) {
    throw new Error('No response body');
  }

  const decoder = new TextDecoder();
  let buffer = '';

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.slice(6);
          if (data) {
            try {
              const parsed = JSON.parse(data);
              yield parsed;
            } catch (e) {
              // Ignore parse errors
            }
          }
        }
      }
    }
  } finally {
    reader.releaseLock();
  }
}

// 统一路由对话（通过意图识别自动分发）
export async function* streamRouterChat(
  message: string,
  sessionId?: string
): AsyncGenerator<StreamMessage, void, unknown> {
  const response = await fetch(`/api/ai/router/stream?${currentProjectQuery()}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message, sessionId }),
  });

  if (!response.ok) {
    throw new Error(`Router request failed: ${response.status}`);
  }

  const reader = response.body!.getReader();
  const decoder = new TextDecoder();
  let buffer = '';

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          try {
            const data = JSON.parse(line.slice(6));
            yield data;
          } catch {
            // ignore malformed JSON
          }
        }
      }
    }
  } finally {
    reader.releaseLock();
  }
}


// 知识库聊天流式对话（通过 MCP Agent）
export async function* streamKbChat(
  message: string,
  sessionId?: string
): AsyncGenerator<StreamMessage, void, unknown> {
  const response = await fetch(`/api/knowledge-chat/stream?${currentProjectQuery()}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message, session_id: sessionId }),
  });

  if (!response.ok) {
    throw new Error(`Chat request failed: ${response.status}`);
  }

  const reader = response.body!.getReader();
  const decoder = new TextDecoder();
  let buffer = '';

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          try {
            const data = JSON.parse(line.slice(6));
            yield data;
          } catch {
            // ignore malformed JSON
          }
        }
      }
    }
  } finally {
    reader.releaseLock();
  }
}
