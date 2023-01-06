#!/bin/bash
set -e

USER=mysql
GROUP=mysql
GROUPS=mysql,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-022}
CONFIG_FILE="/etc/mysql/conf.d/mariadb.cnf"

_get_time() {
  date '+%Y-%m-%d %T'
}

info() {
  local green='\e[0;32m'
  local clear='\e[0m'
  local time="$(_get_time)"
  printf "${green}[${time}] [INFO]: ${clear}%s\n" "$*"
}

warn() {
  local yellow='\e[1;33m'
  local clear='\e[0m'
  local time="$(_get_time)"
  printf "${yellow}[${time}] [WARN]: ${clear}%s\n" "$*" >&2
}

_is_exist_conf() {
  if [ ! -f "${CONFIG_FILE}" ]; then
    info "mariadb.cnf does not exist, copy mariadb.cnf"
    cp /opt/mariadb.cnf ${CONFIG_FILE}
  else
    warn "mariadb.cnf file already exists, skip copy"
fi
}

_setup_user_info() {
  usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/bash ${USER}
  groupmod -o -g ${PGID} ${GROUP}
  umask ${UMASK}
}

_setup_owne () {
  chown ${PUID}:${PGID} /etc/mysql/conf.d/*.cnf
}

start_mariadb() {
  _is_exist_conf
  _setup_user_info
  _setup_owne

  # call mariadb official startup script
  exec /usr/local/bin/docker-entrypoint.sh "$@"
}

start_mariadb "$@"
