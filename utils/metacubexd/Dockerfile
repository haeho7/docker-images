#
# Dockerfile for MetacubeXD
#

#
# Build stage
#
FROM node:25-alpine3.22 AS builder

ARG VERSION=v1.234.1
RUN apk update \
  && apk add --no-cache --virtual .build-deps git \
  && git clone https://github.com/MetaCubeX/metacubexd.git --single-branch --branch $VERSION --depth 1 \
  && cd metacubexd \
  && git checkout $VERSION \
  && npm install --global pnpm@latest \
  && pnpm install \
  && pnpm run generate \
  && cp -a .output/public /srv \
  && npm cache clean --force \
  && cd - \
  && rm -r metacubexd \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/*

#
# Runtime stage
#
FROM caddy:2.10.2-alpine
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk update \
  && apk add --no-cache tzdata \
  && rm -rf /var/cache/apk/*

COPY --from=builder /srv/public /srv/metacubexd
COPY Caddyfile /etc/caddy
