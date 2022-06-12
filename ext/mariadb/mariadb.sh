#!/bin/sh
set -e

# set env
USER=mysql
GROUP=users
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -G ${USER} -s /bin/bash ${USER}

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# copy and chown mariadb.cnf
cp -a /tmp/mariadb.cnf /etc/mysql/conf.d
chown ${PUID}:${PGID} /etc/mysql/conf.d/mariadb.cnf
chmod 0644 /etc/mysql/conf.d/mariadb.cnf

# call mariadb official startup script
exec /usr/local/bin/docker-entrypoint.sh "$@"
