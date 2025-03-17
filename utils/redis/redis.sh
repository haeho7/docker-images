#!/bin/sh
set -e

USER=redis
GROUP=redis
GROUPS=redis,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-022}
CONFIG_FILE="/data/redis.conf"

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
    info "redis.conf does not exist, copy redis.conf"
    cp /opt/redis.conf ${CONFIG_FILE}
  else
    warn "redis.conf file already exists, skip copy"
  fi
}

_setup_user() {
  usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/ash ${USER}
  groupmod -o -g ${PGID} ${GROUP}
  umask ${UMASK}
}

_setup_owne() {
  chown ${PUID}:${PGID} /data/*.conf
}

start_redis() {
  _is_exist_conf
  _setup_user
  _setup_owne

  # call redis official startup script
  exec /usr/local/bin/docker-entrypoint.sh "$@"
}

start_redis "$@"
