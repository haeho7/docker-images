#!/bin/bash
set -e

#export path
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# set env
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-022}

# set user nobody to specified user id (non unique)
usermod -o -u "${PUID}" nobody &>/dev/null

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
