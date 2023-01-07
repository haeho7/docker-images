#
# Dockerfile for webdav
#

#
# Build stage
#
FROM golang:alpine AS builder

ARG VERSION=v4.2.0
RUN apk update \
  && apk add --no-cache --virtual .build-deps git gcc musl-dev \
  && git clone https://github.com/hacdias/webdav.git --branch $VERSION \
  && cd webdav \
  && CGO_ENABLED=0 go build -trimpath -ldflags="-w -s" -v \
  && cp webdav /usr/local/bin/ \
  && cd .. \
  && rm -r webdav \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/*

#
# Runtime stage
#
FROM alpine:3.16
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk update \
  && apk add tzdata shadow \
  && apk add gosu --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
  && rm -rf /var/cache/apk/*

RUN groupadd -r webdav \
  && useradd -r -g webdav webdav

COPY --from=builder /usr/local/bin/webdav /usr/local/bin/
COPY webdav-data/config.yml /opt/
COPY webdav.sh /usr/local/bin/

VOLUME ["/config", "/data"]
WORKDIR /config

EXPOSE 8001

ENTRYPOINT ["webdav.sh"]
