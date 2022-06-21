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
  echo "redis.conf does not exist, copy redis.conf"
  cp -a /opt/redis.conf /data/
else
  echo "redis.conf file already exists, skip copy"
fi
chmod 644 /data/*.conf
chown ${PUID}:${PGID} /data/*.conf

# call redis official startup script
exec /usr/local/bin/docker-entrypoint.sh "$@"
