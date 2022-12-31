# Vaultwarden

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=vaultwarden \
  --network=host \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  #--user=99:100 \
  --env-file=/mnt/user/appdata/vaultwarden/config.env \
  -e TZ=Asia/Shanghai \
  -e ROCKET_ENV=production \
  -e ADMIN_TOKEN='example' \
  -v /mnt/user/appdata/vaultwarden:/data \
  vaultwarden/server:1.27.0-alpine
```
