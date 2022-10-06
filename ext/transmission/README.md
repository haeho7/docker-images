# Transmission

- [x] Unraid & Normal

## docker for linuxserver

```sh
docker run -d \
  --name=transmission \
  --network=br0 \
  --ip=192.168.1.29 \
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
  -e WHITELIST='127.0.0.1,192.168.1.*' \
  -e HOST_WHITELIST='*.demo.com' \
  -e PEERPORT=51413 \
  #-p 9091:9091 \
  #-p 51413:51413 \
  #-p 51413:51413/udp \
  -v /mnt/user/appdata/transmission-data:/config \
  -v /mnt/user/torrent/:/downloads \
  -v /mnt/user/torrent/watch:/watch \
  linuxserver/transmission
```

## Use macvlan network

When creating a macvlan, if the device has a bridge device, `parent` needs to specify a bridge device instead of a physical interface, such as: `parent=br-lan` .

OpenWrt need install `kmod-macvlan` package and reboot.

See more: <https://forum.openwrt.org/t/solved-docker-macvlan-network/106478>

```sh
# create network
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  --aux-address="local-server=192.168.1.20" \
  -o parent=br0 \
  br0

# show network
docker network inspect br0
```

## BT or PT

```sh
# BT download enabled options, PT download needs to be off.
# Many PT stations default automatically mask dht and pex options.
dht-enabled
pex-enabled
lpd-enabled
```
