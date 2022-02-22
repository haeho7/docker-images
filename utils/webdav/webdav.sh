#!/bin/sh
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}

# add PUID:PGID, ignore error
addgroup -g $PGID -S user-group 1>/dev/null || true
adduser -u $PUID -S user 1>/dev/null || true

chown $PUID:$PGID "/etc/webdav/"
chown $PUID:$PGID "/data"

# Set umask
if [ "x$PUMASK" != "x" ]; then
    umask $PUMASK
fi

exec "$@"
