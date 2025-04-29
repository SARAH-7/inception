# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sbakhit <sbakhit@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/29 19:04:59 by sbakhit           #+#    #+#              #
#    Updated: 2025/04/29 19:17:42 by sbakhit          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update -y && \
    apt-get install -y mariadb-server

COPY script.sh /tmp/script.sh

RUN  chmod +x /tmp/script.sh

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf 

ENTRYPOINT ["bash", "/tmp/script.sh"]

CMD ["mysqld_safe"]


