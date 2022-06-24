# ACME.sh

- [x] Unraid & Normal

## docker

```sh
  docker run -d \
  --name=acme.sh \
  --restart unless-stopped \
  --network=host \
  --memory=256M \
  --memory-swap=512M \
  -e TZ=Asia/Shanghai \
  -e DP_Id=example \   #is DNSPod.cn api ID
  -e DP_Key=example \  #is DNSPod.cn api Key
  -v /mnt/user/appdata/acme.sh:/acme.sh \
  neilpang/acme.sh:3.0.2 daemon
```


## 证书申请

```sh
#Tips :
  # DNSPod.cn 域变量为 DP_Id DP_Key
  # DNSPod.com 域变量为 DPI_Id DPI_Key
  # 容器外运行可能需要export 变量
  # 通过ACME申请的证书无法在zerossl控制面板吊销，可直接注销zerossl账号再注册

# 申请
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 -d aimoyu.cc -d *.aimoyu.cc -k ec-256 -m example@gmail.com

# 续期
docker exec -it acme.sh --renew -d aimoyu.cc -d *.aimoyu.cc --ecc --force

# 吊销
docker exec -it acme.sh --remove -d aimoyu.cc --ecc

# 切换默认提供商
docker exec -it acme.sh --set-default-ca --server letsencrypt / zerossl
```
