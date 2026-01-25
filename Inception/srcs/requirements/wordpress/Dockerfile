FROM alpine:3.22

WORKDIR /var/www/html

RUN apk add --no-cache \
    curl \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-phar \
    php83-json \
    php83-mbstring \
	&& curl -o wp.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wp.tar.gz --strip-components=1 \
    && rm wp.tar.gz \
	&& sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php83/php-fpm.d/www.conf \
	&& sed -i 's/^;clear_env = no/clear_env = no/' /etc/php83/php-fpm.d/www.conf \
	&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/wp-config.php /var/www/html/wp-config.php

COPY ./tools/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "sh", "/entrypoint.sh" ]