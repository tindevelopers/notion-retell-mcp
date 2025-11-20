#!/bin/bash

# Railway Setup Script
# Guides through Railway login and project linking

set -e

echo "🚀 Railway Setup Script"
echo "======================"
echo ""

# Check Railway CLI
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found"
    echo ""
    echo "Install Railway CLI:"
    echo "  npm i -g @railway/cli"
    echo ""
    exit 1
fi

echo "✅ Railway CLI found"
echo ""

# Check if already logged in
if railway whoami &> /dev/null; then
    USER=$(railway whoami 2>/dev/null | head -1 || echo "Unknown")
    echo "✅ Already logged in as: $USER"
    echo ""
else
    echo "⚠️  Not logged in to Railway"
    echo ""
    echo "Please login to Railway:"
    echo "  railway login"
    echo ""
    echo "This will open a browser for authentication."
    echo ""
    read -p "Press Enter after you've logged in, or Ctrl+C to exit..."
    echo ""
fi

# Check if project is linked
if railway status &> /dev/null; then
    echo "✅ Project already linked"
    echo ""
    railway status
    echo ""
else
    echo "⚠️  No project linked"
    echo ""
    echo "Available projects:"
    railway list 2>&1 || echo "  Could not list projects"
    echo ""
    echo "Link your project:"
    echo "  railway link"
    echo ""
    echo "Or link to a specific project:"
    echo "  railway link <project-id>"
    echo ""
    read -p "Press Enter after linking project, or Ctrl+C to exit..."
    echo ""
fi

# Verify setup
echo "🔍 Verifying setup..."
echo ""

if railway whoami &> /dev/null && railway status &> /dev/null; then
    echo "✅ Setup complete!"
    echo ""
    echo "📋 Project Status:"
    railway status
    echo ""
    
    SERVICE_URL=$(railway domain 2>/dev/null | head -n 1 || echo "")
    if [ -n "$SERVICE_URL" ]; then
        echo "🌐 Service URL: $SERVICE_URL"
        echo ""
    fi
    
    echo "📊 To monitor logs:"
    echo "  ./scripts/monitor-railway.sh"
    echo ""
    echo "📊 Or use Railway CLI:"
    echo "  railway logs --follow"
    echo ""
else
    echo "❌ Setup incomplete"
    echo "   Please ensure you're logged in and project is linked"
    exit 1
fi

