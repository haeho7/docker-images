#!/bin/sh
set -e

# set env
USER=www-data
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-000}

# set user www-data to specified user id (non unique)
usermod -o -u "${PUID}" -g users -G ${USER} -s /bin/ash ${USER}

# set group users to specified group id (non unique)
groupmod -o -g "${PGID}" users &>/dev/null

#set folder's owne
# chown $PUID:$PGID "/etc/webdav"
# chown $PUID:$PGID "/data"

# if UMASK is not null set umask
if [ "x$UMASK" != "x" ]; then
    umask $UMASK
fi

# exec su -s /bin/ash www-data -c webdav "$@"
exec su -s /bin/ash ${USER} -c umask $UMASK -c /entrypoint.sh -c php-fpm "$@"

# exec gosu ${PUID}:${PGID} bash -c 'umask $UMASK' bash-c /entrypoint.sh "$@"
# exec gosu ${USER} /entrypoint.sh php-fpm "$@"
# exec /entrypoint.sh php-fpm "$@"