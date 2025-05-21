FROM mariadb:10.6

COPY conf/mariadb.cnf /etc/mysql/conf.d/mariadb.cnf
COPY tools/script.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]
