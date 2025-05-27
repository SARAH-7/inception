FROM	debian:bullseye

RUN		apt update && apt upgrade -y && apt install -y \
    	openssl \
    	nginx \
    	curl \
    	vim \
    	sudo
RUN		rm -f /etc/nginx/nginx.conf && \
		mkdir -p /var/www/html && \
		chown -R www-data:www-data /var/www/html && \
		chmod -R 755 /var/www/html

COPY 	./conf/nginx.conf /etc/nginx/nginx.conf
COPY 	./tools/script.sh /setup_script.sh

RUN chmod +x /setup_script.sh

EXPOSE 443

ENTRYPOINT ["sh", "/setup_script.sh"]
