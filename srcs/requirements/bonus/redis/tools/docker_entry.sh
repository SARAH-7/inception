#!/bin/sh

# Inject REDIS_PASSWORD into config
sed -i "s/^requirepass .*/requirepass ${REDIS_PASSWORD}/" /etc/redis/redis.conf

# Start Redis
exec redis-server /etc/redis/redis.conf
