#
# Dockerfile for nextcloud
#

#
# Runtime stage
#
FROM nextcloud:24.0.4-fpm-alpine
LABEL maintainer="haeho7 <i@demo.com>"

#
# install the PHP extensions we need
# See more: https://github.com/nextcloud/docker/blob/master/.examples/dockerfiles/full/fpm-alpine/Dockerfile
#
RUN apk update \
  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS autoconf samba-dev \
  && pecl install smbclient \
  && docker-php-ext-enable smbclient \
  && rm -r /tmp/pear \
  && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
   && apk add --virtual .nextcloud-phpext-rundeps $runDeps \
   && apk del .build-deps

#
# install nextcloud ext packages
#
RUN apk update \
  && apk add --no-cache tzdata shadow ffmpeg imagemagick samba-client \
  && rm -rf /var/cache/apk/*

ENV TEMP_FILE_DIR="/var/www/html/temp"

# add php temp directory
# See more: https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/big_file_upload_configuration.html?highlight=webdav#configuring-php
# https://github.com/nextcloud/docker/blob/c416385b7c97f7d5a385f0133fd4fb6cb31690db/24/fpm-alpine/Dockerfile#L95
RUN mkdir /usr/src/nextcloud/temp \
  && sed -i '/post_max_size/a upload_tmp_dir=${TEMP_FILE_DIR}' /usr/local/etc/php/conf.d/nextcloud.ini

# add env and replace rsync_options
# See more: https://github.com/nextcloud/docker/blob/00d88733d0d93d0abc628c7b18bc589181c34cbb/24/fpm-alpine/entrypoint.sh#L100
RUN sed -i '/set -eu/a USER=www-data\nGROUP=users' /entrypoint.sh \
  && sed -i 's/-rlDog --chown www-data:root/-rlDog --chown \${USER}:\${GROUP}/g' /entrypoint.sh

# If the startup error php: not found, you need copy the login.defs file to /etc.
# See more: https://github.com/haeho7/docker-images/blob/475d15c4564987c9a0150b39180df58dab96223f/ext/nextcloud/etc/login.defs#L163-L164
COPY --chmod=644 etc/login.defs /etc/login.defs
COPY --chmod=755 nextcloud.sh /usr/local/bin/
COPY --chmod=644 nextcloud-data/php-fpm.d/www.conf /usr/src/nextcloud/config/php-fpm.d/

ENTRYPOINT ["nextcloud.sh"]
CMD ["php-fpm"]
