#!/bin/sh
set -e

# set env
USER=redis
GROUP=users
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -G ${USER} -s /bin/ash ${USER}

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# copy and chown redis.conf
cp -a /tmp/redis.conf /data
chown ${PUID}:${PGID} /data/redis.conf

# call redis official startup script
exec /usr/local/bin/docker-entrypoint.sh "$@" 