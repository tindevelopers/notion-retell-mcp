# Quick Deployment Checklist

## ✅ Pre-Deployment Checklist

- [ ] Railway account created
- [ ] GitHub repository connected to Railway
- [ ] `NOTION_TOKEN` environment variable ready
- [ ] Code pushed to `main` branch

## 🚀 Deployment Steps

### 1. Connect Repository (One-time setup)

**Via Railway Dashboard:**
1. Go to [railway.app](https://railway.app) → New Project
2. Select "Deploy from GitHub repo"
3. Choose `tindevelopers/notion-retell-mcp`
4. Railway auto-detects Node.js configuration

**Via Railway CLI:**
```bash
npm i -g @railway/cli
railway login
railway init
railway link
```

### 2. Set Environment Variables

In Railway Dashboard → Your Service → Variables:

```
NOTION_TOKEN=ntn_your_token_here
```

### 3. Trigger Deployment

**Automatic (GitHub Integration):**
- Push to `main` branch triggers deployment
- Already done! ✅

**Manual (Railway CLI):**
```bash
railway up
```

### 4. Monitor Deployment

**Option A: Railway Dashboard**
- Go to Railway dashboard
- Click your service
- View "Deployments" tab
- Check "Logs" tab for real-time output

**Option B: Railway CLI**
```bash
railway logs --follow
```

**Option C: Monitor Script**
```bash
export RAILWAY_SERVICE_URL="https://your-app.railway.app"
./scripts/monitor-deployment.sh
```

## 🔍 What to Look For

### ✅ Success Indicators

In Railway logs, you should see:
```
✅ STDIO transport connected (ready for MCP clients like Retell AI)
✅ HTTP health endpoint listening on port XXXX
   Health check: http://0.0.0.0:XXXX/health
   MCP communication: STDIO (for Retell AI)
```

### ❌ Error Indicators

Watch for:
- Build failures
- Missing `NOTION_TOKEN` errors
- Port conflicts
- Module not found errors

## 🏥 Health Check

After deployment, verify:

```bash
curl https://your-app.railway.app/health
```

Expected:
```json
{
  "status": "healthy",
  "transport": "hybrid",
  "stdio": "active",
  "http": "health-only"
}
```

## 🔄 Iteration Process

If deployment fails:

1. **Check Logs**
   ```bash
   railway logs
   ```

2. **Fix Issues**
   - Update code
   - Fix environment variables
   - Resolve build errors

3. **Commit & Push**
   ```bash
   git add .
   git commit -m "Fix deployment issue"
   git push origin main
   ```

4. **Monitor Again**
   - Railway auto-deploys on push
   - Watch logs for success

5. **Repeat until successful** ✅

## 📊 Deployment Status Commands

```bash
# View logs
railway logs --follow

# Check status
railway status

# Get service URL
railway domain

# View variables
railway variables

# Restart service
railway restart
```

## 🎯 Success Criteria

- [ ] Build completes successfully
- [ ] Service starts without errors
- [ ] Health endpoint returns 200 OK
- [ ] Logs show STDIO transport active
- [ ] Logs show HTTP health endpoint active
- [ ] No errors in logs

## 🆘 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails | Check `package.json` and build scripts |
| Service won't start | Verify `NOTION_TOKEN` is set |
| Health check fails | Check PORT and service logs |
| MCP not working | Verify STDIO transport is active in logs |

## 📚 Full Documentation

- **Deployment Guide**: See `DEPLOYMENT.md`
- **Retell Integration**: See `RETELL_INTEGRATION.md`
- **Railway Setup**: See `RAILWAY.md`

