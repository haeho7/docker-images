#!/bin/sh
set -e

USER=webdav
GROUP=webdav
GROUPS=webdav,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-022}
CONFIG_FILE="/config/config.yml"

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
    info "config.yml does not exist, copy config.yml"
    cp /opt/config.yml ${CONFIG_FILE}
  else
    warn "config.yml file already exists, skip copy"
  fi
}

_setup_user_info() {
  usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/ash ${USER}
  groupmod -o -g ${PGID} ${GROUP}
  umask ${UMASK}
}

_setup_owne () {
  chown ${PUID}:${PGID} /config/*.yml
  chown ${PUID}:${PGID} /data/
}

start_webdav() {
  _is_exist_conf
  _setup_user_info
  _setup_owne
  exec gosu ${PUID}:${PGID} webdav -c ${CONFIG_FILE} "$@"
  #exec gosu ${PUID}:${PGID} sh -c "umask ${UMASK} && webdav -c ${CONFIG_FILE}"
}

start_webdav "$@"
