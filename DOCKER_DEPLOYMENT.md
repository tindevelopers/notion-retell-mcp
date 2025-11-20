# Docker Deployment for Railway

## Overview

This project uses **Docker** for Railway deployment instead of Nixpacks. The Dockerfile uses a multi-stage build for optimized image size and security.

## Dockerfile Structure

### Build Stage
- Uses `node:20-slim` as base image
- Installs all dependencies (including dev dependencies for build)
- Builds TypeScript code and creates `bin/cli.mjs`
- Outputs optimized production build

### Production Stage
- Uses `node:20-slim` as base image
- Installs only production dependencies
- Copies built files from builder stage
- Runs as non-root user for security
- Includes healthcheck

## Key Features

- ✅ **Multi-stage build** - Optimized image size
- ✅ **Non-root user** - Enhanced security
- ✅ **Healthcheck** - Automatic health monitoring
- ✅ **Hybrid transport** - STDIO + HTTP endpoints
- ✅ **Production optimized** - Only production dependencies

## Railway Configuration

The `railway.json` file is configured to use Docker:

```json
{
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "Dockerfile"
  },
  "deploy": {
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10,
    "healthcheckPath": "/health",
    "healthcheckTimeout": 100
  }
}
```

## Build Process

1. **Build Stage:**
   - Copies `package.json` and `package-lock.json`
   - Installs dependencies
   - Copies source code (`src/`, `scripts/`, `tsconfig.json`)
   - Runs `npm run build` (TypeScript compilation + CLI build)

2. **Production Stage:**
   - Copies `package.json` and `package-lock.json`
   - Installs production dependencies only
   - Copies built files (`bin/`, `build/`, `scripts/`)
   - Sets up environment variables
   - Exposes port 8080
   - Sets non-root user
   - Configures healthcheck

## Environment Variables

Required:
- `NOTION_TOKEN` - Notion API integration token

Optional:
- `PORT` - Server port (default: 8080, Railway sets this automatically)
- `OPENAPI_MCP_HEADERS` - JSON string with Notion API headers (alternative to NOTION_TOKEN)

## Healthcheck

The Dockerfile includes a healthcheck that:
- Checks `/health` endpoint every 30 seconds
- Times out after 10 seconds
- Allows 40 seconds for startup
- Retries 3 times before marking unhealthy

## Security

- Runs as non-root user (`appuser`)
- Only production dependencies installed
- Minimal base image (`node:20-slim`)
- No unnecessary files copied (via `.dockerignore`)

## Deployment

Railway automatically:
1. Detects Dockerfile
2. Builds Docker image
3. Deploys container
4. Runs healthcheck
5. Routes traffic to container

## Troubleshooting

### Build Fails
- Check Railway build logs
- Verify all source files are present
- Ensure `package.json` is valid

### Container Won't Start
- Check environment variables are set
- Verify `NOTION_TOKEN` is configured
- Check logs: `railway logs --tail 100`

### Healthcheck Fails
- Verify `/health` endpoint responds
- Check server is listening on correct port
- Ensure MCP proxy initializes correctly

## Local Testing

To test Docker build locally:

```bash
# Build image
docker build -t notion-mcp-server .

# Run container
docker run -p 8080:8080 \
  -e NOTION_TOKEN="ntn_your_token" \
  -e PORT=8080 \
  notion-mcp-server

# Test health endpoint
curl http://localhost:8080/health
```

## Files

- `Dockerfile` - Docker build configuration
- `.dockerignore` - Files to exclude from Docker build
- `railway.json` - Railway deployment configuration

