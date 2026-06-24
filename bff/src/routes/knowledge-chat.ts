import { Router } from 'express';
import fetch from 'node-fetch';

const router = Router();

function getProjectId(req: any): string {
  return (req.query?.projectId as string) || 'project_public';
}

const MCP_CLIENT_URL = process.env.MCP_CLIENT_URL || 'http://localhost:8001';

router.post('/', async (req, res) => {
  try {
    const projectId = getProjectId(req);
    const { message, session_id } = req.body;
    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    const response = await fetch(`${MCP_CLIENT_URL}/api/chat`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message, session_id, project_id: projectId }),
    });

    if (!response.ok) {
      const error = await response.text();
      return res.status(response.status).json({ error: error || 'MCP Client error' });
    }

    const data = await response.json();
    res.json(data);
  } catch (err: any) {
    console.error('[KnowledgeChat] Error:', err.message);
    res.status(502).json({ error: `MCP Client unavailable: ${err.message}` });
  }
});

// SSE streaming endpoint
router.post('/stream', async (req, res) => {
  try {
    const projectId = getProjectId(req);
    const { message, session_id } = req.body;
    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    // Set SSE headers
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('X-Accel-Buffering', 'no');
    res.flushHeaders();

    const mcpResponse = await fetch(`${MCP_CLIENT_URL}/api/chat/stream`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message, session_id, project_id: projectId }),
    });

    if (!mcpResponse.ok) {
      const error = await mcpResponse.text();
      res.write(`data: ${JSON.stringify({ type: 'error', content: error })}\n\n`);
      res.end();
      return;
    }

    // Pipe SSE stream
    const reader = mcpResponse.body;
    if (reader) {
      reader.on('data', (chunk: Buffer) => {
        res.write(chunk.toString());
      });
      reader.on('end', () => {
        res.end();
      });
      reader.on('error', (err: any) => {
        res.write(`data: ${JSON.stringify({ type: 'error', content: err.message })}\n\n`);
        res.end();
      });
    }
  } catch (err: any) {
    console.error('[KnowledgeChat Stream] Error:', err.message);
    res.write(`data: ${JSON.stringify({ type: 'error', content: `MCP Client unavailable: ${err.message}` })}\n\n`);
    res.end();
  }
});

// Health check for the MCP client
router.get('/health', async (_req, res) => {
  try {
    const response = await fetch(`${MCP_CLIENT_URL}/health`);
    const data = await response.json();
    res.json(data);
  } catch (err: any) {
    res.status(502).json({ error: `MCP Client unavailable: ${err.message}` });
  }
});

export default router;
