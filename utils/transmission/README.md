# Transmission

- [x] unRAID
- [x] OpenWrt
- [x] Normal

## Usage

```sh
docker run -d \
  --name=transmission \
  --network=br0 \
  --ip=192.168.1.29 \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  --sysctl net.ipv6.conf.all.disable_ipv6=1 \
  -e TZ=Asia/Shanghai \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e USER=example \
  -e PASS='example' \
  -e TRANSMISSION_WEB_HOME='/transmission-web-control/' \
  -e WHITELIST='127.0.0.1,192.168.1.*' \
  -e HOST_WHITELIST='*.demo.com' \
  -e PEERPORT=51314 \
  -v /mnt/user/appdata/transmission/transmission-data:/config \
  -v /mnt/user/torrent:/downloads \
  -v /mnt/user/torrent/watch:/watch \
  haeho7/docker-images:transmission
```

## Use macvlan network

OpenWrt need install `kmod-macvlan` package.

See more: <https://forum.openwrt.org/t/solved-docker-macvlan-network/106478>

When creating a macvlan, if the bridge device, `parent` needs to specify a bridge device instead of a physical interface, such as: `parent=br-lan` .

```sh
# create network
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=br0 \
  br0

# show network
docker network ls
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
