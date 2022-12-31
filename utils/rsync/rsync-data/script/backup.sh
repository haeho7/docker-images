#!/bin/bash
set -e
set -o pipefail

_get_time() {
  date '+%Y-%m-%d %T'
}

_get_status() {
  ps aux | grep -v grep | grep -v daemon | grep -v "/srv/*" | grep rsync -wc
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

error() {
  local red='\e[0;31m'
  local clear='\e[0m'
  local time="$(_get_time)"
  printf "${red}[${time}] [ERROR]: ${clear}%s\n" "$*" >&2
}

nas_local_backup() {
  if [ "$(date +%d)" == 01 ]; then
    rsync --verbose \
      --dry-run \
      --progress \
      --partial \
      --archive \
      --checksum \
      --hard-links \
      --xattrs \
      --delete \
      --exclude-from='/srv/script/nas-exclude-list' \
      --log-file=/srv/logs/nas_data_backup_delete_"$(date +%Y%m%d_%H%M%S)".log \
      --log-file-format="[%i] %L [%B] [%U:%G] [%l bytes] %f (Trans: %b bytes)" \
      /mnt/user \
      /mnt/cache_backup/backup/nas_data_backup \
      #| tee /srv/logs/nas_data_backup_delete_"$(date +%Y%m%d_%H%M%S)".log
  else
    rsync --verbose \
      --dry-run \
      --progress \
      --partial \
      --archive \
      --checksum \
      --hard-links \
      --xattrs \
      --log-file=/srv/logs/nas_data_backup_"$(date +%Y%m%d_%H%M%S)".log \
      --log-file-format="[%i] %L [%B] [%U:%G] [%l bytes] %f (Trans: %b bytes)" \
      --exclude-from='/srv/script/nas-exclude-list' \
      /mnt/user \
      /mnt/cache_backup/backup/nas_data_backup \
      #| tee /srv/logs/nas_data_backup_"$(date +%Y%m%d_%H%M%S)".log
  fi
}

unraid_daemon_backup() {
  if [ "$(date +%d)" == 01 ]; then
    rsync --verbose \
      --dry-run \
      --progress \
      --partial \
      --archive \
      --checksum \
      --hard-links \
      --xattrs \
      --delete \
      --exclude-from='/srv/script/unraid-exclude-list' \
      --log-file=/srv/logs/unraid_data_backup_delete_"$(date +%Y%m%d_%H%M%S)".log \
      --log-file-format="[%i] %L [%B] [%U:%G] [%l bytes] %f (Trans: %b bytes)" \
      --password-file=<(cat /etc/rsyncd.secrets | cut -d ':' -f 2) \
      user1@192.168.1.10::unRAID \
      /mnt/cache_backup/backup/unraid_data_backup \
      #| tee /srv/logs/unraid_data_backup_delete_"$(date +%Y%m%d_%H%M%S)".log
  else
    rsync --verbose \
      --dry-run \
      --progress \
      --partial \
      --archive \
      --checksum \
      --hard-links \
      --xattrs \
      --exclude-from='/srv/script/unraid-exclude-list' \
      --log-file=/srv/logs/unraid_data_backup_"$(date +%Y%m%d_%H%M%S)".log \
      --log-file-format="[%i] %L [%B] [%U:%G] [%l bytes] %f (Trans: %b bytes)" \
      --password-file=<(cat /etc/rsyncd.secrets | cut -d ':' -f 2) \
      user1@192.168.1.10::unRAID \
      /mnt/cache_backup/backup/unraid_data_backup \
      #| tee /srv/logs/unraid_data_backup_"$(date +%Y%m%d_%H%M%S)".log
  fi
}

execute_all_backup() {
  if [ "$(_get_status)" == 0 ]; then
  #if ! pgrep -f "rsync --verbose" || ! pgrep -f "rsync://" > /dev/null; then
    info "rsync backup starting..."
    unraid_daemon_backup && info "rsync unraid daemon backup complete." || error "rsync unraid daemon backup failed."
    nas_local_backup && info "rsync nas local backup complete." || error "rsync nas local backup failed."
  else
    warn "rsync process still running, skip backup."
  fi
}

execute_all_backup
