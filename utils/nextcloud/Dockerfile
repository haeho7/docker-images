#
# Dockerfile for nextcloud
#

FROM nextcloud:24.0.7-fpm-alpine
LABEL maintainer="haeho7 <i@demo.com>"

# install nextcloud ext packages
RUN apk update \
  && apk add --no-cache tzdata shadow ffmpeg imagemagick samba-client \
  && rm -rf /var/cache/apk/*

ENV TEMP_FILE_DIR="/var/www/html/temp"

# add php temp directory
RUN mkdir /usr/src/nextcloud/temp \
  && sed -i '/post_max_size/a upload_tmp_dir=${TEMP_FILE_DIR}' /usr/local/etc/php/conf.d/nextcloud.ini

# If the startup error php: not found, you need copy the login.defs file to /etc.
# See more: https://github.com/haeho7/docker-images/blob/master/utils/nextcloud/etc/login.defs#L163-164
COPY --chmod=644 etc/login.defs /etc/login.defs
COPY --chmod=755 nextcloud.sh /usr/local/bin/
COPY --chmod=644 nextcloud-data/php-fpm.d/www.conf /usr/src/nextcloud/config/php-fpm.d/

ENTRYPOINT ["nextcloud.sh"]
CMD ["php-fpm"]
