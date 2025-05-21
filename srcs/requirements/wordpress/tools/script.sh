#!/bin/sh
set -e

echo "Starting WordPress container..."

: "${WP_DB_HOST:=mariadb}"

chown -R www-data:www-data /var/www

echo "Waiting for MariaDB at $WP_DB_HOST..."
until mysqladmin ping -h"$WP_DB_HOST" --silent; do
    sleep 1
done
echo "MariaDB is ready."

command -v wp >/dev/null 2>&1 || {
    echo >&2 "wp CLI not found – make sure it's installed and in PATH."
    exit 1
}

WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials)

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="$WP_SITE_URL" \
        --title="$WP_SITE_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    if [ "$(stat -c %U /var/www/wordpress)" != "www-data" ]; then
        chown -R www-data:www-data /var/www
    fi
fi

exec php-fpm83 -F
