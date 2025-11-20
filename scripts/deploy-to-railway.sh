#!/bin/bash

# Railway Deployment Script
# Handles deployment and monitoring

set -e

echo "🚀 Railway Deployment Script"
echo "============================"
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "⚠️  Railway CLI not found. Installing..."
    echo ""
    echo "Install Railway CLI:"
    echo "  npm i -g @railway/cli"
    echo ""
    echo "Or visit: https://docs.railway.app/develop/cli"
    echo ""
    read -p "Press Enter after installing Railway CLI, or Ctrl+C to exit..."
fi

# Check if logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Not logged in to Railway. Please login:"
    railway login
fi

echo ""
echo "📦 Building project..."
npm run build

echo ""
echo "🚀 Deploying to Railway..."
echo ""

# Deploy using Railway CLI
railway up

echo ""
echo "⏳ Waiting for deployment to complete..."
sleep 10

# Get service URL
SERVICE_URL=$(railway domain 2>/dev/null | head -n 1 || echo "")

if [ -z "$SERVICE_URL" ]; then
    echo "⚠️  Could not automatically detect service URL"
    echo "   Check Railway dashboard for your service URL"
    echo ""
    read -p "Enter your Railway service URL: " SERVICE_URL
fi

echo ""
echo "🔍 Monitoring deployment..."
echo ""

# Run monitor script
export RAILWAY_SERVICE_URL="$SERVICE_URL"
bash scripts/monitor-deployment.sh

