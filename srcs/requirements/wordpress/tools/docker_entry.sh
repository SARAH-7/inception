#!/usr/bin/env bash

cd "$WP_ROUTE"

# Download WordPress core
wp core download --force --allow-root

# Create wp-config.php with DB credentials
wp config create \
  --path="$WP_ROUTE" \
  --allow-root \
  --dbname="$DB_NAME" \
  --dbuser="$DB_USER" \
  --dbpass="$DB_PASS" \
  --dbhost="$DB_HOST" \
  --dbprefix=wp_

# Install WordPress if not already installed
if ! wp core is-installed --allow-root --path="$WP_ROUTE"; then
  wp core install \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root

  wp user create \
    "$WP_USER" "$WP_EMAIL" \
    --role=author \
    --user_pass="$WP_PASS" \
    --allow-root
fi

# Install and enable Redis Object Cache plugin
wp plugin install redis-cache --activate --allow-root --path="$WP_ROUTE"

# Set Redis config in wp-config.php
wp config set WP_REDIS_HOST 'redis' --type=constant --allow-root --path="$WP_ROUTE"
wp config set WP_REDIS_PORT 6379 --raw --type=constant --allow-root --path="$WP_ROUTE"
wp config set WP_REDIS_PASSWORD "'${REDIS_PASSWORD}'" --type=constant --allow-root --path="$WP_ROUTE"
wp config set WP_REDIS_CLIENT 'phpredis' --type=constant --allow-root --path="$WP_ROUTE"
wp config set WP_CACHE_KEY_SALT 'sbakhit.local' --type=constant --allow-root --path="$WP_ROUTE"
wp config set WP_CACHE true --raw --type=constant --allow-root --path="$WP_ROUTE"

# Enable Redis object cache
wp redis enable --allow-root --path="$WP_ROUTE"

# Start PHP
php-fpm7.4 -F
