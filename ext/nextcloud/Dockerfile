#
# Dockerfile for nextcloud
#

#
# Runtime stage
#
FROM nextcloud:24.0.1-fpm-alpine
LABEL maintainer="haeho7 <i@aimoyu.cc>"

# install nextcloud ext packages
RUN apk update \
  && apk add --no-cache tzdata ffmpeg \
  && rm -rf /var/cache/apk/* \
  && pecl install smbclient \
  && docker-php-ext-enable smbclient
