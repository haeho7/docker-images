#!/bin/sh
set -e

# set env
USER=www-data
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# set user to specified user id (non unique)
usermod -o -u "${PUID}" -g users -G ${USER} -s /bin/ash ${USER}

# set group users to specified group id (non unique)
groupmod -o -g "${PGID}" users &>/dev/null

exec /entrypoint.sh php-fpm "$@"