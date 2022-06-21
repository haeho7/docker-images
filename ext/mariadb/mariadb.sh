#!/bin/sh
set -e

# set env
USER=mysql
GROUP=mysql
GROUPS=mysql,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}
CONFIG_FILE="/etc/mysql/conf.d/mariadb.cnf"

# set user to specified user id (non unique)
usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/bash ${USER} &>/dev/null

# set group users to specified group id (non unique)
groupmod -o -g ${PGID} ${GROUP} &>/dev/null

# copy and chown mariadb.cnf
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "mariadb.cnf does not exist, copy mariadb.cnf"
  cp -a /opt/mariadb.cnf /etc/mysql/conf.d/
else
  echo "mariadb.cnf file already exists, skip copy"
fi
chmod 644 /etc/mysql/conf.d/*.cnf
chown ${PUID}:${PGID} /etc/mysql/conf.d/*.cnf

# call mariadb official startup script
exec /usr/local/bin/docker-entrypoint.sh "$@"
