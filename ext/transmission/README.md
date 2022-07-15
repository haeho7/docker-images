# Transmission

- [x] Unraid & Normal

## docker for linuxserver

```sh
  docker run -d \
  --name=transmission \
  --network=br0 \
  --ip=192.168.1.240 \
  --restart=unless-stopped \
  --memory=2G \
  --memory-swap=4G \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e TZ=Asia/Shanghai \
  -e TRANSMISSION_WEB_HOME=/transmission-web-control/ \
  -e USER=example \
  -e PASS='example' \
  -e WHITELIST='127.0.0.1,192.168.*.*' \
  -e HOST_WHITELIST='*.demo.com' \
  -e PEERPORT=51413 \
  # -p 9091:9091 \
  # -p 51413:51413 \
  # -p 51413:51413/udp \
  -v /mnt/user/appdata/transmission:/config \
  -v /mnt/user/torrent/:/downloads \
  -v /mnt/user/torrent/torrents_watch:/watch \
  linuxserver/transmission
```

## Settings Config

/mnt/user/appdata/transmission/settings.json

```json
{
    "alt-speed-down": 50,
    "alt-speed-enabled": false,
    "alt-speed-time-begin": 540,
    "alt-speed-time-day": 127,
    "alt-speed-time-enabled": false,
    "alt-speed-time-end": 1020,
    "alt-speed-up": 50,
    "bind-address-ipv4": "0.0.0.0",
    "bind-address-ipv6": "::",
    "blocklist-enabled": true,
    "blocklist-url": "https://github.com/Naunter/BT_BlockLists/releases/download/master/bt_blocklists.gz",
    "cache-size-mb": 128,
    "dht-enabled": false,
    "download-dir": "/downloads/complete",
    "download-queue-enabled": false,
    "download-queue-size": 5,
    "encryption": 2,
    "idle-seeding-limit": 30,
    "idle-seeding-limit-enabled": false,
    "incomplete-dir": "/downloads/incomplete",
    "incomplete-dir-enabled": false,
    "lpd-enabled": true,
    "message-level": 2,
    "peer-congestion-algorithm": "",
    "peer-id-ttl-hours": 6,
    "peer-limit-global": 2000,
    "peer-limit-per-torrent": 200,
    "peer-port": 51413,
    "peer-port-random-high": 65535,
    "peer-port-random-low": 49152,
    "peer-port-random-on-start": false,
    "peer-socket-tos": "default",
    "pex-enabled": false,
    "port-forwarding-enabled": true,
    "preallocation": 1,
    "prefetch-enabled": true,
    "queue-stalled-enabled": true,
    "queue-stalled-minutes": 30,
    "ratio-limit": 2,
    "ratio-limit-enabled": false,
    "rename-partial-files": true,
    "rpc-authentication-required": true,
    "rpc-bind-address": "0.0.0.0",
    "rpc-enabled": true,
    "rpc-host-whitelist": "*.demo.com",
    "rpc-host-whitelist-enabled": true,
    "rpc-password": "is encryption password",
    "rpc-port": 9091,
    "rpc-url": "/transmission/",
    "rpc-username": "example",
    "rpc-whitelist": "127.0.0.1,192.168.*.*,*",
    "rpc-whitelist-enabled": true,
    "scrape-paused-torrents-enabled": true,
    "script-torrent-done-enabled": false,
    "script-torrent-done-filename": "",
    "seed-queue-enabled": false,
    "seed-queue-size": 10,
    "speed-limit-down": 100,
    "speed-limit-down-enabled": false,
    "speed-limit-up": 100,
    "speed-limit-up-enabled": false,
    "start-added-torrents": true,
    "trash-original-torrent-files": false,
    "umask": 2,
    "upload-slots-per-torrent": 14,
    "utp-enabled": false,
    "watch-dir": "/watch",
    "watch-dir-enabled": true
}
```

## BT or PT

```sh
# BT download enabled options, PT download needs to be off.
# Many PT stations default automatically mask dht and pex options.
dht-enabled
pex-enabled
lpd-enabled
```
