#!/bin/sh
set -e

# Only initialize if database doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[Init] Initializing MariaDB database..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB in the background without service manager
echo "[Init] Starting temporary MariaDB instance..."
mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/tmp/mysql.sock &
MARIADB_PID=$!

# Wait for MariaDB to be ready
echo "[Init] Waiting for MariaDB to be ready..."
for i in {30..0}; do
    if echo 'SELECT 1' | mariadb -uroot --socket=/tmp/mysql.sock &>/dev/null; then
        break
    fi
    sleep 1
done
if [ "$i" = 0 ]; then
    echo >&2 "[Init] MariaDB failed to start"
    exit 1
fi

# Execute initialization commands
echo "[Init] Configuring database..."
mariadb -uroot --socket=/tmp/mysql.sock <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Stop the temporary instance
echo "[Init] Stopping temporary MariaDB instance..."
kill "$MARIADB_PID"
wait "$MARIADB_PID"

echo "[Init] MariaDB initialization complete"
exec mariadbd --user=mysql --datadir=/var/lib/mysql
