#!/bin/sh
set -e

# Create cert directory if it doesn't exist
mkdir -p "$CERT_DIR"

# Generate SSL certificate
openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
  -keyout "$CERT_KEY" \
  -out "$CERT" \
  -subj "/CN=$HOST_NAME"

# Copy nginx.conf to the correct location (optional if COPY in Dockerfile)
cp /etc/nginx/conf/nginx.conf "$NGINX_CONF"

# Start Nginx
exec nginx -g "daemon off;"
