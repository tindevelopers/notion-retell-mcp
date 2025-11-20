# Deployment Guide

This guide walks you through deploying the Notion MCP Server to Railway and monitoring the deployment.

## Prerequisites

1. Railway account ([railway.app](https://railway.app))
2. GitHub repository connected
3. Notion integration token

## Step 1: Connect Repository to Railway

### Option A: Via Railway Dashboard (Recommended)

1. Go to [railway.app](https://railway.app)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose `tindevelopers/notion-retell-mcp`
5. Railway will automatically detect Node.js and configure build

### Option B: Via Railway CLI

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Link to existing project or create new
railway link
```

## Step 2: Configure Environment Variables

In Railway dashboard → Your Service → Variables:

```
NOTION_TOKEN=ntn_your_notion_integration_token
```

**Important:** Railway automatically sets `PORT` - don't override it unless necessary.

## Step 3: Deploy

### Automatic Deployment (GitHub Integration)

Railway automatically deploys when you push to `main` branch:

```bash
git push origin main
```

### Manual Deployment (Railway CLI)

```bash
# Build and deploy
npm run build
railway up

# Or use the deployment script
./scripts/deploy-to-railway.sh
```

## Step 4: Monitor Deployment

### Option A: Using Monitor Script

```bash
# Set your Railway service URL
export RAILWAY_SERVICE_URL="https://your-app.railway.app"

# Run monitor script
./scripts/monitor-deployment.sh
```

### Option B: Railway Dashboard

1. Go to Railway dashboard
2. Click on your service
3. View "Deployments" tab for build status
4. View "Logs" tab for real-time logs

### Option C: Railway CLI

```bash
# View logs
railway logs

# View deployment status
railway status

# Get service URL
railway domain
```

## Step 5: Verify Deployment

### Health Check

```bash
curl https://your-app.railway.app/health
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

### Check Logs

```bash
# Via Railway CLI
railway logs

# Or check Railway dashboard → Logs tab
```

Look for:
- ✅ `STDIO transport connected (ready for MCP clients like Retell AI)`
- ✅ `HTTP health endpoint listening on port XXXX`
- ❌ Any error messages

## Troubleshooting

### Build Fails

**Check:**
- Railway build logs
- `package.json` scripts are correct
- Node.js version compatibility

**Fix:**
```bash
# Test build locally first
npm run build
```

### Service Not Starting

**Check:**
- Environment variables are set (`NOTION_TOKEN`)
- Port is not conflicting
- Railway logs for errors

**Fix:**
```bash
# Check logs
railway logs

# Verify environment variables
railway variables
```

### Health Endpoint Not Responding

**Check:**
- Service is deployed and running
- PORT environment variable is set
- No errors in logs

**Fix:**
```bash
# Restart service
railway restart

# Or redeploy
railway up
```

### MCP Tools Not Available

**Check:**
- Notion token has correct permissions
- Pages/databases are connected to integration
- STDIO transport is active (check logs)

**Fix:**
- Verify Notion integration settings
- Check Railway logs for MCP initialization errors
- Ensure hybrid mode is active

## Continuous Deployment

### GitHub Actions (Already Configured)

The repository includes `.github/workflows/railway-deploy.yml` which:
- Automatically deploys on push to `main`
- Builds the project
- Deploys to Railway

**Setup:**
1. Add Railway secrets to GitHub:
   - `RAILWAY_TOKEN` - Get from Railway dashboard → Settings → Tokens
   - `RAILWAY_SERVICE_NAME` - Your service name

2. Push to `main` branch - deployment happens automatically

### Manual Trigger

```bash
# Make a small change and commit
git commit --allow-empty -m "Trigger deployment"
git push origin main
```

## Monitoring Commands

```bash
# View real-time logs
railway logs --follow

# Check service status
railway status

# Get service URL
railway domain

# View environment variables
railway variables

# Restart service
railway restart
```

## Success Criteria

✅ Build completes without errors  
✅ Service starts successfully  
✅ Health endpoint returns 200 OK  
✅ Logs show "STDIO transport connected"  
✅ Logs show "HTTP health endpoint listening"  
✅ No errors in Railway logs  

## Next Steps

After successful deployment:

1. ✅ Note your Railway service URL
2. ✅ Configure Retell AI (see `RETELL_INTEGRATION.md`)
3. ✅ Test Notion tools in Retell AI
4. ✅ Monitor logs for any issues

## Support

- **Railway Docs**: [docs.railway.app](https://docs.railway.app)
- **Railway Status**: [status.railway.app](https://status.railway.app)
- **Project Issues**: [GitHub Issues](https://github.com/tindevelopers/notion-retell-mcp/issues)

