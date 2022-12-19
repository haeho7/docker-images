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

# call nextcloud official crontab script
if [ ! `pgrep -f "crond"` >/dev/null ]; then
  echo "crond process not runing, starting crond..."
  #nohup /cron.sh > /var/www/html/data/crond.log 2>&1 &
  /cron.sh > /dev/stdout 2>&1 &
else
  echo "crond process still running"
fi

# call nextcloud official startup script
exec /entrypoint.sh "$@"
