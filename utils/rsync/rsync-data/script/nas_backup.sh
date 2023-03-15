#!/bin/bash
set -e
set -o pipefail

_get_time() {
  date '+%Y-%m-%d %T'
}

_get_status() {
  ps aux | grep -v grep | grep -v daemon | grep rsync | wc -l
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

daily_backup() {
  rsync --verbose \
    --dry-run \
    --progress \
    --partial \
    --archive \
    --sparse \
    --checksum \
    --hard-links \
    --xattrs \
    --exclude-from='/srv/script/nas-exclude-list' \
    --log-file=/srv/logs/daily_backup_"$(date +%Y%m%d_%H%M%S)".log \
    --log-file-format="[%i] %L [%B] [%U:%G] [%l bytes] %f (Trans: %b bytes)" \
    /mnt/user \
    /mnt/cache_backup/backup/nas_data_backup \
    #| tee /srv/logs/daily_backup_"$(date +%Y%m%d_%H%M%S)".log
}

monthly_backup() {
  rsync --verbose \
    --dry-run \
    --progress \
    --partial \
    --archive \
    --sparse \
    --checksum \
    --hard-links \
    --xattrs \
    --delete \
    --exclude-from='/srv/script/nas-exclude-list' \
    --log-file=/srv/logs/monthly_backup_"$(date +%Y%m%d_%H%M%S)".log \
    --log-file-format="[%i] %L [%B] [%U:%G] [%l bytes] %f (Trans: %b bytes)" \
    /mnt/user \
    /mnt/cache_backup/backup/nas_data_backup \
    #| tee /srv/logs/monthly_backup_"$(date +%Y%m%d_%H%M%S)".log
}

select_backup_mode() {
  if [ "$(date +%d)" == 01 ]; then
    monthly_backup && info "nas monthly backup complete." || error "nas monthly backup failed."
  else
    daily_backup && info "nas daily backup complete." || error "nas daily backup failed."
  fi
}

start_backup() {
  if [ "$(_get_status)" == 0 ]; then
    info "rsync backup starting..."
    select_backup_mode
  else
    warn "rsync process still running, skip backup."
  fi
}

start_backup
