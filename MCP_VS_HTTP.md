# MCP Protocol vs HTTP Endpoints

## Important: MCP Tools Are NOT HTTP Endpoints

### ❌ Incorrect Usage

**Trying to access tools via HTTP:**
```
GET https://web-production-4534b.up.railway.app/tools/list
```

This will return a 400 error because MCP protocol methods are **not HTTP endpoints**.

### ✅ Correct Usage

**MCP tools are accessed via STDIO transport:**

1. **For Retell AI:**
   - Configure Retell AI to use **STDIO transport**
   - Point to Railway service
   - Retell AI connects via stdin/stdout
   - MCP protocol messages flow through STDIO

2. **How It Works:**
   ```
   Retell AI → STDIO → MCP Server → Notion API
   ```

## HTTP Endpoints (Available)

The server exposes these HTTP endpoints for monitoring:

- **Health Check:** `GET /health`
  ```bash
  curl https://web-production-4534b.up.railway.app/health
  ```

- **Info:** `GET /`
  ```bash
  curl https://web-production-4534b.up.railway.app/
  ```

## MCP Protocol Endpoints (STDIO Only)

These are **NOT** HTTP endpoints - they're MCP protocol methods:

- `initialize` - Initialize MCP connection
- `tools/list` - List available tools
- `tools/call` - Call a tool
- `notifications` - Server notifications

These methods are accessed via **STDIO transport**, not HTTP.

## Retell AI Configuration

```json
{
  "mcpServers": {
    "notion": {
      "command": "node",
      "args": ["bin/cli.mjs", "--transport", "hybrid"],
      "env": {
        "NOTION_TOKEN": "ntn_your_token"
      }
    }
  }
}
```

Retell AI will:
1. Spawn the process with STDIO
2. Send MCP protocol messages via stdin
3. Receive responses via stdout
4. Tools will appear automatically

## Testing

To test MCP protocol (not HTTP):

```bash
# This simulates Retell AI connection
echo '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"retell-ai","version":"1.0"}},"id":1}' | \
node bin/cli.mjs --transport hybrid
```

## Summary

- ✅ **HTTP:** Health checks and monitoring only
- ✅ **STDIO:** MCP protocol communication (tools, initialize, etc.)
- ❌ **HTTP + /tools/list:** Not supported - use STDIO instead

The Railway endpoint is configured correctly for Retell AI - it just needs to connect via STDIO, not HTTP!

