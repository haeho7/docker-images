#
# Dockerfile for zashboard
#

#
# Build stage
#
FROM node:26.13-alpine3.24 AS builder

ARG VERSION=v3.30.0
RUN apk add --no-cache --virtual .build-deps git \
  && git clone https://github.com/Zephyruso/zashboard.git --single-branch --branch $VERSION --depth 1 \
  && cd zashboard \
  && git checkout $VERSION \
  && npm install --global pnpm@latest \
  && pnpm install \
  && pnpm run build --outDir /srv/zashboard \
  && npm cache clean --force \
  && cd - \
  && rm -r zashboard \
  && apk del .build-deps

#
# Runtime stage
#
FROM caddy:2.11-alpine
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk add --no-cache tzdata

COPY --from=builder /srv/zashboard /srv/zashboard
COPY Caddyfile /etc/caddy
