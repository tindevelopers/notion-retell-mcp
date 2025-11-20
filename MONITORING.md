# Monitoring Railway Deployment

## Quick Start

Once Railway is connected, monitor deployment with:

```bash
./scripts/monitor-railway.sh
```

## Setup Required

Before monitoring, ensure:

1. **Railway CLI installed:**
   ```bash
   npm i -g @railway/cli
   ```

2. **Logged in to Railway:**
   ```bash
   railway login
   ```

3. **Project linked:**
   ```bash
   railway link
   ```

## Monitoring Options

### Option 1: Automated Monitor Script

```bash
./scripts/monitor-railway.sh
```

This script will:
- ✅ Check Railway CLI availability
- ✅ Verify login status
- ✅ Show service information
- ✅ Stream logs in real-time
- ✅ Display service URL

### Option 2: Railway CLI Direct

```bash
# Follow logs in real-time
railway logs --follow

# View last 100 lines
railway logs --tail 100

# Check service status
railway status

# Get service URL
railway domain
```

### Option 3: Railway Dashboard

1. Go to [railway.app](https://railway.app)
2. Select your project
3. Click on your service
4. View "Logs" tab for real-time logs
5. View "Deployments" tab for build status

## Success Indicators

Look for these messages in the logs:

```
✅ STDIO transport connected (ready for MCP clients like Retell AI)
✅ HTTP health endpoint listening on port XXXX
   Health check: http://0.0.0.0:XXXX/health
   MCP communication: STDIO (for Retell AI)
```

## Health Check

After seeing success messages, verify:

```bash
# Get your service URL first
railway domain

# Then test health endpoint
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

## Troubleshooting

### "Not logged in to Railway"
```bash
railway login
```

### "No Railway project linked"
```bash
railway link
```

### No logs appearing
- Check Railway dashboard for deployment status
- Verify environment variables are set
- Check if build completed successfully

### Build failures
- Check Railway dashboard → Deployments tab
- Review build logs for errors
- Verify `package.json` scripts are correct

### Service not starting
- Check Railway logs for errors
- Verify `NOTION_TOKEN` is set
- Check for port conflicts

## Continuous Monitoring

To monitor continuously until successful:

```bash
# Run monitor script (will follow logs)
./scripts/monitor-railway.sh

# Or use Railway CLI directly
railway logs --follow
```

The script will stream logs until you press Ctrl+C. Watch for the success indicators above.

## Next Steps After Successful Deployment

1. ✅ Note your Railway service URL
2. ✅ Verify health endpoint responds
3. ✅ Configure Retell AI (see `RETELL_INTEGRATION.md`)
4. ✅ Test Notion tools in Retell AI

