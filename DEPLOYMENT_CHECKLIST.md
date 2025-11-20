# Railway Deployment Checklist

Use this checklist to ensure a smooth deployment to Railway.

## Pre-Deployment

- [ ] Code is committed and pushed to your repository
- [ ] `npm run build` completes successfully locally
- [ ] You have a Notion integration token ready
- [ ] You have decided on an `AUTH_TOKEN` (or will use auto-generated one)

## Railway Setup

- [ ] Created Railway account at [railway.app](https://railway.app)
- [ ] Created new project in Railway
- [ ] Connected GitHub/GitLab repository (or prepared for CLI deployment)

## Environment Variables

Set these in Railway dashboard → Variables tab:

- [ ] `NOTION_TOKEN` = `ntn_your_notion_integration_token`
- [ ] `AUTH_TOKEN` = `your_secure_random_token` (optional, but recommended)
- [ ] `PORT` = (Railway sets this automatically, no need to set manually)

## Deployment

- [ ] Railway detected Node.js project correctly
- [ ] Build completed successfully (check Railway logs)
- [ ] Application started without errors
- [ ] Health endpoint responds: `curl https://your-app.railway.app/health`

## Post-Deployment Testing

- [ ] Health check endpoint works: `/health`
- [ ] MCP initialize endpoint works: `/mcp` (with auth token)
- [ ] Tools list endpoint works: `tools/list`
- [ ] Can make actual Notion API calls through MCP

## Security Checklist

- [ ] `AUTH_TOKEN` is strong and secure (if manually set)
- [ ] `NOTION_TOKEN` is kept secret (never commit to git)
- [ ] Railway environment variables are set (not hardcoded)
- [ ] HTTPS is enabled (Railway provides this automatically)

## Monitoring

- [ ] Check Railway logs for any errors
- [ ] Monitor Railway metrics (CPU, memory, requests)
- [ ] Set up Railway alerts if needed
- [ ] Document your Railway URL for future reference

## Quick Test Commands

```bash
# Health check
curl https://your-app.railway.app/health

# Initialize MCP (replace YOUR_AUTH_TOKEN)
curl -X POST https://your-app.railway.app/mcp \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}},"id":1}'
```

## Troubleshooting

If deployment fails:

1. Check Railway build logs for errors
2. Verify all environment variables are set
3. Test locally: `NOTION_TOKEN=xxx npm start`
4. Check Railway documentation: [docs.railway.app](https://docs.railway.app)

## Next Steps

After successful deployment:

- [ ] Share Railway URL with your team
- [ ] Update any client configurations to use Railway URL
- [ ] Set up monitoring/alerting
- [ ] Document the deployment process for your team

