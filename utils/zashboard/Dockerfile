#
# Dockerfile for zashboard
#

#
# Build stage
#
FROM node:25-alpine3.22 AS builder

ARG VERSION=v2.6.0
RUN apk update \
  && apk add --no-cache --virtual .build-deps git \
  && git clone https://github.com/Zephyruso/zashboard.git --single-branch --branch $VERSION --depth 1 \
  && cd zashboard \
  && git checkout $VERSION \
  && npm install --global pnpm@latest \
  && pnpm install \
  && pnpm run build --outDir /srv/zashboard \
  && npm cache clean --force \
  && cd - \
  && rm -r zashboard \
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

COPY --from=builder /srv/zashboard /srv/zashboard
COPY Caddyfile /etc/caddy
