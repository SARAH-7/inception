FROM	debian:bullseye

RUN 	apt update && apt upgrade -y && apt install -y \
			openssl \
    		nginx \
    		curl \
    		vim \
    		sudo

RUN		rm -f /etc/nginx/nginx.conf

COPY	./config/nginx.conf /etc/nginx/nginx.conf
COPY	tools/setup_nginx.sh /setup_nginx.sh

RUN		chmod +x /setup_nginx.sh

EXPOSE	443

ENTRYPOINT	["sh", "/setup_nginx.sh"]
