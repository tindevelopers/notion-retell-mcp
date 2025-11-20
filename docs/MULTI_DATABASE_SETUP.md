# Multi-Database Setup Guide

## Problem

You have multiple Notion databases and want to avoid creating a new Railway project for each one.

## Solution: Railway Service-Level Variables

Create **multiple services** in **one Railway project**, each with its own `NOTION_TOKEN`.

## Quick Start

### Option 1: Using Scripts

```bash
# Create a new service for a database
./scripts/create-multi-service.sh my-database ntn_your_token_here

# List all services
./scripts/list-services.sh
```

### Option 2: Manual Setup

```bash
# 1. Create service
railway service create notion-my-database

# 2. Switch to service
railway service use notion-my-database

# 3. Set environment variable
railway variables set NOTION_TOKEN=ntn_your_token_here

# 4. Deploy
railway up
```

## Step-by-Step Guide

### 1. Create Your First Service

```bash
railway service create notion-db-1
railway service use notion-db-1
railway variables set NOTION_TOKEN=ntn_token_for_db1
railway up
```

### 2. Create Additional Services

```bash
railway service create notion-db-2
railway service use notion-db-2
railway variables set NOTION_TOKEN=ntn_token_for_db2
railway up
```

### 3. Each Service Gets Its Own URL

- Service 1: `notion-db-1.railway.app`
- Service 2: `notion-db-2.railway.app`

### 4. Configure Retell AI

For each database, configure Retell AI with:
- **Name:** `Notion Database 1` (or descriptive name)
- **URL:** `https://notion-db-1.railway.app`
- **Headers:** `Content-Type: application/json`

## Managing Services

### List All Services

```bash
railway service
```

### Switch Between Services

```bash
railway service use notion-db-1
railway service use notion-db-2
```

### View Service Variables

```bash
railway variables
```

### Update Service Variables

```bash
railway service use notion-db-1
railway variables set NOTION_TOKEN=new_token
railway up  # Redeploy with new token
```

### Delete a Service

```bash
railway service delete notion-db-1
```

## Railway Dashboard View

In Railway dashboard, you'll see:

```
Project: notion-mcp-server
├── Service: notion-db-1
│   ├── Variables: NOTION_TOKEN=token1
│   ├── URL: notion-db-1.railway.app
│   └── Deployments: [list]
├── Service: notion-db-2
│   ├── Variables: NOTION_TOKEN=token2
│   ├── URL: notion-db-2.railway.app
│   └── Deployments: [list]
└── Service: notion-db-3
    ├── Variables: NOTION_TOKEN=token3
    ├── URL: notion-db-3.railway.app
    └── Deployments: [list]
```

## Benefits

- ✅ **One Project** - All services in one place
- ✅ **One Codebase** - Same code, different configs
- ✅ **Isolated Variables** - Each service has its own `NOTION_TOKEN`
- ✅ **Separate URLs** - Each service gets its own domain
- ✅ **Easy Management** - Manage all services in one dashboard
- ✅ **Cost Effective** - One project billing

## Alternative: External Secrets Manager

If you prefer centralized secret management, see `docs/MULTI_TENANT.md` for:
- AWS Secrets Manager integration
- HashiCorp Vault integration
- Request-level API key handling

## Troubleshooting

### Service Not Found

```bash
# List available services
railway service

# Create if missing
railway service create notion-my-database
```

### Variables Not Set

```bash
# Check current variables
railway variables

# Set variable
railway service use notion-my-database
railway variables set NOTION_TOKEN=your_token
```

### Wrong Service Active

```bash
# Check current service
railway status

# Switch service
railway service use notion-my-database
```

## Best Practices

1. **Naming Convention** - Use consistent names: `notion-<database-name>`
2. **Documentation** - Keep track of which service is for which database
3. **Variables** - Never commit tokens to git
4. **Monitoring** - Monitor each service separately
5. **Updates** - Update code once, deploy to all services

## Example Workflow

```bash
# 1. Create service for new database
./scripts/create-multi-service.sh customer-db ntn_customer_token

# 2. Get service URL
railway service use notion-customer-db
railway domain

# 3. Configure Retell AI with the URL

# 4. Test
curl https://notion-customer-db.railway.app/health
```

## Cost Comparison

### Multiple Projects (Current)
- Each project = separate billing
- Harder to manage
- More expensive

### Multiple Services (Recommended)
- One project = one billing unit
- Easier to manage
- More cost-effective

## Summary

**Use Railway Service-Level Variables** - Create multiple services in one project, each with its own `NOTION_TOKEN`. No code changes needed, easy to manage, and cost-effective.

