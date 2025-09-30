#
# Dockerfile for redis
#

FROM redis:8.2.1-alpine
LABEL maintainer="haeho7 <i@demo.com>"
# See more: https://github.com/docker-library/redis/tree/master/7.0/alpine

RUN apk update \
  && apk add --no-cache tzdata shadow \
  && rm -rf /var/cache/apk/*

COPY redis-data/redis.conf /opt/
COPY redis.sh /usr/local/bin/

VOLUME /data
WORKDIR /data

EXPOSE 6379

ENTRYPOINT ["redis.sh"] 
CMD ["redis-server", "/data/redis.conf"]
