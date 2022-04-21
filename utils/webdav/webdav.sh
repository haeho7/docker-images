#!/bin/sh
set -e

# set env
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-000}

# set user nobody to specified user id (non unique)
usermod -o -u "${PUID}" -g users -G nobody -s /bin/ash nobody

# set group users to specified group id (non unique)
groupmod -o -g "${PGID}" users &>/dev/null

#set folder's owne
chown $PUID:$PGID "/etc/webdav"
chown $PUID:$PGID "/data"

# if UMASK is not null set umask
if [ "x$UMASK" != "x" ]; then
    umask $UMASK
fi

# exec su -s /bin/ash nobody -c webdav "$@"
# exec su -s /bin/ash nobody -c umask $UMASK -c webdav "$@"
