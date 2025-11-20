#!/bin/bash

# Check Deployment Status Script
# Checks multiple sources for deployment status

set -e

echo "🔍 Checking Deployment Status"
echo "============================="
echo ""

# Check Railway CLI
if command -v railway &> /dev/null; then
    echo "✅ Railway CLI found"
    
    # Check if logged in
    if railway whoami &> /dev/null; then
        echo "✅ Logged in to Railway"
        echo ""
        echo "📊 Railway Status:"
        railway status 2>&1 || echo "  No project linked or service not found"
        echo ""
        
        echo "📋 Recent Logs (last 50 lines):"
        railway logs --tail 50 2>&1 | tail -20 || echo "  Could not fetch logs"
        echo ""
        
        echo "🌐 Service URL:"
        railway domain 2>&1 || echo "  Could not get domain"
        echo ""
    else
        echo "⚠️  Not logged in to Railway"
        echo "   Run: railway login"
        echo ""
    fi
else
    echo "⚠️  Railway CLI not found"
    echo "   Install: npm i -g @railway/cli"
    echo ""
fi

# Check GitHub Actions
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI found"
    echo ""
    echo "📦 Recent GitHub Actions Runs:"
    gh run list --limit 3 2>&1 || echo "  Could not fetch GitHub Actions"
    echo ""
else
    echo "⚠️  GitHub CLI not found"
    echo "   Install: brew install gh (or visit https://cli.github.com)"
    echo ""
fi

# Check if we can access the service URL
if [ -n "$RAILWAY_SERVICE_URL" ]; then
    echo "🏥 Testing Health Endpoint:"
    echo "   URL: $RAILWAY_SERVICE_URL/health"
    
    response=$(curl -s -w "\n%{http_code}" "$RAILWAY_SERVICE_URL/health" 2>/dev/null || echo -e "\n000")
    status_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | head -n -1)
    
    if [ "$status_code" = "200" ]; then
        echo "   ✅ Health check passed (HTTP $status_code)"
        echo "   Response: $body"
    else
        echo "   ❌ Health check failed (HTTP $status_code)"
    fi
    echo ""
fi

echo "💡 To monitor continuously:"
echo "   railway logs --follow"
echo ""
echo "💡 To check Railway dashboard:"
echo "   https://railway.app"

