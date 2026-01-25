FROM alpine:3.22

WORKDIR /app

COPY . .

RUN apk add --no-cache \
	nginx \
	openssl \
	&& openssl genrsa -out /etc/ssl/private/server.key 2048 \
	&& openssl req -new -x509 -key /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt -days 365 -subj "/CN=localhost"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;"]