#!/usr/bin/env bash

# Path to custom my.cnf
DB_CONF_ROUTE="/etc/mysql/my.cnf"

# Write config file
cat > "$DB_CONF_ROUTE" <<EOF
[mysqld]
bind-address = 0.0.0.0
datadir = $DB_INSTALL
EOF

# Initialize DB
mysql_install_db --datadir="$DB_INSTALL"

# Start MySQL in background using custom config
mysqld_safe --defaults-file="$DB_CONF_ROUTE" &
mysql_pid=$!

# Wait until MySQL is ready
until mysqladmin ping >/dev/null 2>&1; do
  echo -n "."; sleep 0.2
done

# Create DB, user, and set password
mysql -u root <<-EOSQL
CREATE DATABASE IF NOT EXISTS $DB_NAME;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
FLUSH PRIVILEGES;
EOSQL

wait "$mysql_pid"
