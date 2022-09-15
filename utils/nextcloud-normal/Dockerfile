#
# Dockerfile for nextcloud
#

#
# Runtime stage
#
FROM nextcloud:24.0.4-fpm-alpine
LABEL maintainer="haeho7 <i@demo.com>"

#
# install the PHP extensions we need
# See more: https://github.com/nextcloud/docker/blob/master/.examples/dockerfiles/full/fpm-alpine/Dockerfile
#
RUN apk update \
  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS autoconf samba-dev \
  && pecl install smbclient \
  && docker-php-ext-enable smbclient \
  && rm -r /tmp/pear \
  && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
   && apk add --virtual .nextcloud-phpext-rundeps $runDeps \
   && apk del .build-deps

#
# install nextcloud ext packages
#
RUN apk update \
  && apk add --no-cache tzdata ffmpeg imagemagick samba-client \
  && rm -rf /var/cache/apk/*
