FROM nextcloud:24.0.0-fpm-alpine

ENV NEXTCLOUD_UPDATE=1

RUN mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install -y \
        supervisor \
        ffmpeg \
        libmagickwand-dev \
        libgmp3-dev \
        libc-client-dev \
        libkrb5-dev \
        smbclient \
        libsmbclient-dev \
        inotify-tools \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install bz2 gmp imap \
    && pecl install imagick smbclient \
    && docker-php-ext-enable imagick smbclient \
    && mkdir -p /var/log/supervisord \
    && mkdir -p /var/run/supervisord

COPY nextcloud-entrypoint.sh /
COPY ./supervisord.conf /

ENTRYPOINT ["/nextcloud-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/supervisord.conf"]