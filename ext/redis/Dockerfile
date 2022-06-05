#
# Dockerfile for redis
#

#
# Runtime stage
#
FROM redis:6.2.7-alpine
LABEL maintainer="haeho7 <i@aimoyu.cc>"
# See more: https://github.com/docker-library/redis/tree/master/6.2/alpine

RUN apk update \
  && apk add --no-cache tzdata \
  && rm -rf /var/cache/apk/*

COPY redis-data/redis.conf /tmp
CMD [ "sh","cp -a /tmp/redis.conf /data && redis-server","/data/redis.conf" ]
# CMD [ "redis-server", "/data/redis.conf" ]