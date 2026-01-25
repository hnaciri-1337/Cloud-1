#!/bin/sh
set -e

: "${DB_ROOT_PASSWORD:?Required in srcs/.env, see USER_DOC.md}"
: "${DB_NAME:?Required in srcs/.env, see USER_DOC.md}"
: "${DB_ADMIN_USER:?Required in srcs/.env, see USER_DOC.md}"
: "${DB_ADMIN_PASSWORD:?Required in srcs/.env, see USER_DOC.md}"

DATADIR=/var/lib/mysql

if [ ! -d "$DATADIR/mysql" ]; then
	echo "Database not found, installing MySQL..."
	mysql_install_db --user=mysql --datadir="$DATADIR"


	mysqld --user=mysql --datadir="$DATADIR" --skip-networking &
	TMP_PID=$!

	until mysqladmin ping --silent; do
		echo "Waiting for database server to start..."
		sleep 1
	done

	echo "Configuring root password and creating database and user..."
	mysql -uroot <<-EOSQL
		CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
		CREATE USER IF NOT EXISTS '${DB_ADMIN_USER}'@'%' IDENTIFIED BY '${DB_ADMIN_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_ADMIN_USER}'@'%';
		FLUSH PRIVILEGES;
	EOSQL

	mysqladmin shutdown
	wait $TMP_PID

else
	echo "Database already exists, skipping initialization."
fi

echo "Starting MySQL server (0.0.0.0:3306)..."
exec mysqld --user=mysql --datadir="$DATADIR" --bind-address=0.0.0.0 --port=3306
