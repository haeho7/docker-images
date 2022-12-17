# ACME.sh

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=acme.sh \
  --network=host \
  --restart unless-stopped \
  --memory=256M \
  --memory-swap=512M \
  -e TZ=Asia/Shanghai \
  -e DP_Id='example' \
  -e DP_Key='example' \
  -v /mnt/user/appdata/acme.sh:/acme.sh \
  neilpang/acme.sh:3.0.5 daemon
```

## 证书申请

- `DNSPod.cn` 域变量为 `DP_Id` 和 `DP_Key`。参考: [@acme.sh/dnsapi#2-dnspodcn-option](https://github.com/acmesh-official/acme.sh/wiki/dnsapi#2-dnspodcn-option)
- `DNSPod.com` 域变量为 `DPI_Id` 和 `DPI_Key`。参考: [@acme.sh/dnsapi#48-use-dnspodcom-domain-api-to-automatically-issue-cert](https://github.com/acmesh-official/acme.sh/wiki/dnsapi#48-use-dnspodcom-domain-api-to-automatically-issue-cert)
- 容器外运行可能需要 `export` 相关变量
- 通过 ACME 申请的证书无法在 zerossl 控制面板吊销，可直接注销 zerossl 账号再注册。

```sh
# 切换默认提供商
docker exec -it acme.sh --set-default-ca --server letsencrypt / zerossl

# 申请
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 -d demo.com -d *.demo.com -k ec-256 -m example@gmail.com
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 -d local.demo.com -d *.local.demo.com -k ec-256 -m example@gmail.com

# 续期
docker exec -it acme.sh --renew -d demo.com -d *.demo.com --ecc --force
docker exec -it acme.sh --renew -d local.demo.com -d *.local.demo.com --ecc --force

# 吊销
docker exec -it acme.sh --remove -d demo.com --ecc
docker exec -it acme.sh --remove -d local.demo.com --ecc

# 查看证书列表
docker exec -it acme.sh acme.sh --list
```
