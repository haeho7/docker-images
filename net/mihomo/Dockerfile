#
# Dockerfile for Mihomo
#

#
# Build stage
#
FROM golang:1.25-alpine3.22 AS builder

ARG VERSION=v1.19.17
RUN apk update \
  && apk add --no-cache --virtual .build-deps git make gcc musl-dev \
  && git clone https://github.com/MetaCubeX/mihomo.git --branch $VERSION \
  && cd mihomo \
  && git checkout $VERSION \
  && rm -rf docker \
  && make docker \
  && install bin/mihomo-docker /usr/local/bin/mihomo \
  && cd - \
  && rm -r mihomo \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/*

#
# Runtime stage
#
FROM alpine:3.22
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk update \
  && apk add --no-cache iptables ip6tables iptables-legacy tzdata \
  && rm -rf /var/cache/apk/*

COPY --from=builder /usr/local/bin/mihomo /usr/local/bin/
COPY mihomo.sh /usr/local/bin/

ENV USE_IPTABLES_NFT_BACKEND=0

ENTRYPOINT ["mihomo.sh"]
CMD ["--help"]
