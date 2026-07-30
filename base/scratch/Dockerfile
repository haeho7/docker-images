#
# Dockerfile for scratch base image
#

FROM alpine:3.24 AS builder
LABEL maintainer="haeho7 <i@demo.com>"

RUN apk add --no-cache tzdata ca-certificates

FROM scratch
LABEL maintainer="haeho7 <i@demo.com>"

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
