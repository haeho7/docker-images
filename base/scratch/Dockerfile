#
# Dockerfile for scratch base image
#

FROM haheo7/docker-images:alpine AS builder

FROM scratch
LABEL maintainer="haeho7 <i@demo.com>"

ENV TZ=Asia/Taipei
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
