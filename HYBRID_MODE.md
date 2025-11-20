# Hybrid Transport Mode

## Overview

The Notion MCP Server now supports a **hybrid transport mode** that combines:
- **STDIO transport** for MCP protocol communication (used by Retell AI)
- **HTTP health endpoint** for monitoring and health checks (used by Railway)

This allows the server to:
1. Serve MCP tools via STDIO to Retell AI and other MCP clients
2. Provide a health endpoint for Railway monitoring
3. Run both transports simultaneously

## How It Works

When running in hybrid mode (`--transport hybrid`):

1. **STDIO Transport**: 
   - Connects to stdin/stdout
   - Handles all MCP protocol communication
   - Retell AI connects here to access tools

2. **HTTP Server**:
   - Runs on the PORT specified (default: 3000, Railway sets automatically)
   - Provides `/health` endpoint for monitoring
   - Does NOT handle MCP protocol (that's STDIO's job)

## Usage

### Command Line

```bash
# Hybrid mode (default for Railway)
node bin/cli.mjs --transport hybrid

# Or via npm start (configured in package.json)
npm start
```

### Environment Variables

- `NOTION_TOKEN` - Required: Your Notion integration token
- `PORT` - Optional: HTTP port for health endpoint (Railway sets automatically)

### Railway Configuration

The `package.json` start script is configured for hybrid mode:

```json
{
  "scripts": {
    "start": "node bin/cli.mjs --transport hybrid"
  }
}
```

## Testing

### Health Endpoint

```bash
curl http://localhost:3000/health
```

Response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "transport": "hybrid",
  "stdio": "active",
  "http": "health-only",
  "port": 3000
}
```

### STDIO Transport

Retell AI connects automatically via STDIO. The server listens on stdin/stdout for MCP protocol messages.

## Benefits

✅ **Retell AI Compatible**: Uses STDIO as Retell AI expects  
✅ **Railway Monitoring**: Health endpoint for Railway health checks  
✅ **Single Process**: Both transports run in one process  
✅ **Production Ready**: Optimized for Railway deployment  

## Transport Modes Comparison

| Mode | STDIO | HTTP MCP | HTTP Health | Use Case |
|------|-------|----------|-------------|----------|
| `stdio` | ✅ | ❌ | ❌ | Local development, Claude Desktop |
| `http` | ❌ | ✅ | ✅ | Web-based MCP clients |
| `hybrid` | ✅ | ❌ | ✅ | **Railway + Retell AI** |

## Railway Deployment

When deployed to Railway:

1. Railway runs: `npm start` → `node bin/cli.mjs --transport hybrid`
2. STDIO transport connects (for Retell AI)
3. HTTP health endpoint starts on Railway's PORT
4. Railway can monitor via `/health` endpoint
5. Retell AI connects via STDIO to access tools

## Configuration Files Updated

- ✅ `scripts/start-server.ts` - Added hybrid mode implementation
- ✅ `package.json` - Updated start script to use hybrid mode
- ✅ `Procfile` - Updated for Railway deployment
- ✅ `railway.json` - Already configured (uses npm start)

## Notes

- The HTTP server in hybrid mode **only** provides health checks
- All MCP protocol communication happens via STDIO
- This is the recommended mode for Railway deployments with Retell AI
- No authentication needed for health endpoint (it's just monitoring)

