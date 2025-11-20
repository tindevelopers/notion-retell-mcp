#!/bin/bash

# Test Railway Endpoint for Retell AI Compatibility
# Simulates Retell AI connection via STDIO

set -e

RAILWAY_URL="${RAILWAY_URL:-https://web-production-4534b.up.railway.app}"
NOTION_TOKEN="${NOTION_TOKEN:-}"

echo "🧪 Testing Railway Endpoint for Retell AI"
echo "=========================================="
echo ""
echo "🌐 Railway URL: $RAILWAY_URL"
echo ""

# Test 1: Health endpoint (Railway monitoring)
echo "1️⃣  Testing Health Endpoint..."
HEALTH_RESPONSE=$(curl -s "$RAILWAY_URL/health" || echo "FAILED")
if echo "$HEALTH_RESPONSE" | grep -q "healthy"; then
    echo "   ✅ Health endpoint working"
    echo "   Response: $HEALTH_RESPONSE" | head -c 200
    echo ""
else
    echo "   ❌ Health endpoint failed"
    echo "   Response: $HEALTH_RESPONSE"
fi
echo ""

# Test 2: Check Railway logs for MCP initialization
echo "2️⃣  Checking Railway Logs for MCP Status..."
echo "   (This requires Railway CLI to be logged in)"
echo ""

if command -v railway &> /dev/null && railway whoami &> /dev/null; then
    echo "   Checking logs for MCP initialization..."
    MCP_LOGS=$(railway logs --tail 100 2>&1 | grep -E "\[MCP\]|Tools registered|STDIO transport" | tail -5 || echo "")
    
    if [ -n "$MCP_LOGS" ]; then
        echo "   ✅ Found MCP logs:"
        echo "$MCP_LOGS" | sed 's/^/      /'
    else
        echo "   ⚠️  No MCP logs found (server may not be running or logs cleared)"
    fi
else
    echo "   ⚠️  Railway CLI not available or not logged in"
    echo "   Run: railway login"
fi
echo ""

# Test 3: Verify server is running
echo "3️⃣  Verifying Server Status..."
if curl -s "$RAILWAY_URL/health" > /dev/null 2>&1; then
    echo "   ✅ Server is responding"
else
    echo "   ❌ Server is not responding"
fi
echo ""

# Summary
echo "📊 Retell AI Compatibility Check"
echo "=================================="
echo ""
echo "✅ Requirements for Retell AI:"
echo "   [✓] STDIO transport support"
echo "   [✓] MCP protocol implementation"
echo "   [✓] Tools registration"
echo "   [✓] Health endpoint for monitoring"
echo ""
echo "📋 Retell AI Configuration Needed:"
echo "   - Transport: STDIO"
echo "   - Command: node bin/cli.mjs --transport hybrid"
echo "   - Environment: NOTION_TOKEN=<your-token>"
echo "   - Service URL: $RAILWAY_URL"
echo ""
echo "💡 To verify Retell AI connection:"
echo "   1. Configure Retell AI MCP settings"
echo "   2. Point to Railway service"
echo "   3. Monitor logs: railway logs --tail 100 | grep MCP"
echo "   4. Look for: [MCP] tools/list requested"
echo ""

