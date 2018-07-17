FROM php:7-fpm-alpine
MAINTAINER krish512 <krish512@hotmail.com>

WORKDIR /var/www/html

RUN apk update \
    && apk add ca-certificates \
    && update-ca-certificates \
    && apk add openssl

RUN && apk add \
	nginx \
	gzip \
	pcre \
        php7-fpm \
        php7-curl \
        php7-gd \
        php7-mbstring \
        php7-mysqli \
        php7-mysqlnd \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        php7-xml \
        php7-openssl \
        php7-zlib \
	php7-memcached \
	php7-json \
    && rm -rf /var/cache/apk/* \
    && wget -qO- https://download.revive-adserver.com/revive-adserver-4.1.4.tar.gz | tar xz --strip 1 \
    && chown -R nobody:nobody . \
    && echo -e "#!/bin/sh\ncurl -s -o /dev/null http://localhost/maintenance/maintenance.php" > /etc/periodic/daily/maintenance \
    && chmod +x /etc/periodic/daily/maintenance

COPY nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx

EXPOSE 80

CMD crond -l 2 -b && php-fpm7 && nginx -g 'daemon off;'
