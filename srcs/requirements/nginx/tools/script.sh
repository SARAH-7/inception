#!/bin/sh
set -e

# Check if SSL certs exist; generate if missing
if [ ! -f /etc/ssl/certs/sbakhit.crt ] || [ ! -f /etc/ssl/private/sbakhit.key ]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/sbakhit.key \
        -out /etc/ssl/certs/sbakhit.crt \
        -subj "/CN=localhost"
fi

echo "Starting nginx..."
exec nginx -g "daemon off;"
