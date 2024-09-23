#!/bin/bash

# Initialize the MariaDB database if it hasn't been initialized yet
if [ ! -d "/var/lib/mariadb/mariadb" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=my_user --datadir=/var/lib/mariadb
fi

# Start the MariaDB server temporarily in the background
mysqld_safe --skip-networking & until mysqladmin ping --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 1
done

# Create the database and user using environment variables
cat << EOF > init.sql
CREATE DATABASE IF NOT EXISTS \`${MDB_NAME}\`;
CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_PWD}';
GRANT ALL PRIVILEGES ON \`${MDB_NAME}\`.* TO '${MDB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysql -u root -p${MDB_ROOT_PWD} < init.sql
rm -f init.sql

mysqladmin -u root -p${MDB_ROOT_PWD} shutdown

exec mysqld --bind-address=0.0.0.0

# To check if mariadb isn't empty, use the following command:
# mariadb
# SHOW DATABASES;
# USE <database>;
# SHOW TABLES;
# SELECT <anything> FROM <table>;
# EXIT;