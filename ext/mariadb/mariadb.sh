#!/bin/sh
set -e

# set env
USER=mysql
GROUP=users
GROUPS=mysql
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -G ${GROUPS} -s /bin/bash ${USER} &>/dev/null

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# copy and chown mariadb.cnf
cp -a /tmp/mariadb.cnf /etc/mysql/conf.d/
chmod 644 /etc/mysql/conf.d/mariadb.cnf
chown ${PUID}:${PGID} /etc/mysql/conf.d/mariadb.cnf

# call mariadb official startup script
exec /usr/local/bin/docker-entrypoint.sh "$@"
