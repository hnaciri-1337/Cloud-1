FROM alpine:3.22

WORKDIR /app

COPY . .

RUN apk add --no-cache mysql mysql-client \
	&& mkdir -p /run/mysqld \
	&& chmod 777 /run/mysqld \
	&& ls /etc/ | grep my \
	&& sed -i 's/^#bind-address\s*=.*/bind-address = 0.0.0.0\nport=3306/' /etc/my.cnf.d/mariadb-server.cnf \
	&& sed -i '/skip-networking/d' /etc/my.cnf.d/mariadb-server.cnf

ENTRYPOINT [ "sh", "./tools/entrypoint.sh" ]


