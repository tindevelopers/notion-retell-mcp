# Retell AI Configuration Guide

## ✅ Updated Endpoints (Matches Working Format)

The Notion MCP Server now uses the same endpoint format as the working lodgify-mcp-server.

## Retell AI Configuration Settings

### Basic Settings

**Name:**
```
Notion MCP Server
```

**URL:**
```
https://web-production-4534b.up.railway.app
```

**Timeout (ms):**
```
10000
```
(Default, keep as is)

### Headers

Add one header:

**Key:**
```
Content-Type
```

**Value:**
```
application/json
```

### Query Parameters

Leave empty (no query parameters needed)

---

## Available Endpoints

### 1. **POST /** - Get Tools List (Simple JSON)
Retell AI uses this to discover available tools.

**Request:**
```bash
POST /
Content-Type: application/json

{}
```

**Response:**
```json
{
  "tools": [
    {
      "name": "API-get-user",
      "description": "Notion | Retrieve a user",
      "parameters": {
        "user_id": {
          "type": "string",
          "format": "uuid"
        }
      }
    },
    ...
  ]
}
```

### 2. **POST /tools** - MCP Protocol (JSON-RPC 2.0)
Handles all MCP protocol methods:
- `initialize` - Initialize MCP connection
- `tools/list` - List available tools
- `tools/call` - Execute a tool

**Example: Initialize**
```json
{
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
}
```

**Example: List Tools**
```json
{
  "jsonrpc": "2.0",
  "method": "tools/list",
  "params": {},
  "id": 2
}
```

**Example: Call Tool**
```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "API-get-users",
    "arguments": {}
  },
  "id": 3
}
```

### 3. **POST /mcp** - Alternative MCP Protocol Endpoint
Same as `/tools`, alternative endpoint for JSON-RPC 2.0 requests.

### 4. **GET /capabilities** - Get Full Capabilities
Returns complete server capabilities including tools, resources, and prompts.

### 5. **GET /health** - Health Check
Returns server health status (used by Railway).

---

## How Retell AI Connects

1. **Discovery**: Retell AI sends `POST /` to get tools list
2. **Initialization**: Retell AI sends `POST /tools` with `initialize` method
3. **Tool Listing**: Retell AI sends `POST /tools` with `tools/list` method
4. **Tool Execution**: Retell AI sends `POST /tools` with `tools/call` method

---

## Environment Variables

Ensure these are set in Railway:

- `NOTION_TOKEN` - Your Notion API integration token (required)
- `PORT` - Server port (Railway sets this automatically)

---

## Testing

### Test Tools Discovery
```bash
curl -X POST https://web-production-4534b.up.railway.app/ \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Test JSON-RPC Tools List
```bash
curl -X POST https://web-production-4534b.up.railway.app/tools \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/list",
    "params": {},
    "id": 1
  }'
```

### Test Tool Call
```bash
curl -X POST https://web-production-4534b.up.railway.app/tools \
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

## Status

✅ **Ready for Retell AI** - Endpoints match the working lodgify-mcp-server format.

The server now supports:
- ✅ POST `/` for tools discovery
- ✅ POST `/tools` for JSON-RPC 2.0 MCP protocol
- ✅ POST `/mcp` as alternative endpoint
- ✅ GET `/capabilities` for full capabilities
- ✅ GET `/health` for health checks

