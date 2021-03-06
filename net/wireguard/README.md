# WireGuard

- [x] Unraid & Normal

## Usage

```sh
docker run -d \
  --name=wireguard \
  --network=host \
  --restart=unless-stopped \
  --privileged=true \
  --memory=512M \
  --memory-swap=1G \
  -e USE_USERSPACE_MODE=0 \
  -e PEER_RESOLVE_INTERVAL=0 \
  -v /mnt/user/appdata/wireguard:/etc/wireguard \
  haeho7/docker-images:wireguard
```

## WireGuard-go

If your linux kernel is lower than 5.6, you can use `USE_USERSPACE_MODE`  switch to wireguard-go.

See more: <https://github.com/WireGuard/wireguard-go>

## DDNS Resolve

If the peer Endpoint is DDNS,you can use `PEER_RESOLVE_INTERVAL` to resolve periodically (in seconds).

Script source: <https://github.com/WireGuard/wireguard-tools/blob/master/contrib/reresolve-dns/reresolve-dns.sh>

## Generate Privatekey and Publickey

```conf
wg genkey | tee privatekey | wg pubkey > publickey && cat privatekey publickey
```

## Configs

```conf
#
# /etc/wireguard/wg-server.conf
#
[Interface]
PrivateKey = <SERVER_PRIVATE_KEY>
Address = 10.10.10.1/32
ListenPort = <SERVER_PORT>
#DNS = <REMOTE_DNS>
MTU = 1432
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT

[Peer]
PublicKey = <CLIENT_PUBLIC_KEY>
AllowedIPs = 10.10.10.2/32, 192.168.2.0/24
#Endpoint = <CLIENT_ADDR:CLIENT_PORT>
#PersistentKeepalive = 30

#
# /etc/wireguard/wg-client.conf
#
[Interface]
PrivateKey = <CLIENT_PRIVATE_KEY>
Address = 10.10.10.2/32
#ListenPort = <CLIENT_PORT>
#DNS = <REMOTE_DNS>
MTU = 1432
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT

[Peer]
PublicKey = <SERVER_PUBLIC_KEY>
AllowedIPs = 10.10.10.1/32, 192.168.1.0/24
Endpoint = <SERVER_ADDR:SERVER_PORT or SERVER_DOMAIN NAME:SERVER_PORT>
PersistentKeepalive = 30
```

## Quick Modify Peer

Modify peer configuration online without restarting the container.

```conf
wg set <WIREGUARD INTERFACE NAME> peer <PublicKey> allowed-ips '<AllowedIPs>'
```

## Best Practices

### MTU

The best MTU equals your external MTU minus `60 bytes (IPv4)` or `80 bytes (IPv6)`, e.g.:

```sh
#
# PPPoE MTU: 1492
#
# WireGuard MTU (IPv4): 1492 - 60 = 1432
MTU = 1432

# WireGuard MTU (IPv6): 1492 - 80 = 1412
MTU = 1412
```

See more: <https://lists.zx2c4.com/pipermail/wireguard/2017-December/002201.html>

### DNS (Unconfirmed)

DNS setting be only when as a client, and should be set to the DNS of remote peer, e.g.:

```sh
DNS = 192.168.1.254
```

### As Gateway

As a gateway, there may be MTU related issues, you can try appending the following iptables rules to `PostUp` and `PostDown`:
PC & other Clinet -> Router Device -> NodeA WireGuard tunnel???Gateway??? -> NodeB WireGuard tunnel

```sh
PostUp = iptables -t mangle -A POSTROUTING -o %i -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
PostDown = iptables -t mangle -D POSTROUTING -o %i -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
```

### Address Translation

??????NodeA??????WireGuard????????????NodeB????????????????????????NodeB????????????????????????NodeA?????????????????????????????????NodeB??????NodeA????????????????????????NodeB????????????????????????
NodeA -> WireGuard tunnel -> NodeB -> NodeB internal network (192.168.1.0/24)

```sh
# NodeB Add
PostUp = iptables -t nat -A POSTROUTING -o <INTERNAL INTERFACE NAME> -j SNAT --to-source 192.168.1.250
PostDown = iptables -t nat -D POSTROUTING -o <INTERNAL INTERFACE NAME> -j SNAT --to-source 192.168.1.250
```

??????WireGuard???????????????NodeA????????????????????????WireGuard????????????NodeB????????????????????????NodeB??? `AllowedIP` ???????????????NodeA???????????????????????????NodeA??????????????????????????????WireGuard???????????????
PC & Other Clinet -> Router Device -> NodeA WireGuard tunnel (Gateway) -> NodeB WireGuard tunnel -> NodeB Internal Network (192.168.2.0/24)

```sh
# NodeA Add
PostUp = iptables -t nat -A POSTROUTING -o <WIREGUARD INTERFACE NAME> -j SNAT --to-source 10.10.10.2
PostDown = iptables -t nat -D POSTROUTING -o <WIREGUARD INTERFACE NAME> -j SNAT --to-source 10.10.10.2
```
