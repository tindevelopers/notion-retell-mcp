# Multi-Database Solution: Stop Creating New Railway Projects!

## 🎯 Problem

Currently, you're creating a **new Railway project** for each Notion database. This is inefficient because:
- ❌ Multiple projects to manage
- ❌ Duplicate deployments
- ❌ Harder to maintain
- ❌ More expensive

## ✅ Solution: Railway Service-Level Variables

**Create multiple services in ONE Railway project**, each with its own `NOTION_TOKEN`.

### How It Works

```
Railway Project: notion-mcp-server
├── Service: notion-db-1
│   ├── NOTION_TOKEN=token1
│   └── URL: notion-db-1.railway.app
├── Service: notion-db-2
│   ├── NOTION_TOKEN=token2
│   └── URL: notion-db-2.railway.app
└── Service: notion-db-3
    ├── NOTION_TOKEN=token3
    └── URL: notion-db-3.railway.app
```

**One codebase, multiple services, each with its own token!**

## 🚀 Quick Start

### Using the Script (Easiest)

```bash
# Create a new service for a database
./scripts/create-multi-service.sh my-database ntn_your_token_here
```

That's it! The script will:
1. Create the Railway service
2. Set the `NOTION_TOKEN` variable
3. Deploy the service
4. Give you the URL

### Manual Setup

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

## 📋 Step-by-Step Example

### Create Service for Database 1

```bash
railway service create notion-customers
railway service use notion-customers
railway variables set NOTION_TOKEN=ntn_customers_token
railway up
```

**Result:** `https://notion-customers.railway.app`

### Create Service for Database 2

```bash
railway service create notion-products
railway service use notion-products
railway variables set NOTION_TOKEN=ntn_products_token
railway up
```

**Result:** `https://notion-products.railway.app`

### Create Service for Database 3

```bash
railway service create notion-orders
railway service use notion-orders
railway variables set NOTION_TOKEN=ntn_orders_token
railway up
```

**Result:** `https://notion-orders.railway.app`

## 🎨 Retell AI Configuration

For each database, configure Retell AI:

**Database 1:**
- Name: `Notion Customers`
- URL: `https://notion-customers.railway.app`
- Headers: `Content-Type: application/json`

**Database 2:**
- Name: `Notion Products`
- URL: `https://notion-products.railway.app`
- Headers: `Content-Type: application/json`

**Database 3:**
- Name: `Notion Orders`
- URL: `https://notion-orders.railway.app`
- Headers: `Content-Type: application/json`

## 💰 Cost Comparison

### Current Approach (Multiple Projects)
- Each project = separate billing
- Harder to manage
- More expensive

### Service-Level Variables (One Project)
- One project = one billing unit
- Easier to manage
- More cost-effective

## 🔧 Managing Services

### List All Services

```bash
railway service
```

### Switch Between Services

```bash
railway service use notion-customers
railway service use notion-products
```

### View Service Variables

```bash
railway variables
```

### Update a Service

```bash
railway service use notion-customers
railway variables set NOTION_TOKEN=new_token
railway up  # Redeploy with new token
```

### Delete a Service

```bash
railway service delete notion-customers
```

## 📊 Railway Dashboard View

In Railway dashboard, you'll see:

```
Project: notion-mcp-server
├── Service: notion-customers
│   ├── Variables: NOTION_TOKEN=token1
│   ├── URL: notion-customers.railway.app
│   └── Deployments: [list]
├── Service: notion-products
│   ├── Variables: NOTION_TOKEN=token2
│   ├── URL: notion-products.railway.app
│   └── Deployments: [list]
└── Service: notion-orders
    ├── Variables: NOTION_TOKEN=token3
    ├── URL: notion-orders.railway.app
    └── Deployments: [list]
```

## ✨ Benefits

- ✅ **One Project** - All services in one place
- ✅ **One Codebase** - Same code, different configs
- ✅ **Isolated Variables** - Each service has its own `NOTION_TOKEN`
- ✅ **Separate URLs** - Each service gets its own domain
- ✅ **Easy Management** - Manage all services in one dashboard
- ✅ **Cost Effective** - One project billing
- ✅ **No Code Changes** - Works with existing code

## 🔄 Workflow

### Adding a New Database

```bash
# 1. Create service
./scripts/create-multi-service.sh new-database ntn_new_token

# 2. Get URL
railway service use notion-new-database
railway domain

# 3. Configure Retell AI with the URL
```

### Updating Code

```bash
# Update code once
git push origin main

# Railway automatically deploys to all services
# (if GitHub integration is enabled)
```

### Updating a Token

```bash
railway service use notion-customers
railway variables set NOTION_TOKEN=new_token
railway up
```

## 🆚 Alternative: Secrets Manager

If you prefer centralized secret management, see `docs/MULTI_TENANT.md` for:
- AWS Secrets Manager integration
- Request-level API key handling
- Multi-tenant approach

**However, Railway Service-Level Variables is simpler and recommended!**

## 📚 Documentation

- [Multi-Database Setup Guide](./docs/MULTI_DATABASE_SETUP.md) - Detailed guide
- [Multi-Tenant Guide](./retell-mcp-template/docs/MULTI_TENANT.md) - Secrets manager approach
- [Secrets Manager](./retell-mcp-template/docs/SECRETS_MANAGER.md) - External secrets

## 🎯 Summary

**Stop creating new Railway projects!**

Instead:
1. Create **multiple services** in **one Railway project**
2. Each service has its own `NOTION_TOKEN`
3. Each service gets its own URL
4. Configure Retell AI with each URL

**No code changes needed - it just works!** 🎉

