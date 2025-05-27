FROM alpine:3.19

RUN apk update && apk add --no-cache mariadb mariadb-client openrc \
 && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY tools/script.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
