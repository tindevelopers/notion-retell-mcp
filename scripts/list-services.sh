#!/bin/bash
# List all Railway services in the current project

echo "📋 Railway Services in Current Project"
echo "======================================"
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
  echo "❌ Railway CLI not found. Install with: npm i -g @railway/cli"
  exit 1
fi

# Check if logged in
if ! railway whoami &> /dev/null; then
  echo "❌ Not logged in to Railway. Run: railway login"
  exit 1
fi

# List services (Railway CLI doesn't have a direct list command, so we'll use status)
echo "Current project services:"
railway status 2>&1 | grep -i "service" || echo "Run 'railway service' to see available commands"
echo ""

echo "💡 To switch between services:"
echo "   railway service use <service-name>"
echo ""
echo "💡 To see service variables:"
echo "   railway variables"
echo ""

