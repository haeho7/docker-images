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

- [@acme.sh/wiki/dnsapi#dns_dp](https://github.com/acmesh-official/acme.sh/wiki/dnsapi#2-dnspodcn-option)

### CloudFlare

- [@acme.sh/wiki/dnsapi#dns_cf](https://github.com/acmesh-official/acme.sh/wiki/dnsapi#dns_cf)

```sh
# Single DNS zone
CF_Zone_ID= <DNS Zone ID>
CF_Token= <Token>

# Multiple DNS zone
CF_Account_ID= <Account ID>
CF_Token= <Token>
```

```sh
# set-default-ca
docker exec -it acme.sh --set-default-ca --server letsencrypt / zerossl

# issue dns_dp
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 --domain example.com --domain *.example.com --keylength ec-256 --email example@gmail.com
docker exec -it acme.sh --issue --dns dns_dp --dnssleep 30 --domain local.example.com --domain *.local.example.com --keylength ec-256 --email example@gmail.com

# issue cloudflare
docker exec -it acme.sh --issue --dns dns_cf --dnssleep 30 --domain example.com --domain *.example.com --keylength ec-256 --email example@gmail.com
docker exec -it acme.sh --issue --dns dns_cf --dnssleep 30 --domain local.example.com --domain *.local.example.com --keylength ec-256 --email example@gmail.com

# renew
docker exec -it acme.sh --renew --domain example.com --domain *.example.com --ecc --force
docker exec -it acme.sh --renew --domain local.example.com --domain *.local.example.com --ecc --force

# remove
docker exec -it acme.sh --remove --domain example.com --ecc
docker exec -it acme.sh --remove --domain local.example.com --ecc

# show list
docker exec -it acme.sh acme.sh --list
```

## Notes

The certificate obtained through the `ACME` container cannot be revoked in the `ZeroSSL` control panel, but the `ZeroSSL` account can be canceled and registered again.
