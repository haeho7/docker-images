#
# Dockerfile for transmission
#

FROM linuxserver/transmission:4.0.3
LABEL maintainer="haeho7 <i@demo.com>"

ARG TRANSMISSION_WEB_VERSION=v1.6.31
ARG DOWNLOAD_URL=https://github.com/transmission-web-control/transmission-web-control/releases/download/${TRANSMISSION_WEB_VERSION}/dist.tar.gz

RUN mkdir -p /transmission-web-control \
 && curl -sSL $DOWNLOAD_URL | tar zxv -C /transmission-web-control --strip-components 2
