# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sbakhit <sbakhit@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/29 19:05:02 by sbakhit           #+#    #+#              #
#    Updated: 2025/04/29 19:13:57 by sbakhit          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt update; \
    apt install -y nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \ 
    -keyout /etc/ssl/private/aouhadou.key \
    -out /etc/ssl/certs/aouhadou.crt \
    -subj="/C=MA/ST=khouribga/L=khouribga/O=1337 School/OU=aouhadou/CN=aouhadou.42.fr"

COPY ./tools/certs.sh /tmp/certs.sh

RUN chmod +x /tmp/certs.sh

COPY ./conf/default /etc/nginx/sites-available/default


ENTRYPOINT ["/tmp/certs.sh"]