#!/bin/sh
set -e

# set env
USER=redis
GROUP=users
GROUPS=redis
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -G ${GROUPS} -s /bin/ash ${USER} &>/dev/null

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# copy and chown redis.conf
cp -a /tmp/redis.conf /data
chmod 644 /data/redis.conf
chown ${PUID}:${PGID} /data/redis.conf

# call redis official startup script
exec /usr/local/bin/docker-entrypoint.sh "$@"
