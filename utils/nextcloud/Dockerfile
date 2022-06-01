FROM nextcloud:24.0.1-fpm-alpine

RUN apk update \
  && apk add --no-cache tzdata shadow ffmpeg imagemagick supervisor \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /var/log/supervisord \
  && mkdir -p /var/run/supervisord

COPY ./supervisor/supervisord.conf /

# ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]