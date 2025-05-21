#!/bin/bash

server {
    #SSL/TLS Configuration
    listen 443 ssl;
    ssl_protocols TLSv1.3;
    ssl_certificate /etc/ssl/certs/sbakhit.crt;
    ssl_certificate_key /etc/ssl/private/sbakhit.key;

    #root and index and server_name
    root /var/www/html;
    server_name localhost;
    index index.php index.html index.htm;
}