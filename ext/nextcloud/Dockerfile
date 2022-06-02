#
# Dockerfile for nextcloud
#

#
# Runtime stage
#
FROM nextcloud:24.0.1-fpm-alpine
LABEL maintainer="haeho7 <i@aimoyu.cc>"

RUN apk update \
  && apk add --no-cache tzdata ffmpeg imagemagick \
  && rm -rf /var/cache/apk/*
