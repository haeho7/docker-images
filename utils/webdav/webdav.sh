#!/bin/sh
set -e

# set env
USER=nobody
GROUP=users
GROUPS=nobody
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-000}

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -G ${GROUPS} -s /bin/ash ${USER} &>/dev/null

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>

#set folder's owne
chown $PUID:$PGID /etc/webdav
chown $PUID:$PGID /data

# if UMASK is not null set umask
if [ "x$UMASK" != "x" ]; then
    umask $UMASK
fi

exec su -s /bin/ash ${USER} -c umask $UMASK -c webdav "$@"
