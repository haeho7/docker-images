# ddns-go

- [x] Unraid & Normal

## Usage

```sh
  docker run -d \
  --name=ddns-go \
  --restart=unless-stopped \
  --network=host \
  --memory=256M \
  --memory-swap=512M \
  -e TZ=Asia/Shanghai \
  # -p 9876:9876 \
  -v /mnt/user/appdata/ddns-go:/root \
  jeessy/ddns-go:v3.7.1
```
