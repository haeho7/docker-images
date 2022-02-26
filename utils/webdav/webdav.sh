#!/bin/sh
set -e

# set env
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-022}

# set user nobody to specified user id (non unique)
usermod -o -u "${PUID}" -g users -G nobody -s /bin/ash nobody

# set group users to specified group id (non unique)
groupmod -o -g "${PGID}" users &>/dev/null

#set folder's owne
chown $PUID:$PGID "/etc/webdav"
chown $PUID:$PGID "/data"

# set umask
if [ "x$UMASK" != "x" ]; then
    umask $UMASK
fi

exec su -s /bin/ash nobody -c webdav "$@"
