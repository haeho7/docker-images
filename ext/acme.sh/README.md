# ACME.sh

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=acme.sh \
  --restart unless-stopped \
  --network=host \
  --memory=256M \
  --memory-swap=512M \
  -e TZ=Asia/Shanghai \
  -e DP_Id=example \
  -e DP_Key='example' \
  -v /mnt/user/appdata/acme.sh:/acme.sh \
  neilpang/acme.sh:3.0.4 daemon
```

## 证书申请

```sh
#Tips :
  # DNSPod.cn 域变量为 DP_Id DP_Key
  # DNSPod.com 域变量为 DPI_Id DPI_Key
  # 容器外运行可能需要export 变量
  # 通过ACME申请的证书无法在zerossl控制面板吊销，可直接注销zerossl账号再注册。

# 申请
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 -d demo.com -d *.demo.com -k ec-256 -m example@gmail.com
docker exec -it acme.sh --issue --dns dns_he --dnssleep 30 -d local.demo.com -d *.local.demo.com -k ec-256 -m example@gmail.com

# 续期
docker exec -it acme.sh --renew -d demo.com -d *.demo.com --ecc --force
docker exec -it acme.sh --renew -d local.demo.com -d *.local.demo.com --ecc --force

# 吊销
docker exec -it acme.sh --remove -d demo.com --ecc
docker exec -it acme.sh --remove -d local.demo.com --ecc

# 切换默认提供商
docker exec -it acme.sh --set-default-ca --server letsencrypt / zerossl
```
