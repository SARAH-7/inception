#!/bin/sh
set -e

: "${MYSQL_DB:?Missing MYSQL_DB}"
: "${MYSQL_USER:?Missing MYSQL_USER}"
: "${MYSQL_PASSWORD:?Missing MYSQL_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:?Missing MYSQL_ROOT_PASSWORD}"

echo "[Init] Checking if MariaDB is already initialized..."

if [ -d "/var/lib/mysql/${MYSQL_DB}" ]; then
    echo "[Init] MariaDB already initialized. Skipping setup."
else
    echo "[Init] Initializing MariaDB..."
    mysqld --user=mysql --bootstrap <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
        CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO \`${MYSQL_USER}\`@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL
    echo "[Init] MariaDB initialization complete."
fi

exec mysqld_safe
