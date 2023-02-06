# Shadowsocks-Rust

- [x] unRAID
- [x] OpenWrt
- [x] Normal

## Usage

`redir` mode does not support `--user nobody` to run.

### OpenWrt

When openwrt uses the `server` mode, the `/etc/resolv.conf` content of the container is empty, and the `--dns` parameter needs to be specified.

### Server

```sh
# server mode
docker run -d \
  --name=server-aes \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice server \
  --user nobody \
  --server-addr 0.0.0.0:1984 \
  --password password \
  --encrypt-method aes-128-gcm \
  --timeout 3600 \
  --udp-timeout 300 \
  --nofile 1048576 \
  --tcp-keep-alive 300 \
  --tcp-fast-open \
  --tcp-no-delay \
  -U
```

### Client

```sh
# socks5 mode
docker run -d \
  --name=sssocks5 \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  --user nobody \
  --local-addr 0.0.0.0:1080 \
  --server-addr 11.22.33.44:1984 \
  --password password \
  --encrypt-method aes-128-gcm \
  --timeout 3600 \
  --udp-timeout 300 \
  --nofile 1048576 \
  --tcp-keep-alive 300 \
  --tcp-fast-open \
  --tcp-no-delay \
  -U

# http mode
docker run -d \
  --name=sshttp \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  --user nobody \
  --protocol http \
  --local-addr 127.0.0.1:1111 \
  --server-addr 11.22.33.44:1984 \
  --password password \
  --encrypt-method aes-128-gcm \
  --timeout 3600 \
  --udp-timeout 300 \
  --nofile 1048576 \
  --tcp-keep-alive 300 \
  --tcp-fast-open \
  --tcp-no-delay

# tunnel mode
docker run -d \
  --name=sstunnel \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  --user nobody \
  --protocol tunnel \
  --local-addr 127.0.0.1:5300 \
  --forward-addr 8.8.8.8:53 \
  --server-addr 11.22.33.44:1984 \
  --password password \
  --encrypt-method aes-128-gcm \
  --timeout 3600 \
  --udp-timeout 300 \
  --nofile 1048576 \
  --tcp-keep-alive 300 \
  --tcp-fast-open \
  --tcp-no-delay \
  -U

# redir mode
docker run -d \
  --name=ssredir \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  --protocol redir \
  --local-addr 0.0.0.0:1234 \
  --server-addr 11.22.33.44:1984 \
  --password password \
  --encrypt-method aes-128-gcm \
  --timeout 3600 \
  --udp-timeout 300 \
  --nofile 1048576 \
  --tcp-keep-alive 300 \
  --tcp-fast-open \
  --tcp-no-delay \
  --tcp-redir tproxy \
  --udp-redir tproxy \
  -U

# redir tcp mode
docker run -d \
  --name=ssredir-tcp \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  --protocol redir \
  --local-addr 0.0.0.0:1234 \
  --server-addr 11.22.33.44:1984 \
  --password password \
  --encrypt-method aes-128-gcm \
  --timeout 3600 \
  --udp-timeout 300 \
  --nofile 1048576 \
  --tcp-keep-alive 300 \
  --tcp-fast-open \
  --tcp-no-delay \
  --tcp-redir tproxy

# redir udp mode
docker run -d \
  --name=ssredir-udp \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  --protocol redir \
  --local-addr 0.0.0.0:1234 \
  --server-addr 11.22.33.44:1984 \
  --password password \
  --encrypt-method aes-128-gcm \
  --timeout 3600 \
  --udp-timeout 300 \
  --nofile 1048576 \
  --tcp-keep-alive 300 \
  --tcp-fast-open \
  --tcp-no-delay \
  --udp-redir tproxy \
  -u
```

## Generate Keys

Different encryption methods require different password lengths.

- [@Shadowsocks-NET/shadowsocks-specs/2022-1-shadowsocks-2022-edition.md](https://github.com/Shadowsocks-NET/shadowsocks-specs/blob/main/2022-1-shadowsocks-2022-edition.md#21-psk)
- [@shadowsocks/shadowsocks-rust/issues/969](https://github.com/shadowsocks/shadowsocks-rust/issues/969)

```sh
# aes-128-gcm
any plaintext character

# 2022-blake3-aes-128-gcm
openssl rand -base64 16
Wdp04PRBEZwrQIQthGiDRQ==

# or 16-bit plaintext character generation, for example:
echo -n "freedom_not_free" | openssl base64
ZnJlZWRvbV9ub3RfZnJlZQ==

# 2022-blake3-aes-256-gcm
# or 32-bit plaintext character generation
openssl rand -base64 32
BoxEGUompLVr+DlixYJzFlIsSQAB0dC0f3U79PPbkAY=

# 2022-blake3-chacha8-poly1305, 2022-blake3-chacha20-poly1305
# or 32-bit plaintext character generation
openssl rand -base64 32
BoxEGUompLVr+DlixYJzFlIsSQAB0dC0f3U79PPbkAY=
```

## About MTU

If other UDP traffic needs to be forwarded through shadowsocks, such as `wireguard over shadowsocks tunnel mode`, you may need to adjust the `mtu` value of the upper layer application, otherwise the following error will be reported:

```sh
2023-01-18T00:54:22.385782018+08:00 DEBUG [1:140321351875360] [shadowsocks_service::local::net::udp::association] 127.0.0.1:46213 -> 192.168.99.251:1820 (proxied) sending 1440 bytes failed, error: Message too large (os error 90)
```

Reference:

- [@shadowsocks/shadowsocks-rust/issues/897](https://github.com/shadowsocks/shadowsocks-rust/issues/897)
- [@shadowsocks/shadowsocks-rust/commit/be518cedbb97462ca29651ddaf633cfed30e7000](https://github.com/shadowsocks/shadowsocks-rust/commit/be518cedbb97462ca29651ddaf633cfed30e7000)

## Acknowledgments

- [@pexcn/docker-images/shadowsocks-rust](https://github.com/pexcn/docker-images/tree/master/net/shadowsocks-rust)
