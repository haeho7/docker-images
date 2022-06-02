#
# Dockerfile for nextcloud
#

#
# Runtime stage
#
FROM nextcloud:24.0.1-fpm-alpine
LABEL maintainer="haeho7 <i@aimoyu.cc>"

RUN apk update \
  && apk add --no-cache tzdata shadow ffmpeg imagemagick \
  && rm -rf /var/cache/apk/*

COPY --chmod=644 etc/login.defs /etc/login.defs
COPY --chmod=777 nextcloud.sh /usr/local/bin/

# ENV PUID=1000
# ENV PGID=1000

ENTRYPOINT ["nextcloud.sh"]