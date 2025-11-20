# HTTP-to-MCP Bridge for Retell AI

## ✅ Status: WORKING

The Notion MCP Server now supports **HTTP-to-MCP bridge** that converts Retell AI's HTTPS requests to MCP protocol internally.

---

## 🌐 Available HTTP Endpoints

### 1. **GET /tools/list** - List Available Tools
```bash
curl https://web-production-4534b.up.railway.app/tools/list
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "result": {
    "tools": [
      {
        "name": "API-get-user",
        "description": "Notion | Retrieve a user",
        "inputSchema": { ... }
      },
      ...
    ]
  },
  "id": 1234567890
}
```

### 2. **POST /tools/list** - List Available Tools (JSON-RPC format)
```bash
curl -X POST https://web-production-4534b.up.railway.app/tools/list \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/list",
    "params": {},
    "id": 1
  }'
```

### 3. **POST /initialize** - Initialize MCP Connection
```bash
curl -X POST https://web-production-4534b.up.railway.app/initialize \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "initialize",
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {},
      "clientInfo": {
        "name": "retell-ai",
        "version": "1.0"
      }
    },
    "id": 1
  }'
```

### 4. **POST /tools/call** - Call a Tool
```bash
curl -X POST https://web-production-4534b.up.railway.app/tools/call \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "API-get-users",
      "arguments": {}
    },
    "id": 2
  }'
```

---

## 🔧 How It Works

1. **Retell AI sends HTTPS request** → `GET https://web-production-4534b.up.railway.app/tools/list`
2. **HTTP endpoint receives request** → Express route handler catches it
3. **Convert to MCP protocol** → `handleMCPRequest('tools/list', {})`
4. **Execute via MCP server** → Uses the same MCP proxy internally
5. **Return JSON-RPC response** → Standard MCP protocol format

**Architecture:**
```
Retell AI (HTTPS) → HTTP Endpoint → MCP Proxy → Notion API
                    ↓
                STDIO Transport (still active for native MCP clients)
```

---

## 📊 Test Results

### ✅ Local Test
```bash
$ curl -X GET http://localhost:3001/tools/list
{
  "jsonrpc": "2.0",
  "result": {
    "tools": [ ... 19 tools ... ]
  }
}
```

### ✅ Railway Test
```bash
$ curl -X GET https://web-production-4534b.up.railway.app/tools/list
{
  "jsonrpc": "2.0",
  "result": {
    "tools": [ ... 19 tools ... ]
  }
}
```

**Logs:**
```
[HTTP→MCP] Received GET /tools/list, converting to MCP request
[HTTP→MCP] tools/list requested - 1 tool groups found
[HTTP→MCP] Returning 19 tools to client
```

---

## 🎯 Retell AI Configuration

Retell AI can now connect via **HTTPS**:

```json
{
  "mcpServers": {
    "notion": {
      "url": "https://web-production-4534b.up.railway.app",
      "endpoints": {
        "toolsList": "/tools/list",
        "initialize": "/initialize",
        "toolsCall": "/tools/call"
      },
      "headers": {
        "Content-Type": "application/json"
      }
    }
  }
}
```

**Or use simple GET request:**
```bash
GET https://web-production-4534b.up.railway.app/tools/list
```

---

## 🔄 Dual Transport Support

The server now supports **both** transport modes simultaneously:

1. **STDIO Transport** - For native MCP clients (still active)
2. **HTTP Transport** - For Retell AI HTTPS requests (new)

Both use the same MCP proxy internally, ensuring consistency.

---

## 📝 Implementation Details

### Files Modified:
- `scripts/start-server.ts` - Added HTTP-to-MCP bridge endpoints
- `src/openapi-mcp-server/mcp/proxy.ts` - Added `handleMCPRequest()` method

### Key Features:
- ✅ GET and POST support for `/tools/list`
- ✅ POST support for `/initialize` and `/tools/call`
- ✅ JSON-RPC 2.0 format responses
- ✅ Error handling with proper JSON-RPC error codes
- ✅ Logging for debugging (`[HTTP→MCP]` prefix)

---

## 🚀 Deployment Status

- ✅ **Code committed** to GitHub
- ✅ **Deployed to Railway**
- ✅ **HTTP endpoints working**
- ✅ **Tools accessible via HTTPS**

---

## 📋 Next Steps for Retell AI

1. **Configure Retell AI** to use the Railway HTTPS endpoint
2. **Test tool listing** via `GET /tools/list`
3. **Test tool calls** via `POST /tools/call`
4. **Monitor logs** for `[HTTP→MCP]` entries

---

**The Railway endpoint is now fully compatible with Retell AI's HTTPS connection format!** 🎉

