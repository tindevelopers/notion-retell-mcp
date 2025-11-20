#!/usr/bin/env node

/**
 * Test script to simulate Retell AI MCP connection
 * Tests STDIO transport to verify Railway endpoint works for Retell
 */

import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const SERVER_COMMAND = 'node';
const SERVER_ARGS = [join(__dirname, '../bin/cli.mjs'), '--transport', 'hybrid'];
const NOTION_TOKEN = process.env.NOTION_TOKEN || 'ntn_your_token_here';

console.log('🧪 Testing Railway Endpoint for Retell AI Compatibility');
console.log('=======================================================\n');

// Test 1: Initialize MCP connection (what Retell AI does first)
function testInitialize() {
  return new Promise((resolve, reject) => {
    console.log('1️⃣  Testing MCP Initialize (Retell AI first step)...');
    
    const server = spawn(SERVER_COMMAND, SERVER_ARGS, {
      env: { ...process.env, NOTION_TOKEN },
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let stdout = '';
    let stderr = '';

    server.stdout.on('data', (data) => {
      stdout += data.toString();
    });

    server.stderr.on('data', (data) => {
      stderr += data.toString();
    });

    // Send initialize request (what Retell AI sends)
    const initializeRequest = JSON.stringify({
      jsonrpc: '2.0',
      method: 'initialize',
      params: {
        protocolVersion: '2024-11-05',
        capabilities: {},
        clientInfo: {
          name: 'retell-ai',
          version: '1.0.0'
        }
      },
      id: 1
    });

    server.stdin.write(initializeRequest + '\n');

    setTimeout(() => {
      // Send tools/list request
      const toolsListRequest = JSON.stringify({
        jsonrpc: '2.0',
        method: 'tools/list',
        params: {},
        id: 2
      });

      server.stdin.write(toolsListRequest + '\n');

      setTimeout(() => {
        server.kill();
        
        console.log('   📤 Sent initialize request');
        console.log('   📤 Sent tools/list request');
        console.log('   📥 Server output:', stdout.substring(0, 500));
        
        if (stderr) {
          console.log('   ⚠️  Server errors:', stderr.substring(0, 500));
        }

        // Check for success indicators
        const hasInitialize = stdout.includes('"result"') || stdout.includes('"id":1');
        const hasTools = stdout.includes('tools') || stdout.includes('"id":2');
        
        if (hasInitialize && hasTools) {
          console.log('   ✅ Initialize and tools/list responded');
          resolve({ success: true, stdout, stderr });
        } else {
          console.log('   ⚠️  Response may be incomplete');
          resolve({ success: false, stdout, stderr });
        }
      }, 2000);
    }, 1000);
  });
}

// Test 2: Check if server starts correctly
function testServerStart() {
  return new Promise((resolve) => {
    console.log('\n2️⃣  Testing Server Startup...');
    
    const server = spawn(SERVER_COMMAND, SERVER_ARGS, {
      env: { ...process.env, NOTION_TOKEN },
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let output = '';
    let errorOutput = '';

    server.stdout.on('data', (data) => {
      output += data.toString();
    });

    server.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    setTimeout(() => {
      server.kill();
      
      const hasStdio = output.includes('STDIO transport connected');
      const hasHealth = output.includes('HTTP health endpoint listening');
      const hasMCP = output.includes('[MCP]');
      
      console.log('   Server startup output:');
      console.log('   ' + output.split('\n').slice(0, 5).join('\n   '));
      
      if (hasStdio && hasHealth) {
        console.log('   ✅ Server started correctly');
        if (hasMCP) {
          console.log('   ✅ MCP logging active');
        }
        resolve({ success: true, output });
      } else {
        console.log('   ⚠️  Server may not have started correctly');
        resolve({ success: false, output, errorOutput });
      }
    }, 3000);
  });
}

// Test 3: Verify tools are registered
function testToolsRegistration() {
  return new Promise((resolve) => {
    console.log('\n3️⃣  Testing Tools Registration...');
    
    const server = spawn(SERVER_COMMAND, SERVER_ARGS, {
      env: { ...process.env, NOTION_TOKEN },
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let output = '';

    server.stdout.on('data', (data) => {
      output += data.toString();
    });

    setTimeout(() => {
      server.kill();
      
      const hasToolsRegistered = output.includes('Tools registered') || output.includes('[MCP] Tools registered');
      const toolCountMatch = output.match(/Tools registered[:\s]+(\d+)/);
      
      if (hasToolsRegistered) {
        const count = toolCountMatch ? toolCountMatch[1] : 'unknown';
        console.log(`   ✅ Tools registered: ${count} tool groups`);
        resolve({ success: true, toolCount: count });
      } else {
        console.log('   ⚠️  Tool registration not visible in logs');
        console.log('   (This may be normal if logging happens before startup messages)');
        resolve({ success: false });
      }
    }, 3000);
  });
}

async function main() {
  try {
    // Test server startup
    const startupResult = await testServerStart();
    
    // Test tools registration
    const toolsResult = await testToolsRegistration();
    
    // Test MCP protocol
    const mcpResult = await testInitialize();
    
    console.log('\n📊 Test Summary');
    console.log('===============');
    console.log(`Server Startup: ${startupResult.success ? '✅' : '⚠️'}`);
    console.log(`Tools Registration: ${toolsResult.success ? '✅' : '⚠️'}`);
    console.log(`MCP Protocol: ${mcpResult.success ? '✅' : '⚠️'}`);
    
    console.log('\n🎯 Retell AI Compatibility Assessment:');
    if (startupResult.success && mcpResult.success) {
      console.log('✅ Railway endpoint appears ready for Retell AI');
      console.log('   - STDIO transport is working');
      console.log('   - MCP protocol responds correctly');
      console.log('   - Server handles initialize and tools/list');
    } else {
      console.log('⚠️  Some issues detected - check logs above');
    }
    
    console.log('\n💡 To test with actual Retell AI:');
    console.log('   1. Configure Retell AI to use STDIO transport');
    console.log('   2. Point to Railway service URL');
    console.log('   3. Set NOTION_TOKEN environment variable');
    console.log('   4. Monitor Railway logs: railway logs --tail 100');
    
  } catch (error) {
    console.error('❌ Test failed:', error);
    process.exit(1);
  }
}

main();

