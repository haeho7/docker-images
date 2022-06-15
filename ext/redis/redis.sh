#!/bin/sh
set -e

# set env
USER=redis
GROUP=redis
GROUPS=redis,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/ash ${USER} &>/dev/null

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# copy and chown redis.conf
if [ ! -f "/data/redis.conf" ]; then
  cp -a /opt/redis.conf /data/
fi
chmod 644 /data/redis.conf
chown ${PUID}:${PGID} /data/redis.conf

# call redis official startup script
exec /usr/local/bin/docker-entrypoint.sh "$@"
