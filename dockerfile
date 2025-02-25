# Build stage
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Add non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Update and install security dependencies
RUN apk update && \
    apk upgrade && \
    apk add --no-cache dumb-init

# Copy package files with proper permissions
COPY --chown=appuser:appgroup package.json yarn.lock ./

# Install dependencies with specific flags for security
RUN yarn install --frozen-lockfile --production=false --network-timeout 300000

# Copy source code with proper owner
COPY --chown=appuser:appgroup . .

# Build application
RUN yarn build && \
    yarn cache clean

# Scan for vulnerabilities (optional - uncomment if you have yarn audit or other tools)
# RUN yarn audit --groups dependencies && yarn audit --groups devDependencies

# Production stage with Nginx
FROM nginx:alpine-slim

# Install security updates
RUN apk update && \
    apk upgrade && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/*

# Add non-root user for nginx
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    # Update permissions for nginx
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    chown -R appuser:appgroup /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx config with hardened settings
COPY --chown=appuser:appgroup nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files from build stage with correct permissions
COPY --from=build --chown=appuser:appgroup /app/build /usr/share/nginx/html

# Set correct permissions
RUN chmod -R 755 /usr/share/nginx/html && \
    chmod -R 755 /var/cache/nginx /var/log/nginx /var/run/nginx.pid

# Configure nginx to run with the created user
RUN sed -i 's/user  nginx/user  appuser/g' /etc/nginx/nginx.conf

# Set security headers
RUN echo "add_header X-Content-Type-Options nosniff;" >> /etc/nginx/conf.d/default.conf && \
    echo "add_header X-XSS-Protection \"1; mode=block\";" >> /etc/nginx/conf.d/default.conf && \
    echo "add_header Content-Security-Policy \"default-src 'self'; script-src 'self'; object-src 'none'\";" >> /etc/nginx/conf.d/default.conf

# Expose port 8080 instead of 80 (non-privileged)
EXPOSE 8080

# Use dumb-init as PID 1 to handle signals properly
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:8080/ || exit 1

# Security related environment variables
ENV NODE_ENV=production \
    NPM_CONFIG_LOGLEVEL=warn

# Add important security metadata as labels
LABEL org.opencontainers.image.vendor="Your Organization" \
      org.opencontainers.image.title="Threat Composer Tool" \
      org.opencontainers.image.description="Secure container for Threat Composer Tool" \
      security.alpha.kubernetes.io/seccomp=runtime/default \
      org.opencontainers.image.created="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Switch to non-root user
USER appuser

# Run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]