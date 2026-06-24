"""Ontology MCP Client - LangChain Agent Service

Connects to Spring AI MCP Server for ontology graph queries
and exposes a chat API via FastAPI.
"""

import os
import json
import uuid
import asyncio
import logging
from contextlib import asynccontextmanager
from typing import Optional

import dotenv
dotenv.load_dotenv()

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, create_model, Field

from mcp import ClientSession
from mcp.client.sse import sse_client

from langchain_openai import ChatOpenAI
from langchain.agents import create_agent
from langchain_core.tools import StructuredTool
from langchain_core.messages import HumanMessage, AIMessage

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("mcp-client")

# ── Configuration ───────────────────────────────────────────────────────────────

DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY", "")
MCP_SERVER_URL = os.getenv("MCP_SERVER_URL", "http://localhost:8081/sse")
HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", "8001"))

# ── MCP Client ──────────────────────────────────────────────────────────────────

class MCPClient:
    """Manages an MCP SSE connection to the Spring AI MCP Server with auto-reconnect."""

    def __init__(self, url: str):
        self.url = url
        self.session: Optional[ClientSession] = None
        self._transport_ctx = None
        self._session_ctx = None
        self.tools_meta = []
        self._reconnecting = False

    async def connect(self):
        """Connect (or reconnect) to the MCP server."""
        if self._reconnecting:
            logger.info("Reconnection already in progress, waiting...")
            for _ in range(30):
                await asyncio.sleep(0.5)
                if not self._reconnecting and self.session:
                    return
            raise RuntimeError("MCP reconnection timed out")

        self._reconnecting = True
        try:
            # Close old session state before creating new one
            await self._cleanup()
            transport_ctx = sse_client(self.url)
            transport = await transport_ctx.__aenter__()
            session_ctx = ClientSession(transport[0], transport[1])
            session = await session_ctx.__aenter__()
            await session.initialize()
            tools_result = await session.list_tools()
            # Only update instance state on success
            self._transport_ctx = transport_ctx
            self._session_ctx = session_ctx
            self.session = session
            self.tools_meta = tools_result.tools
            logger.info(f"MCP Client connected to {self.url}")
            logger.info(f"Available tools: {[t.name for t in self.tools_meta]}")
        finally:
            self._reconnecting = False

    @classmethod
    async def create(cls, url: str):
        """Factory method: creates and initializes the MCP client."""
        client = cls(url)
        await client.connect()
        return client

    async def _cleanup(self):
        """Close old session/transport without logging (used during reconnection)."""
        self.session = None
        if self._session_ctx:
            try:
                await self._session_ctx.__aexit__(None, None, None)
            except Exception:
                pass
            self._session_ctx = None
        if self._transport_ctx:
            try:
                await self._transport_ctx.__aexit__(None, None, None)
            except Exception:
                pass
            self._transport_ctx = None

    async def close(self):
        await self._cleanup()
        logger.info("MCP Client disconnected")

    async def call_tool(self, name: str, arguments: dict) -> str:
        """Call an MCP tool and return the text result. Full reconnect on error."""
        for attempt in range(2):
            if not self.session:
                logger.info("No active MCP session, reconnecting...")
                await self.connect()
                if not self.session:
                    raise RuntimeError("MCP session not initialized")

            try:
                result = await self.session.call_tool(name, arguments)
                if result.content:
                    texts = []
                    for c in result.content:
                        if hasattr(c, "text"):
                            texts.append(c.text)
                        elif isinstance(c, dict):
                            texts.append(json.dumps(c, ensure_ascii=False))
                        else:
                            texts.append(str(c))
                    return "\n".join(texts)
                return ""
            except Exception as e:
                if attempt == 0:
                    logger.warning(f"Tool call failed (attempt 1), full reconnect... ({e})")
                    await self._cleanup()
                    await self.connect()
                    continue
                logger.error(f"Tool call failed after reconnect: {e}")
                raise

# ── Global state ────────────────────────────────────────────────────────────────

mcp_client: Optional[MCPClient] = None
agent_executor = None
sessions: dict = {}

# ── Chat Models ─────────────────────────────────────────────────────────────────

class ChatRequest(BaseModel):
    message: str
    session_id: Optional[str] = None
    project_id: Optional[str] = "project_public"

class ChatResponse(BaseModel):
    session_id: str
    response: str

# ── Current request project context ──────────────────────────────────────────
_current_project_id: str = "project_public"

def set_current_project_id(pid: str):
    global _current_project_id
    _current_project_id = pid or "project_public"

# ── Agent Setup ─────────────────────────────────────────────────────────────────

def build_agent(client: MCPClient):
    """Create a LangChain agent with MCP tools."""

    if not DEEPSEEK_API_KEY:
        raise ValueError("DEEPSEEK_API_KEY is not configured")

    llm = ChatOpenAI(
        model="deepseek-chat",
        api_key=DEEPSEEK_API_KEY,
        base_url="https://api.deepseek.com",
        temperature=0.3,
        streaming=False,
    )

    # ── Dynamically create tools from MCP server metadata ───────────────

    type_map = {"string": str, "integer": int, "number": float, "boolean": bool}

    tools = []
    for meta in client.tools_meta:
        field_defs = {}
        input_schema = meta.inputSchema or {}
        for prop_name, prop_schema in input_schema.get("properties", {}).items():
            py_type = type_map.get(prop_schema.get("type", "string"), str)
            if "default" in prop_schema:
                field_defs[prop_name] = (py_type, Field(default=prop_schema["default"]))
            else:
                field_defs[prop_name] = (Optional[py_type], Field(default=None))

        DynamicModel = create_model(f"{meta.name}_input", **field_defs)

        async def _dynamic_call(tool_name=meta.name, **kwargs) -> str:
            # Inject current project_id so MCP tools filter by project
            if "projectId" not in kwargs or kwargs["projectId"] is None:
                kwargs["projectId"] = _current_project_id
            filtered = {k: v for k, v in kwargs.items() if v is not None}
            return await client.call_tool(tool_name, filtered)

        tool = StructuredTool(
            name=meta.name,
            description=meta.description or "",
            args_schema=DynamicModel,
            coroutine=_dynamic_call,
        )
        tools.append(tool)

    # ── System prompt ───────────────────────────────────────────────────────

    tool_descriptions = "\n".join(
        f"{i+1}. {t.name} - {t.description}"
        for i, t in enumerate(client.tools_meta)
    )

    system_prompt = f"""你是一个本体图谱智能解析助手，负责解析非结构化信息并与图谱节点匹配。保存操作由前端处理，你只需输出解析结果。
你有以下工具可以帮助用户：

{tool_descriptions}

信息解析流程：
当用户提供一段需挂载到图谱的信息（如新闻文章、行业动态、报告、笔记等）时：
1. 先用 queryConceptGraph 搜索并确定关联的对象类型节点（提取关键词进行搜索），仅使用 queryConceptGraph 即可，不需要调用 queryInstanceGraph
2. 在回答末尾，用以下 JSON 代码块格式输出提取的结构化数据（不要调用 saveKnowledgeEntry 或 queryInstanceGraph）：
   ```json
   {{{{"title": "资讯标题", "content": "正文", "sourceType": "industry_news", "sourceName": "来源说明", "authors": "作者", "entryDate": "2026-06-02T00:00:00", "nodeRefs": [{{"objectTypeId": "匹配的节点ID", "instanceId": "", "instanceName": "节点显示名称"}}]}}}}
   ```
   sourceType 可选值: industry_news / meeting_minutes / tech_report / internal_note / other
   nodeRefs 中 objectTypeId 是必填（填入查到的对象类型 ID），instanceName 是节点名称（可选）
   注意：输出 JSON 代码块后不要再向用户提问或要求确认，用户会自动看到保存按钮。

如果用户只是查询本体信息，则直接回答即可。
请用中文回答。"""

    agent = create_agent(
        model=llm,
        tools=tools,
        system_prompt=system_prompt,
        debug=False,
    )
    return agent

# ── FastAPI App ─────────────────────────────────────────────────────────────────

@asynccontextmanager
async def lifespan(app: FastAPI):
    global mcp_client, agent_executor
    try:
        mcp_client = await MCPClient.create(MCP_SERVER_URL)
        agent_executor = build_agent(mcp_client)
        logger.info("MCP Client Agent ready")
    except Exception as e:
        logger.error(f"Failed to initialize MCP client: {e}")
        logger.warning("Server starting without MCP connection. Configure MCP_SERVER_URL.")
    yield
    if mcp_client:
        await mcp_client.close()

app = FastAPI(title="Ontology MCP Client", version="1.0.0", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health():
    return {
        "status": "ok",
        "mcp_connected": mcp_client is not None and mcp_client.session is not None,
        "tools": [t.name for t in mcp_client.tools_meta] if mcp_client else [],
    }

@app.post("/api/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    if not agent_executor:
        raise HTTPException(status_code=503, detail="Agent not ready. MCP server may be unavailable.")

    session_id = request.session_id or str(uuid.uuid4())

    # Get or create session history
    if session_id not in sessions:
        sessions[session_id] = {
            "id": session_id,
            "history": [],
        }
    session = sessions[session_id]

    # Build chat history from stored messages
    chat_history = []
    for msg in session["history"]:
        if msg["role"] == "user":
            chat_history.append(HumanMessage(content=msg["content"]))
        else:
            chat_history.append(AIMessage(content=msg["content"]))

    # Set project context for tool calls
    set_current_project_id(request.project_id)

    try:
        result = await agent_executor.ainvoke({
            "messages": chat_history + [HumanMessage(content=request.message)],
        })

        response_text = result["messages"][-1].content

        # Store in session history
        session["history"].append({"role": "user", "content": request.message})
        session["history"].append({"role": "assistant", "content": response_text})

        # Trim history to prevent unbounded growth
        if len(session["history"]) > 20:
            session["history"] = session["history"][-20:]

        return ChatResponse(session_id=session_id, response=response_text)

    except Exception as e:
        import traceback
        tb = traceback.format_exc()
        logger.error(f"Agent error: {e}\n{tb}")
        raise HTTPException(status_code=500, detail=str(e) or repr(e))

@app.post("/api/chat/stream")
async def chat_stream(request: ChatRequest):
    if not agent_executor:
        raise HTTPException(status_code=503, detail="Agent not ready")

    session_id = request.session_id or str(uuid.uuid4())

    if session_id not in sessions:
        sessions[session_id] = {"id": session_id, "history": []}
    session = sessions[session_id]

    chat_history = []
    for msg in session["history"]:
        if msg["role"] == "user":
            chat_history.append(HumanMessage(content=msg["content"]))
        else:
            chat_history.append(AIMessage(content=msg["content"]))

    set_current_project_id(request.project_id)

    async def event_stream():
        full_response = ""
        try:
            async for event in agent_executor.astream_events(
                {"messages": chat_history + [HumanMessage(content=request.message)]},
                version="v2",
            ):
                kind = event.get("event", "")

                # Token streaming from the LLM
                if kind == "on_chat_model_stream":
                    chunk = event.get("data", {}).get("chunk", None)
                    if chunk and hasattr(chunk, "content") and chunk.content:
                        full_response += chunk.content
                        yield f"data: {json.dumps({'type': 'token', 'content': chunk.content})}\n\n"

                # Tool start notification
                elif kind == "on_tool_start":
                    tool_name = event.get("name", "unknown")
                    tool_input = event.get("data", {}).get("input", {})
                    yield f"data: {json.dumps({'type': 'tool_start', 'tool': tool_name, 'input': str(tool_input)[:200]})}\n\n"

                # Tool end notification
                elif kind == "on_tool_end":
                    tool_name = event.get("name", "unknown")
                    output = event.get("data", {}).get("output", "")
                    output_str = str(output)[:200] if output else ""
                    yield f"data: {json.dumps({'type': 'tool_end', 'tool': tool_name, 'output': output_str})}\n\n"

                # Capture final output from the AgentExecutor chain end
                if kind == "on_chain_end":
                    output_data = event.get("data", {}).get("output", {})
                    if isinstance(output_data, dict) and "messages" in output_data:
                        messages = output_data.get("messages", [])
                        if messages and len(messages) > 0:
                            last = messages[-1]
                            content = last.content if hasattr(last, "content") else str(last)
                            if content and content.strip():
                                full_response = content

            # Store in session history
            session["history"].append({"role": "user", "content": request.message})
            session["history"].append({"role": "assistant", "content": full_response})
            if len(session["history"]) > 20:
                session["history"] = session["history"][-20:]

            yield f"data: {json.dumps({'type': 'done', 'fullContent': full_response, 'session_id': session_id})}\n\n"

        except Exception as e:
            yield f"data: {json.dumps({'type': 'error', 'content': str(e)})}\n\n"
            import traceback
            logger.error(f"Stream error: {traceback.format_exc()}")
    return StreamingResponse(
        event_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
        },
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host=HOST, port=PORT, reload=True)
