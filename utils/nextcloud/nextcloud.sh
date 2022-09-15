#!/bin/sh
set -e

# set env
USER=www-data
GROUP=www-data
GROUPS=www-data,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/ash ${USER} &>/dev/null

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# chown nextcloud folder
# See more: https://github.com/nextcloud/docker/blob/00d88733d0d93d0abc628c7b18bc589181c34cbb/24/fpm-alpine/Dockerfile#L100
# cd /var/www/html && ls -1 /var/www/html | grep -v data | xargs chown -R ${PUID}:${PGID}

# call nextcloud official crontab script
if [ ! `pgrep -f "crond"` >/dev/null ]; then
  echo "crond process not runing, starting crond..."
  nohup /cron.sh >/var/www/html/data/crond.log &
else
  echo "crond process still running"
fi

# call nextcloud official startup script
exec /entrypoint.sh "$@"
