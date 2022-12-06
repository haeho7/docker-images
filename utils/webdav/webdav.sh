#!/bin/sh
set -e

# set env
USER=webdav
GROUP=webdav
GROUPS=webdav,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-000}
CONFIG_FILE="/config/config.yml"

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/ash ${USER} &>/dev/null

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# copy and chown config.yml
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "config.yml does not exist, copy config.yml"
  cp -a /opt/config.yml /config/
else
  echo "config.yml file already exists, skip copy"
fi

#set folder's owne
chmod 644 /config/*.yml
chown $PUID:$PGID /config/*.yml
chown $PUID:$PGID /data

# if UMASK is not null set umask
if [ "x$UMASK" != "x" ]; then
    umask $UMASK
fi

# exec su -s /bin/ash ${USER} -c umask $UMASK -c webdav "$@"
gosu ${USER} sh -c "umask ${UMASK} && webdav -c ${CONFIG_FILE}" "$@"
