FROM nextcloud:24.0.1-fpm-alpine

RUN apk update \
  && apk add --no-cache tzdata shadow \
  && rm -rf /var/cache/apk/*
