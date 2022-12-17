# ddns-go

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=ddns-go \
  --network=host \
  --restart=unless-stopped \
  --memory=256M \
  --memory-swap=512M \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/ddns-go:/root \
  jeessy/ddns-go:v4.3.4
```
