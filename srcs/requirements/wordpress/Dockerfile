FROM alpine:3.19

RUN apk update && apk add --no-cache \
  php php83 php83-fpm php83-mysqli php83-mbstring php83-gd php83-opcache \
  php83-phar php83-xml php83-ctype php83-curl php83-json php83-tokenizer \
  mariadb-client wget tar curl && \
  mkdir -p /run/php /var/www

RUN wget https://wordpress.org/latest.tar.gz -P /tmp && \
    tar -xzf /tmp/latest.tar.gz -C /var/www && \
    rm /tmp/latest.tar.gz && \
    chown -R www-data:www-data /var/www/wordpress

COPY ./conf/wp-config.php /var/www/wordpress/wp-config.php

COPY ./tools/script.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
