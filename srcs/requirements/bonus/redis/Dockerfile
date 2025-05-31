# FROM debian:bullseye

# RUN apt update && apt install -y redis-server && \
#     useradd -m redisuser && \
#     mkdir -p /var/run/redis && chown redisuser /var/run/redis

# COPY tools/redis.conf /etc/redis/redis.conf
# COPY tools/docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# USER redisuser
# EXPOSE 6379
# ENTRYPOINT ["docker-entrypoint.sh"]


FROM debian:bullseye

RUN apt-get update && apt-get install -y redis

COPY ./conf/redis.conf /etc/redis/redis.conf
COPY ./tools/docker_entry.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
