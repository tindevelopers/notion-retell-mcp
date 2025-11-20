# Dockerfile for Railway deployment
# Multi-stage build for optimized image size

# Build stage
FROM node:20-slim AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (including dev dependencies for build)
RUN npm ci --ignore-scripts

# Copy source code and configuration files
COPY tsconfig.json ./
COPY scripts/ ./scripts/
COPY src/ ./src/

# Build the project
RUN npm run build

# Production stage
FROM node:20-slim

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --ignore-scripts --omit-dev && \
    npm cache clean --force

# Copy built files from builder stage
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/build ./build

# Copy scripts directory (needed for notion-openapi.json)
COPY --from=builder /app/scripts ./scripts

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080
ENV OPENAPI_MCP_HEADERS="{}"

# Expose port (Railway will set PORT env var)
EXPOSE 8080

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:' + (process.env.PORT || 8080) + '/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start command (hybrid transport mode)
CMD ["node", "bin/cli.mjs", "--transport", "hybrid"]
