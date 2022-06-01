FROM nextcloud:24.0.0-fpm-alpine

RUN apk update \
  && apk add --no-cache tzdata shadow ffmpeg imagemagick \
  && rm -rf /var/cache/apk/*