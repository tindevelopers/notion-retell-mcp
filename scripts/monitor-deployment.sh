#!/bin/bash

# Railway Deployment Monitor Script
# Monitors Railway deployment status and logs

set -e

RAILWAY_SERVICE_URL="${RAILWAY_SERVICE_URL:-}"
HEALTH_ENDPOINT="${HEALTH_ENDPOINT:-/health}"
MAX_RETRIES=30
RETRY_DELAY=5

echo "🚀 Railway Deployment Monitor"
echo "=============================="
echo ""

if [ -z "$RAILWAY_SERVICE_URL" ]; then
    echo "❌ Error: RAILWAY_SERVICE_URL environment variable not set"
    echo "   Set it to your Railway service URL (e.g., https://your-app.railway.app)"
    exit 1
fi

echo "📍 Service URL: $RAILWAY_SERVICE_URL"
echo "🏥 Health Endpoint: $HEALTH_ENDPOINT"
echo "⏱️  Max Retries: $MAX_RETRIES"
echo "⏳ Retry Delay: ${RETRY_DELAY}s"
echo ""

# Function to check health endpoint
check_health() {
    local url="${RAILWAY_SERVICE_URL}${HEALTH_ENDPOINT}"
    local response=$(curl -s -w "\n%{http_code}" "$url" 2>/dev/null || echo -e "\n000")
    local body=$(echo "$response" | head -n -1)
    local status_code=$(echo "$response" | tail -n 1)
    
    if [ "$status_code" = "200" ]; then
        echo "✅ Health check passed (HTTP $status_code)"
        echo "   Response: $body"
        return 0
    else
        echo "❌ Health check failed (HTTP $status_code)"
        return 1
    fi
}

# Function to check if service is responding
check_service() {
    local url="${RAILWAY_SERVICE_URL}"
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    
    if [ "$status_code" != "000" ]; then
        return 0
    else
        return 1
    fi
}

echo "🔍 Starting deployment monitoring..."
echo ""

# Wait for service to be accessible
attempt=1
while [ $attempt -le $MAX_RETRIES ]; do
    echo "[$attempt/$MAX_RETRIES] Checking service availability..."
    
    if check_service; then
        echo "✅ Service is responding"
        break
    else
        if [ $attempt -eq $MAX_RETRIES ]; then
            echo "❌ Service not responding after $MAX_RETRIES attempts"
            echo "   Check Railway dashboard for deployment status"
            exit 1
        fi
        echo "⏳ Service not ready yet, waiting ${RETRY_DELAY}s..."
        sleep $RETRY_DELAY
    fi
    
    attempt=$((attempt + 1))
done

echo ""
echo "🏥 Checking health endpoint..."

# Check health endpoint
attempt=1
while [ $attempt -le $MAX_RETRIES ]; do
    if check_health; then
        echo ""
        echo "🎉 Deployment successful!"
        echo ""
        echo "📍 Service URL: $RAILWAY_SERVICE_URL"
        echo "🏥 Health Check: ${RAILWAY_SERVICE_URL}${HEALTH_ENDPOINT}"
        echo ""
        echo "✅ Your Notion MCP Server is ready for Retell AI!"
        exit 0
    else
        if [ $attempt -eq $MAX_RETRIES ]; then
            echo ""
            echo "❌ Health check failed after $MAX_RETRIES attempts"
            echo "   Check Railway logs for errors:"
            echo "   railway logs --service your-service-name"
            exit 1
        fi
        echo "⏳ Waiting ${RETRY_DELAY}s before retry..."
        sleep $RETRY_DELAY
    fi
    
    attempt=$((attempt + 1))
done

