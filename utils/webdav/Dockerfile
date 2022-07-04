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
FROM alpine
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk update \
  && apk add tzdata shadow \
  && apk add gosu --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
  && rm -rf /var/cache/apk/* \
  && groupadd -r webdav && useradd -r -g webdav webdav

COPY --from=builder /usr/local/bin/webdav /usr/local/bin/
COPY --chmod=644 etc/login.defs /etc/login.defs
COPY --chmod=644 webdav-data/config.yml /opt/
COPY --chmod=755 webdav.sh /usr/local/bin/

VOLUME ["/config", "/data"]

ENTRYPOINT ["webdav.sh"]
