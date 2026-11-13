#
# Dockerfile for Mihomo
#

#
# Build stage
#
FROM golang:1.26-alpine3.24 AS builder

ARG VERSION=v1.19.34
RUN apk add --no-cache --virtual .build-deps git make gcc musl-dev \
  && git clone https://github.com/MetaCubeX/mihomo.git --branch $VERSION \
  && cd mihomo \
  && git checkout $VERSION \
  && rm -rf docker \
  && sed -i \
      '/^darwin-386:/i docker-v2:\n\tGOAMD64=v2 $(GOBUILD) -o $(BINDIR)/$(NAME)-$@\n' \
      Makefile \
  && make docker-v2 -j$(nproc) \
  && install bin/mihomo-docker-v2 /usr/local/bin/mihomo \
  && cd - \
  && rm -r mihomo \
  && apk del .build-deps

#
# Runtime stage
#
FROM haeho7/docker-images:alpine
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk add --no-cache iptables ip6tables iptables-legacy

COPY --from=builder /usr/local/bin/mihomo /usr/local/bin/
COPY mihomo.sh /usr/local/bin/

ENV USE_IPTABLES_NFT_BACKEND=0

ENTRYPOINT ["mihomo.sh"]
CMD ["--help"]
