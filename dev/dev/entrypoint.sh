#!/usr/bin/env bash

. /usr/local/lib/function.sh

USER_NAME=vscode
GROUP_NAME=vscode
EXTRA_GROUP=users
PUID=${PUID:-1000}
PGID=${PGID:-1000}
UMASK=${UMASK:-022}
USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"

setup_user() {
  groupmod -o -g "$PGID" "$GROUP_NAME"
  usermod -o -u "$PUID" -g "$GROUP_NAME" -aG "$EXTRA_GROUP" -s /bin/bash "$USER_NAME"
  umask "$UMASK"
}

setup_owner() {
  chown "$PUID:$PGID" "$USER_HOME"
  find "$USER_HOME" -maxdepth 1 -type f -name '.*' -exec chown "$PUID:$PGID" {} +
}

setup_git_config() {
  local user=$(git config --global --get user.name)
  local email=$(git config --global --get user.email)
  if [[ -n "$GIT_USER" && "$GIT_USER" != "$user" ]]; then
    git config --global user.name "$GIT_USER"
    su $USER_NAME -c "git config --global user.name $GIT_USER"
    info "initialize git user to ${GIT_USER}."
  fi
  if [[ -n "$GIT_EMAIL" && "$GIT_EMAIL" != "$email" ]]; then
    git config --global user.email "$GIT_EMAIL"
    su $USER_NAME -c "git config --global user.email $GIT_EMAIL"
    info "initialize git email to ${GIT_EMAIL}."
  fi
}

setup_ssh_auth() {
  local conf=/etc/ssh/sshd_config.d/ssh_auth.conf
  local lines=()

  [ "$ENABLE_SSH_PASSWORD_AUTH" = 1 ] || return 0

  if [[ -z "$USER_PASSWORD" || -z "$ROOT_PASSWORD" ]]; then
    warn "empty password, skip."
    return 0
  fi

  # not re-initialize in the restart
  if [ -f "$conf" ]; then
    warn "ssh auth already initialized, skip on restart"
    return 0
  fi

  printf '%s:%s\n' "$USER_NAME" "$USER_PASSWORD" | chpasswd
  printf 'root:%s\n' "$ROOT_PASSWORD" | chpasswd
  info "initialize passwords for user and root"

  lines+=('PasswordAuthentication yes')

  if [ "$ENABLE_ROOT_PASSWORD_LOGIN" = 1 ]; then
    lines+=('PermitRootLogin yes')
    info "enable root password login."
  else
    lines+=('PermitRootLogin prohibit-password')
    info "disable root password login."
  fi

  printf '%s\n' "${lines[@]}" > "$conf"
  info "enable ssh password authentication."
}

setup_ssh_daemon() {
  [ "$ENABLE_SSHD" = 1 ] || return 0

  if [[ -n "$SSH_PORT" && "$SSH_PORT" != 22 ]]; then
    if [ ! -f /etc/ssh/sshd_config.d/ssh_port.conf ]; then
      echo "Port $SSH_PORT" > /etc/ssh/sshd_config.d/ssh_port.conf
      info "initialize ssh port to ${SSH_PORT}."
    fi
  fi

  if [ -f /root/.ssh/authorized_keys ]; then
    if [ ! -f ${USER_HOME}/.ssh/authorized_keys ]; then
      mkdir ${USER_HOME}/.ssh
      cp /root/.ssh/authorized_keys ${USER_HOME}/.ssh/authorized_keys
      chown -R ${USER_NAME}:${GROUP_NAME} ${USER_HOME}/.ssh
      chmod 700 ${USER_HOME}/.ssh && chmod 600 ${USER_HOME}/.ssh/authorized_keys
      info "initialize ssh authorized_keys file."
    fi
  fi

  info "$(service ssh start)"
}

graceful_stop() {
  warn "caught SIGTERM or SIGINT signal, graceful stopping..."

  [ "$ENABLE_SSHD" != 1 ] || info "$(service ssh stop)"

  info "container stopped."
  exit 0
}

start_container() {
  trap graceful_stop SIGTERM SIGINT

  # allow execute extra commands by arguments
  "$@"

  info "container started."
  sleep infinity &
  wait
}

setup_user
setup_owner
setup_git_config
setup_ssh_auth
setup_ssh_daemon
start_container "$@"
