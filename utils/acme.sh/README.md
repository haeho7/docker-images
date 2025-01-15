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
  -e CF_Zone_ID='example' \
  -e CF_Token='example' \
  -e DEPLOY_DOCKER_CONTAINER_LABEL: 'me.local.container.name=nginx' \
  -e DEPLOY_DOCKER_CONTAINER_RELOAD_CMD: 'nginx -s reload' \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /mnt/user/appdata/acme.sh/acme.sh-data:/acme.sh \
  haheo7/docker-images:acme.sh
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

## Acknowledgments

- [@pexcn/docker-images/acme.sh](https://github.com/pexcn/docker-images/tree/master/utils/acme.sh)
