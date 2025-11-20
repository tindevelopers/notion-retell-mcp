# Testing Hybrid Mode

## What is Hybrid Mode?

Hybrid mode runs both:
1. **STDIO transport** - For Retell AI and other MCP clients to access tools
2. **HTTP health endpoint** - For Railway monitoring and health checks

## Testing Locally

### 1. Start the server in hybrid mode:

```bash
NOTION_TOKEN="ntn_your_token" npm start
# or
NOTION_TOKEN="ntn_your_token" node bin/cli.mjs --transport hybrid
```

Expected output:
```
✅ STDIO transport connected (ready for MCP clients like Retell AI)
✅ HTTP health endpoint listening on port 3000
   Health check: http://0.0.0.0:3000/health
   MCP communication: STDIO (for Retell AI)
```

### 2. Test the health endpoint:

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2024-...",
  "transport": "hybrid",
  "stdio": "active",
  "http": "health-only",
  "port": 3000
}
```

### 3. Test STDIO transport (simulate Retell AI):

The STDIO transport listens on stdin/stdout. You can test it by sending MCP protocol messages:

```bash
# This is how Retell AI would connect
echo '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"retell-ai","version":"1.0"}},"id":1}' | node bin/cli.mjs --transport hybrid
```

## Railway Deployment

When deployed to Railway:
- Railway can check `/health` endpoint for monitoring
- Retell AI connects via STDIO (Railway handles this automatically)
- No HTTP MCP endpoints needed - all MCP communication is via STDIO

## Configuration for Retell AI

Retell AI should be configured to use STDIO transport:

```json
{
  "mcpServers": {
    "notion": {
      "command": "node",
      "args": ["/path/to/bin/cli.mjs", "--transport", "hybrid"],
      "env": {
        "NOTION_TOKEN": "ntn_your_token"
      }
    }
  }
}
```

Or if using Railway:
```json
{
  "mcpServers": {
    "notion": {
      "command": "railway",
      "args": ["run", "node", "bin/cli.mjs", "--transport", "hybrid"],
      "env": {
        "NOTION_TOKEN": "ntn_your_token"
      }
    }
  }
}
```

