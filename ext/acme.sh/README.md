# ACME.sh

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=acme.sh \
  --network=host \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -e DP_Id='example' \
  -e DP_Key='example' \
  -v /mnt/user/appdata/acme.sh/acme.sh-data:/acme.sh \
  neilpang/acme.sh:3.1.0 daemon
```

## Issue Certificate

### DNSPod.cn

The variable names for dnspod.cn domain are `DP_Id` and `DP_Key`

- [@acme.sh/dnsapi#2-dnspodcn-option](https://github.com/acmesh-official/acme.sh/wiki/dnsapi#2-dnspodcn-option)

### DNSPod.com

The variable names for dnspod.com domain are `DPI_Id` and `DPI_Key`

- [@acme.sh/dnsapi#48-use-dnspodcom-domain-api-to-automatically-issue-cert](https://github.com/acmesh-official/acme.sh/wiki/dnsapi#48-use-dnspodcom-domain-api-to-automatically-issue-cert)

```sh
# set-default-ca
docker exec -it acme.sh --set-default-ca --server letsencrypt / zerossl

# issue
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 --domain demo.com --domain *.demo.com --keylength ec-256 --email example@gmail.com
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 --domain local.demo.com --domain *.local.demo.com --keylength ec-256 --email example@gmail.com

# renew
docker exec -it acme.sh --renew --domain demo.com --domain *.demo.com --ecc --force
docker exec -it acme.sh --renew --domain local.demo.com --domain *.local.demo.com --ecc --force

# remove
docker exec -it acme.sh --remove --domain demo.com --ecc
docker exec -it acme.sh --remove --domain local.demo.com --ecc

# show list
docker exec -it acme.sh acme.sh --list
```

## Notes

The certificate obtained through the `ACME` container cannot be revoked in the `ZeroSSL` control panel, but the `ZeroSSL` account can be canceled and registered again.
