# Railway Deployment Guide

This guide explains how to deploy the Notion MCP Server to Railway.

## Prerequisites

1. A Railway account ([railway.app](https://railway.app))
2. A Notion integration token (get one at [notion.so/profile/integrations](https://www.notion.so/profile/integrations))
3. Git repository (Railway can deploy from GitHub, GitLab, or directly from your local machine)

## Deployment Steps

### Option 1: Deploy from GitHub/GitLab

1. **Connect your repository**
   - Go to [railway.app](https://railway.app)
   - Click "New Project"
   - Select "Deploy from GitHub repo" (or GitLab)
   - Choose your repository

2. **Configure environment variables**
   - In your Railway project, go to the "Variables" tab
   - Add the following environment variables:
     - `NOTION_TOKEN`: Your Notion integration token (e.g., `ntn_...`)
     - `AUTH_TOKEN`: (Optional) A secure token for HTTP transport authentication. If not provided, one will be auto-generated.
     - `PORT`: (Optional) Railway sets this automatically, but you can override if needed

3. **Deploy**
   - Railway will automatically detect the Node.js project
   - It will run `npm install`, `npm run build`, and `npm start`
   - The server will be available at the Railway-provided URL

### Option 2: Deploy using Railway CLI

1. **Install Railway CLI**
   ```bash
   npm i -g @railway/cli
   ```

2. **Login to Railway**
   ```bash
   railway login
   ```

3. **Initialize Railway project**
   ```bash
   railway init
   ```

4. **Set environment variables**
   ```bash
   railway variables set NOTION_TOKEN=ntn_your_token_here
   railway variables set AUTH_TOKEN=your_secure_token_here
   ```

5. **Deploy**
   ```bash
   railway up
   ```

### Option 3: Deploy using Docker

Railway also supports Docker deployments. The included `Dockerfile` can be used:

1. **Configure Railway to use Docker**
   - In Railway project settings, ensure Docker is enabled
   - Railway will automatically detect and use the Dockerfile

2. **Set environment variables** (same as above)

3. **Deploy**

## Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `NOTION_TOKEN` | Yes | Your Notion integration token | `ntn_your_token_here` |
| `AUTH_TOKEN` | No | Bearer token for HTTP transport auth. If not set, a random token will be generated. | `your-secure-token-123` |
| `PORT` | No | Server port (Railway sets this automatically) | `3000` |
| `OPENAPI_MCP_HEADERS` | No* | Alternative to NOTION_TOKEN. JSON string with headers. | `{"Authorization":"Bearer ntn_...","Notion-Version":"2022-06-28"}` |

\* Either `NOTION_TOKEN` or `OPENAPI_MCP_HEADERS` must be provided.

## Post-Deployment

After deployment, your MCP server will be available in **hybrid mode**:
- **Health check**: `https://your-app.railway.app/health` (for Railway monitoring)
- **MCP communication**: STDIO transport (for Retell AI and other MCP clients)

The server runs in hybrid mode by default, which means:
- STDIO transport handles all MCP protocol communication (tools, requests, etc.)
- HTTP endpoint provides health checks for monitoring/debugging
- Retell AI connects via STDIO as expected

### Testing the Deployment

1. **Health check** (HTTP endpoint):
   ```bash
   curl https://your-app.railway.app/health
   ```
   Should return:
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

2. **MCP Communication** (STDIO):
   - Retell AI and other MCP clients connect via STDIO transport
   - No HTTP endpoint needed for MCP protocol
   - The server listens on STDIN/STDOUT for MCP requests

## Important Notes

1. **Security**: Always use a strong `AUTH_TOKEN` in production. Railway's auto-generated tokens are secure, but you may want to set your own.

2. **Port**: Railway automatically sets the `PORT` environment variable. The server will use this port automatically.

3. **Transport Mode**: The server runs in **hybrid mode** by default when using `npm start`:
   - STDIO transport for MCP clients (Retell AI, etc.)
   - HTTP health endpoint for monitoring
   - This is the recommended mode for Railway deployments

4. **Logs**: View your application logs in the Railway dashboard under the "Deployments" tab.

5. **Scaling**: Railway can automatically scale your application based on traffic.

## Troubleshooting

### Server not starting
- Check that `NOTION_TOKEN` is set correctly
- Verify the build completed successfully
- Check logs in Railway dashboard

### Authentication errors
- Ensure `AUTH_TOKEN` matches what you're using in requests
- Check that the Authorization header format is correct: `Bearer YOUR_TOKEN`

### Port issues
- Railway sets `PORT` automatically - don't override unless necessary
- The server will use `process.env.PORT` if available

## Support

For issues specific to:
- **Railway**: [railway.app/docs](https://docs.railway.app)
- **Notion MCP Server**: [GitHub Issues](https://github.com/makenotion/notion-mcp-server/issues)

