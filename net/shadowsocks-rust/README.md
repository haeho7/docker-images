# Shadowsocks-Rust

- [x] unRAID
- [x] Normal

## Usage

### Server

```sh
# server mode
docker run -d \
  --name=server-aes \
  --network=host \
  --restart=unless-stopped \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice server \
  #--user nobody \
  --server-addr 0.0.0.0:1962 \
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
  --name=ss-socks5 \
  --network=host \
  --restart=unless-stopped \
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  #--user nobody \
  --local-addr 0.0.0.0:1080 \
  --server-addr 11.22.33.44:1962 \
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
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  #--user nobody \
  --protocol http \
  --local-addr 127.0.0.1:1111 \
  --server-addr 11.22.33.44:1962 \
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
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  #--user nobody \
  --protocol tunnel \
  --local-addr 127.0.0.1:5300 \
  --forward-addr 8.8.8.8:53 \
  --server-addr 11.22.33.44:1962 \
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
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  #--user nobody \
  --protocol redir \
  --local-addr 0.0.0.0:1234 \
  --server-addr 11.22.33.44:1962 \
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
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  #--user nobody \
  --protocol redir \
  --local-addr 0.0.0.0:1234 \
  --server-addr 11.22.33.44:1962 \
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
  -e TZ=Asia/Shanghai \
  -e CHILLING_EFFECT=0 \
  pexcn/docker-images:shadowsocks-rust \
  ssservice local \
  #--user nobody \
  --protocol redir \
  --local-addr 0.0.0.0:1234 \
  --server-addr 11.22.33.44:1962 \
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
echo -n "freedom_not_free" | openssl base64

# 2022-blake3-aes-128-gcm
openssl rand -base64 16
Wdp04PRBEZwrQIQthGiDRQ==

# 2022-blake3-aes-256-gcm
openssl rand -base64 32
BoxEGUompLVr+DlixYJzFlIsSQAB0dC0f3U79PPbkAY=

# 2022-blake3-chacha8-poly1305, 2022-blake3-chacha20-poly1305
openssl rand -base64 32
BoxEGUompLVr+DlixYJzFlIsSQAB0dC0f3U79PPbkAY=
```

## Acknowledgments

- [@pexcn/docker-images/shadowsocks-rust](https://github.com/pexcn/docker-images/tree/master/net/shadowsocks-rust)
