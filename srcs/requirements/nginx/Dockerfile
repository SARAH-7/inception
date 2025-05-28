FROM debian:bullseye

RUN apt -y update && apt install -y nginx && apt upgrade -y openssl

COPY ./conf/nginx.conf /etc/nginx/conf/nginx.conf
COPY ./tools/conf.sh /usr/local/bin/conf.sh

RUN chmod +x /usr/local/bin/conf.sh

ENTRYPOINT ["conf.sh"]