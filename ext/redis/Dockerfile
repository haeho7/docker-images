#
# Dockerfile for redis
#

#
# Runtime stage
#
FROM redis:6.2.7-alpine
LABEL maintainer="haeho7 <i@demo.com>"
# See more: https://github.com/docker-library/redis/tree/master/6.2/alpine

RUN apk update \
  && apk add --no-cache tzdata shadow \
  && rm -rf /var/cache/apk/*

COPY redis-data/redis.conf /opt/
COPY --chmod=755 redis.sh /usr/local/bin/

ENTRYPOINT ["redis.sh"] 
CMD ["redis-server", "/data/redis.conf"]
