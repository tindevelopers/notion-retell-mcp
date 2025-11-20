#!/usr/bin/env node

/**
 * Simple test script for Notion MCP Server using Node.js built-in modules
 */

import http from 'http';

const SERVER_URL = 'http://localhost:3000';
const AUTH_TOKEN = 'test-token-12345';

function makeRequest(options, data = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(options.path, SERVER_URL);
    const req = http.request({
      hostname: url.hostname,
      port: url.port,
      path: url.pathname,
      method: options.method || 'GET',
      headers: {
        ...options.headers,
        'Content-Type': 'application/json'
      }
    }, (res) => {
      let body = '';
      res.on('data', (chunk) => { body += chunk; });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(body);
          resolve({ status: res.statusCode, headers: res.headers, data: parsed });
        } catch (e) {
          resolve({ status: res.statusCode, headers: res.headers, data: body });
        }
      });
    });

    req.on('error', reject);
    
    if (data) {
      req.write(JSON.stringify(data));
    }
    req.end();
  });
}

async function test() {
  console.log('🚀 Testing Notion MCP Server\n');
  
  // Test 1: Health endpoint
  console.log('1️⃣  Testing health endpoint...');
  try {
    const health = await makeRequest({ path: '/health', method: 'GET' });
    console.log('   Status:', health.status);
    console.log('   Response:', JSON.stringify(health.data, null, 2));
    console.log('   ✅ Health check passed\n');
  } catch (error) {
    console.log('   ❌ Health check failed:', error.message);
    return;
  }

  // Test 2: Initialize MCP session
  console.log('2️⃣  Testing MCP initialize...');
  try {
    const init = await makeRequest({
      path: '/mcp',
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${AUTH_TOKEN}`
      }
    }, {
      jsonrpc: '2.0',
      method: 'initialize',
      params: {
        protocolVersion: '2024-11-05',
        capabilities: {},
        clientInfo: {
          name: 'test-client',
          version: '1.0.0'
        }
      },
      id: 1
    });
    
    console.log('   Status:', init.status);
    console.log('   Response:', JSON.stringify(init.data, null, 2));
    
    const sessionId = init.headers['mcp-session-id'] || init.data?.result?.sessionId;
    if (sessionId) {
      console.log('   ✅ Initialize passed, session ID:', sessionId, '\n');
      
      // Test 3: List tools
      console.log('3️⃣  Testing tools/list...');
      try {
        const tools = await makeRequest({
          path: '/mcp',
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${AUTH_TOKEN}`,
            'mcp-session-id': sessionId
          }
        }, {
          jsonrpc: '2.0',
          method: 'tools/list',
          params: {},
          id: 2
        });
        
        console.log('   Status:', tools.status);
        if (tools.data.result?.tools) {
          console.log(`   ✅ Found ${tools.data.result.tools.length} tools`);
          console.log('   Tools:', tools.data.result.tools.map(t => t.name).join(', '));
        } else {
          console.log('   Response:', JSON.stringify(tools.data, null, 2));
        }
      } catch (error) {
        console.log('   ❌ Tools list failed:', error.message);
      }
    } else {
      console.log('   ⚠️  No session ID returned');
    }
  } catch (error) {
    console.log('   ❌ Initialize failed:', error.message);
    console.log('   💡 Make sure the server is running with auth token:', AUTH_TOKEN);
  }
  
  console.log('\n✅ Test completed!');
}

test().catch(console.error);

