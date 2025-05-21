#!/bin/sh

service mysql start;
					mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
					mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
					mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
					mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
					mysql -e "FLUSH PRIVILEGES;"
					mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
					exec mysqld_safe


#!/bin/bash
set -e

# Check if the database already exists (i.e., this isn't the first run)
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    echo "Initializing MariaDB..."

    mysqld --bootstrap <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    echo "MariaDB initialization complete."
else
    echo "MariaDB already initialized. Skipping setup."
fi

# Start the server
exec mysqld_safe
