# Mihomo

## OpenWrt

OpenWrt requires the installation of kernel modules corresponding to the operating mode.

- [@vernesong/OpenClash](https://github.com/vernesong/OpenClash#依赖)

```sh
# tun mode
ls -al /dev/net/tun
opkg update
opkg install kmod-tun

# tproxy mode
opkg install kmod-ipt-tproxy
opkg install iptables-mod-tproxy

# find process mode
opkg install kmod-inet-diag
```

## iptables Backend

If the host uses the `iptables-nft` backend, the `USE_IPTABLES_NFT_BACKEND` environment variable needs to be set.

```sh
# Debian 11 (bullseye)
iptables -V
iptables v1.8.7 (nf_tables)

ls -al /usr/sbin/iptables
lrwxrwxrwx 1 root root 26 12月 11 17:56 /usr/sbin/iptables -> /etc/alternatives/iptables
```

## Usage

```sh
# mihomo
docker run -d \
  --name=mihomo \
  --restart=unless-stopped \
  --network=host \
  --pid=host \
  --ipc=host \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun:/dev/net/tun \
  --log-opt=max-file=1 \
  --log-opt=max-size=20m \
  -e TZ=Asia/Taipei \
  -e USE_IPTABLES_NFT_BACKEND=0 \
  -v $(pwd)/mihomo-data:/etc/mihomo \
  haeho7/docker-images:mihomo \
  -d /etc/mihomo

# dashboard
docker run -d \
  --name=metacubexd \
  --restart=unless-stopped \
  --network=host \
  --log-opt=max-file=1 \
  --log-opt=max-size=20m \
  -e TZ=Asia/Taipei \
  -e METACUBEXD_PORT=9091 \
  haeho7/docker-images:metacubexd
```

## UDP2Raw and tinyfecVPN

When connecting to the proxy server through `UDP2Raw` and `tinyfecVPN` tunnels, the following settings are required:

- Add the `interface-name` parameter and specify the corresponding network interface to ensure the connection originates from that interface.
- Excluding VPS server public IP address from the routing table，otherwise, `UDP2Raw` will not be able to forward traffic.

```yml
proxies:
  - name: SS-SJC
    type: ss
    # tinyfecvpn server tunnle ip address
    server: 10.1.10.1
    port: 1984
    cipher: 2022-blake3-aes-128-gcm
    password: 
    # tinyfecvpn local tunnle interface name
    interface-name: tfvpn-sjc

tun:
  enable: true
  stack: system
  device: mihomo
  mtu: 1500
  gso: true
  gso-max-size: 65536
  udp-timeout: 300
  #strict-route: true
  auto-route: true
  auto-redirect: true
  auto-detect-interface: true
  endpoint-independent-nat: false
  # excluding VPS server public IP address
  route-exclude-address:
    - 11.22.33.44/32
```

## Wireguard

By default, tun mode routes all traffic to the tun interface.

If other virtual tunnels (such as Wireguard) exist on the device running mihomo, the corresponding subnet address need to be excluded to ensure that traffic is not routed.

```yml
tun:
  enable: true
  stack: system
  device: mihomo
  mtu: 1500
  gso: true
  gso-max-size: 65536
  udp-timeout: 300
  #strict-route: true
  auto-route: true
  auto-redirect: true
  auto-detect-interface: true
  endpoint-independent-nat: false
  # exclude reserved ip addresses
  route-exclude-address:
    - 10.0.0.0/8
    - 172.16.0.0/12
    - 192.0.0.0/24
```

## AdguardHome

DNS hijacking primarily targets requests made by clients when using external DNS servers, such as:

```sh
nslookup www.qq.com 223.5.5.5
Server: 223.5.5.5
Address: 223.5.5.5#53

www.qq.com canonical name = ins-r23tsuuf.ias.tencent-cloud.net.
Name: ins-r23tsuuf.ias.tencent-cloud.net
Address: 121.14.77.201
Name: ins-r23tsuuf.ias.tencent-cloud.net
Address: 121.14.77.221
```

```log
time="2025-11-27T01:09:16.564238001+08:00" level=debug msg="[DNS] hijack udp:198.18.0.2:53 from 192.168.1.122:53251"
time="2025-11-27T01:09:16.564797691+08:00" level=debug msg="[DNS] resolve www.qq.com A from https://doh.pub:443/dns-query"
time="2025-11-27T01:09:16.565286883+08:00" level=debug msg="[DNS] resolve www.qq.com A from https://223.5.5.5:443/dns-query"
time="2025-11-27T01:09:16.565682822+08:00" level=debug msg="[Rule] use default rules"
time="2025-11-27T01:09:16.565886188+08:00" level=debug msg="[TUN] Auto detect interface for 223.5.5.5 --> pppoe-wan"
time="2025-11-27T01:09:16.575578339+08:00" level=info msg="[TCP] mihomo --> 223.5.5.5:443 match GeoIP(cn) using CHINA[DIRECT]"
time="2025-11-27T01:09:16.577403353+08:00" level=debug msg="[DNS] www.qq.com --> [121.14.77.201 121.14.77.221] A from https://doh.pub:443/dns-query"
```

If used in conjunction with Adguard Home, mihomo does not need to hijack DNS.

- Redirect the dnsmasq port to AdguardHome using iptables.
- Set the upstream dns provider to mihomo DNS port in AdguardHome.

Note:

There are currently some issues with DNS hijacking parameters:

- Regardless of whether the external DNS protocol, IP address, and port match the DNS hijacking parameters (hijacking scope), requests will still be hijacked even if the hijacking parameters are commented out.

- When using a `mixed` stack, enabling the `gso` parameter prevents mihomo from sending received DNS responses back to the client. This could be a compatibility issue.

Reference:

- [@MetaCubeX/mihomo/issues/1689](https://github.com/MetaCubeX/mihomo/issues/1689)
- [@MetaCubeX/mihomo/issues/1632](https://github.com/MetaCubeX/mihomo/issues/1632)
- [MetaCubeX/mihomo/issues/1607](https://github.com/MetaCubeX/mihomo/issues/1607)

```yml
tun:
  enable: true
  stack: system
  device: mihomo
  mtu: 1500
  gso: true
  gso-max-size: 65536
  udp-timeout: 300
  #strict-route: true
  auto-route: true
  auto-redirect: true
  auto-detect-interface: true
  endpoint-independent-nat: false
  # don't hijack dns
  #dns-hijack:
  #  - udp://any:53
  #  - tcp://any:53
```

### ICMP

The tun mode currently does not support the routing ICMP protocol. When using the ICMP protocol, the following situations may occur.

- If the ICMP request originates from a local device running mihomo, the traffic will be captured by the tun interface regardless of whether the destination address exists or is reachable, as long as the `disable-icmp-forwarding: true` parameter is not configured, but no routing rules will be executed.

- If the ICMP request is sent by another device and passes through the mihomo gateway, regardless of whether the destination address exists or is reachable, ICMP will directly return "unreachable" because ICMP does not support routing to the tun interface.
  
Reference:

- [@MetaCubeX/mihomo/issues/1698](https://github.com/MetaCubeX/mihomo/issues/1698)
- [@nelvko/clash-for-linux-install/issues/66](https://github.com/nelvko/clash-for-linux-install/issues/66)

It is recommended to use tools such as `tcping`, `ssh`, and `curl` as alternatives.

Alternatively, can try enable the `strict-route` parameter, but currently enabling this parameter in OpenWrt will cause errors.

Reference:

- [@nelvko/clash-for-linux-install/issues/63](https://github.com/nelvko/clash-for-linux-install/issues/63)
- [@MetaCubeX/mihomo/issues/2341](https://github.com/MetaCubeX/mihomo/issues/2341)

### Hidden Environment Var

#### SAFE_PATHS

By default, mihomo only allows data to be stored in homeDir (/root/.config/mihomo). can modify homeDir at startup using `mihomo -d <YOU_PATH>`.

- [@metacubex.one/config/proxy-providers/#path]((https://wiki.metacubex.one/config/proxy-providers/?h=safe_paths#path))
- [@MetaCubeX/mihomo/v1.19.17/constant/path.go#L42](https://github.com/MetaCubeX/mihomo/blob/v1.19.17/constant/path.go#L42)

If the `-d` option is not specified at startup, and a directory other than homeDir is specified in the configuration file, the following error will occur:

```log
mihomo  | time="2025-11-28T01:58:55.162108437+08:00" level=info msg="Start initial configuration in progress"
mihomo  | time="2025-11-28T01:58:55.162983635+08:00" level=fatal msg="Parse config error: path is not subpath of home directory or SAFE_PATHS: /etc/mihomo/ui \n allowed paths: [/root/.config/mihomo]"
```

The `SAFE_PATHS` variable can be used to add additional directories to the safe path; multiple paths can be added.

```sh
    environment:
      TZ: Asia/Taipei
      SAFE_PATHS: '/etc/mihomo:/etc/mihomo2'
```

#### SKIP_SAFE_PATH_CHECK

This variable can directly disable secure path verification, and any path can be specified in the configuration file.

- [@MetaCubeX/mihomo/v1.19.10/docs/config.yaml](https://github.com/MetaCubeX/mihomo/blob/v1.19.10/docs/config.yaml)
- [@MetaCubeX/mihomo/v1.19.17/constant/path.go#L32](https://github.com/MetaCubeX/mihomo/blob/v1.19.17/constant/path.go#L32)

```sh
    environment:
      TZ: Asia/Taipei
      #SAFE_PATHS: '/etc/mihomo'
      SKIP_SAFE_PATH_CHECK: true
```

#### DISABLE_NFTABLES

mihomo uses the `nftables` firewall by default, this variable can be used to disable `nftables`.

- [@MetaCubeX/mihomo/issues/2052#issuecomment-2890338147](https://github.com/MetaCubeX/mihomo/issues/2052#issuecomment-2890338147)
- [@MetaCubeX/mihomo/v1.19.17/listener/sing_tun/server.go#L381](https://github.com/MetaCubeX/mihomo/blob/v1.19.17/listener/sing_tun/server.go#L381)

```sh
    environment:
      TZ: Asia/Taipei
      DISABLE_NFTABLES: true
```

## Upstream

- [@MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo/tree/Meta)
