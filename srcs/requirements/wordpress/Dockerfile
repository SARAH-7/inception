FROM alpine:3.19

# Install PHP, extensions, and utilities
RUN apk update && apk add --no-cache \
  php php-fpm php-mysqli php-mbstring php-gd php-opcache \
  php-phar php-xml php-ctype php-curl php-json php-tokenizer \
  mariadb-client wget tar curl

RUN mkdir -p /run/php /var/www && \
    adduser -u 82 -D -S -G www-data www-data || true && \
    wget https://wordpress.org/latest.tar.gz -P /tmp && \
    tar -xzf /tmp/latest.tar.gz -C /var/www && \
    rm /tmp/latest.tar.gz && \
    chown -R www-data:www-data /var/www/wordpress

# Copy configuration and entrypoint
COPY ./conf/wp-config.php /var/www/wordpress/wp-config.php
COPY ./tools/script.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
