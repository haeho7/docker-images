# Alist

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=alist \
  --network=host \
  --restart=unless-stopped \
  --memory=256M \
  --memory-swap=512M \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/alist:/opt/alist/data \
  -v /mnt/user/datas/alist:/mnt/data \
  xhofe/alist:v3.0.3
```
