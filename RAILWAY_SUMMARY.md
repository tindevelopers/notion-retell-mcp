# Railway Deployment - Summary

## What Was Prepared

Your Notion MCP Server is now ready for Railway deployment! Here's what was configured:

### Files Created/Modified

1. **`railway.json`** - Railway configuration file
   - Defines build and deploy settings
   - Uses Nixpacks builder
   - Sets start command to `npm start`

2. **`Procfile`** - Alternative deployment method
   - Defines web process: `node bin/cli.mjs --transport http`
   - Railway can use this if railway.json is not found

3. **`.railwayignore`** - Files to exclude from deployment
   - Excludes test files, docs, build artifacts
   - Keeps deployment lean and fast

4. **`package.json`** - Added `start` script
   - Production start command: `node bin/cli.mjs --transport http`
   - Runs server in HTTP transport mode

5. **`scripts/start-server.ts`** - Updated to use Railway PORT
   - Now reads `process.env.PORT` (Railway sets this automatically)
   - Falls back to 3000 if PORT is not set

6. **`RAILWAY.md`** - Complete deployment guide
   - Step-by-step instructions
   - Environment variable documentation
   - Troubleshooting tips

7. **`DEPLOYMENT_CHECKLIST.md`** - Pre/post deployment checklist
   - Ensures nothing is missed
   - Quick reference for testing

## Quick Start

### 1. Set Environment Variables in Railway

Go to Railway dashboard → Your Project → Variables:

```
NOTION_TOKEN=ntn_your_token_here
AUTH_TOKEN=your_secure_token_here  (optional)
```

### 2. Deploy

**Option A: GitHub Integration**
- Connect your GitHub repo in Railway
- Railway will auto-detect and deploy

**Option B: Railway CLI**
```bash
railway login
railway init
railway variables set NOTION_TOKEN=ntn_...
railway up
```

### 3. Test

```bash
# Health check (HTTP endpoint for monitoring)
curl https://your-app.railway.app/health

# MCP communication happens via STDIO (Retell AI connects automatically)
# No HTTP endpoint needed for MCP protocol
```

## Key Features

✅ **Hybrid Transport Mode** - STDIO for Retell AI + HTTP health endpoint  
✅ **Automatic PORT handling** - Uses Railway's PORT env var  
✅ **STDIO Transport** - Standard MCP protocol for Retell AI and other clients  
✅ **Health endpoint** - `/health` for Railway monitoring  
✅ **Environment variable support** - NOTION_TOKEN (AUTH_TOKEN not needed for hybrid mode)  
✅ **Production-ready** - Optimized build and start commands  

## Next Steps

1. Push your code to GitHub/GitLab
2. Create Railway project and connect repository
3. Set environment variables
4. Deploy!
5. Test using the commands above

For detailed instructions, see `RAILWAY.md`.

