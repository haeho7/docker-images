#
# Dockerfile for nextcloud
#

#
# Build stage
#
FROM golang:alpine AS builder

ARG VERSION=1.14
RUN apk update \
  && apk add --no-cache --virtual .build-deps git gcc musl-dev \
  && git clone https://github.com/tianon/gosu --branch $VERSION \
  && cd gosu \
  && CGO_ENABLED=0 go build -trimpath -ldflags="-w -s" -v \
  && cp gosu /usr/local/bin/ \
  && cd .. \
  && rm -r gosu \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/*

#
# Runtime stage
#
FROM nextcloud:24.0.0-fpm-alpine
LABEL maintainer="haeho7 <i@aimoyu.cc>"

RUN apk update \
  && apk add --no-cache tzdata shadow ffmpeg imagemagick \
  && rm -rf /var/cache/apk/*

COPY --from=builder /usr/local/bin/gosu /usr/local/bin/

# ENV PUID=1000
# ENV PGID=1000

ENTRYPOINT ["nextcloud.sh"]