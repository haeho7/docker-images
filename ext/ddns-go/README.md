# ddns-go

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=ddns-go \
  --restart=unless-stopped \
  --network=host \
  --memory=256M \
  --memory-swap=512M \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/ddns-go:/root \
  jeessy/ddns-go:v4.1.1
```
