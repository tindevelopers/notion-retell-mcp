#!/bin/bash
# Script to create multiple Railway services for different Notion databases
# Usage: ./create-multi-service.sh <database-name> <notion-token>

set -e

DATABASE_NAME=$1
NOTION_TOKEN=$2

if [ -z "$DATABASE_NAME" ] || [ -z "$NOTION_TOKEN" ]; then
  echo "Usage: $0 <database-name> <notion-token>"
  echo "Example: $0 my-database ntn_abc123..."
  exit 1
fi

SERVICE_NAME="notion-${DATABASE_NAME}"

echo "🚀 Creating Railway service: $SERVICE_NAME"
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

# Create service
echo "📦 Creating service..."
railway service create "$SERVICE_NAME" 2>&1 || {
  echo "⚠️  Service may already exist, continuing..."
}

# Switch to service
echo "🔄 Switching to service..."
railway service use "$SERVICE_NAME"

# Set environment variable
echo "🔑 Setting NOTION_TOKEN..."
railway variables set "NOTION_TOKEN=$NOTION_TOKEN"

# Deploy
echo "🚢 Deploying..."
railway up

# Get service URL
echo ""
echo "✅ Service created and deployed!"
echo ""
echo "📋 Service Details:"
echo "   Name: $SERVICE_NAME"
echo "   URL: Check Railway dashboard for URL"
echo ""
echo "🔗 To get URL:"
echo "   railway domain"
echo ""
echo "⚙️  To configure Retell AI:"
echo "   URL: https://your-service.railway.app"
echo "   Headers: Content-Type: application/json"
echo ""

