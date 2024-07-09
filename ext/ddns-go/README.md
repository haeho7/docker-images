# ddns-go

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=ddns-go \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/ddns-go/ddns-go-data:/root \
  jeessy/ddns-go:v6.6.0
```
