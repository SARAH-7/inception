#!/bin/sh
set -e

echo "Starting WordPress container..."

# Setup wp-cli if not already available
if ! command -v wp >/dev/null 2>&1; then
    echo "Installing WP-CLI..."
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Create WordPress directory
mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

# Download WordPress core
php -d memory_limit=512M /usr/local/bin/wp --allow-root core download --force

# Permissions for WordPress files
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Prepare wp-config.php from sample
cp wp-config-sample.php wp-config.php

# Read credentials from Docker secrets
MARIADB_PWD=$MYSQL_PASSWORD

# Replace placeholders in wp-config.php
sed -i "s/'database_name_here'/'$MARIADB_NAME'/g" wp-config.php
sed -i "s/'username_here'/'$MARIADB_USER'/g" wp-config.php
sed -i "s/'password_here'/'$MARIADB_PWD'/g" wp-config.php
sed -i "s/'localhost'/'mariadb'/g" wp-config.php

# Dynamically detect the PHP major.minor version
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;')
FPM_CONF="/etc/php$PHP_VERSION/php-fpm.d/www.conf"

if [ -f "$FPM_CONF" ]; then
    echo "Found PHP-FPM config at $FPM_CONF"
    sed -i "s|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|g" "$FPM_CONF"
    echo 'listen.owner = nobody' >> "$FPM_CONF"
    echo 'listen.group = nobody' >> "$FPM_CONF"
else
    echo "PHP-FPM config not found at $FPM_CONF"
    exit 1
fi


# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
until mysqladmin ping -h mariadb --silent; do
    sleep 1
done
echo "MariaDB is ready."

# Install WordPress
if ! wp core is-installed --allow-root --path=/var/www/html/wordpress; then
    echo "Installing WordPress core..."
    wp core install \
        --url='https://sbakhit.42.fr' \
        --title='WordPress' \
        --admin_user="$WP_USER" \
        --admin_password="$WP_PASSWORD" \
        --admin_email="$WP_EMAIL" \
        --skip-email \
        --allow-root \
        --path=/var/www/html/wordpress

    wp user create "$WP_USER2" "$WP_EMAIL2" \
        --role=subscriber \
        --user_pass="$WP_PASS2" \
        --allow-root \
        --path=/var/www/html/wordpress
fi

# Start PHP-FPM in foreground
exec php-fpm --nodaemonize
