#! /usr/bin/env sh
set -e

USER=alist
GROUP=alist
GROUPS=alist,users
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-022}

_set_user_info() {
  usermod -o -u ${PUID} -g ${GROUP} -aG ${GROUPS} -s /bin/ash ${USER}
  groupmod -o -g ${PGID} ${GROUP}
  umask ${UMASK}
}

start_alist() {
  _set_user_info
  chown -R ${PUID}:${PGID} /opt/alist/
  exec gosu ${PUID}:${PGID} alist server --no-prefix
  #exec gosu ${PUID}:${PGID} sh -c "umask ${UMASK} && alist server --no-prefix"
}

start_alist
