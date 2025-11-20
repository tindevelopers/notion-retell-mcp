# Retell AI Integration Guide

This guide explains how to link and deploy the Notion MCP Server for use with Retell AI.

## Overview

The Notion MCP Server runs in **hybrid mode** which provides:
- **STDIO transport** for Retell AI to access Notion tools
- **HTTP health endpoint** for Railway monitoring

## Deployment Architecture

```
Retell AI → STDIO Transport → Notion MCP Server → Notion API
                ↓
         Railway Health Check
```

## Step 1: Deploy to Railway

### 1.1 Connect Repository to Railway

1. Go to [railway.app](https://railway.app)
2. Create a new project
3. Connect your GitHub repository: `tindevelopers/notion-retell-mcp`
4. Railway will automatically detect the Node.js project

### 1.2 Configure Environment Variables

In Railway dashboard → Variables tab, set:

```
NOTION_TOKEN=ntn_your_notion_integration_token
PORT=3000  (Railway sets this automatically)
```

### 1.3 Deploy

Railway will automatically:
- Run `npm install`
- Run `npm run build`
- Run `npm start` (which uses hybrid mode)

### 1.4 Get Your Railway Service URL

After deployment, Railway will provide:
- **Service URL**: `https://your-app.railway.app`
- **Health Check**: `https://your-app.railway.app/health`

## Step 2: Configure Retell AI

### 2.1 Retell AI MCP Configuration

In your Retell AI project settings, configure the MCP server:

**Option A: Using Railway Service (Recommended)**

Retell AI can connect to Railway services via STDIO. Configure it as:

```json
{
  "mcpServers": {
    "notion": {
      "command": "railway",
      "args": ["run", "--service", "your-service-name", "node", "bin/cli.mjs", "--transport", "hybrid"],
      "env": {
        "NOTION_TOKEN": "ntn_your_token"
      }
    }
  }
}
```

**Option B: Direct STDIO Connection**

If Retell AI supports direct STDIO connections to Railway services:

```json
{
  "mcpServers": {
    "notion": {
      "command": "node",
      "args": ["bin/cli.mjs", "--transport", "hybrid"],
      "env": {
        "NOTION_TOKEN": "ntn_your_token",
        "PORT": "3000"
      }
    }
  }
}
```

**Option C: Using Railway CLI**

If Retell AI runs in an environment with Railway CLI:

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

### 2.2 Retell AI Environment Variables

Ensure Retell AI has access to:
- `NOTION_TOKEN` - Your Notion integration token
- `PORT` - (Optional, Railway sets automatically)

## Step 3: Verify Connection

### 3.1 Check Health Endpoint

```bash
curl https://your-app.railway.app/health
```

Expected response:
```json
{
  "status": "healthy",
  "transport": "hybrid",
  "stdio": "active",
  "http": "health-only"
}
```

### 3.2 Test MCP Tools in Retell AI

1. In Retell AI, navigate to MCP settings
2. Verify the Notion MCP server is connected
3. Test by asking Retell AI to use Notion tools (e.g., "Search for pages in Notion")

## Step 4: Railway Service Linking

### 4.1 Link Railway Service to Retell AI

If Retell AI supports Railway service linking:

1. In Railway dashboard, go to your service
2. Copy the service URL or service name
3. In Retell AI, configure the Railway service connection
4. Set the command to use Railway's service execution

### 4.2 Railway Service Configuration

Create a `railway.toml` or use Railway's dashboard to configure:

```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "npm start"
healthcheckPath = "/health"
healthcheckTimeout = 100
restartPolicyType = "ON_FAILURE"
```

## Troubleshooting

### Issue: Retell AI cannot connect

**Solution:**
- Verify Railway service is running: `curl https://your-app.railway.app/health`
- Check Railway logs for errors
- Ensure `NOTION_TOKEN` is set correctly
- Verify Retell AI configuration uses STDIO transport

### Issue: Tools not available in Retell AI

**Solution:**
- Check Railway logs for MCP initialization errors
- Verify Notion integration token has correct permissions
- Ensure pages/databases are connected to your Notion integration

### Issue: Health endpoint not responding

**Solution:**
- Check Railway deployment status
- Verify PORT environment variable is set
- Check Railway logs for HTTP server errors

## Railway Service Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `NOTION_TOKEN` | Yes | Notion integration token |
| `PORT` | No | HTTP port (Railway sets automatically) |

## Retell AI MCP Configuration Reference

### Minimal Configuration

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

### With Railway Integration

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

## Next Steps

1. ✅ Deploy to Railway
2. ✅ Configure Retell AI MCP settings
3. ✅ Test connection
4. ✅ Use Notion tools in Retell AI conversations

## Support

- **Railway Issues**: [docs.railway.app](https://docs.railway.app)
- **Retell AI**: Check Retell AI documentation for MCP server configuration
- **Notion API**: [developers.notion.com](https://developers.notion.com)

