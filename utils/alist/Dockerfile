#
# Dockerfile for alist
#

#
# Build stage
#
FROM golang:alpine AS builder

ARG VERSION=v3.7.2
RUN apk update \
  && apk add --no-cache --virtual .build-deps bash git gcc musl-dev curl \
  && git clone https://github.com/alist-org/alist.git --branch $VERSION \
  && cd alist \
  && bash build.sh release docker \
  && cp bin/alist /usr/local/bin/ \
  && cd - \
  && rm -r alist \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/*

#
# Runtime stage
#
FROM alpine:3.16
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk update \
  && apk add --no-cache tzdata shadow \
  && apk add --no-cache gosu --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
  && rm -rf /var/cache/apk/*

RUN groupadd -r alist \
  && useradd -r -g alist alist

COPY --from=builder /usr/local/bin/alist /usr/local/bin/
COPY alist.sh /usr/local/bin/

VOLUME /opt/alist/data
WORKDIR /opt/alist

EXPOSE 5244

ENTRYPOINT ["alist.sh"]
