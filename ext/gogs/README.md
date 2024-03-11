# Gogs

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=gogs \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e PUID=99 \
  -e PGID=100 \
  -v /mnt/user/appdata/gogs/gogs-data:/data \
  gogs/gogs:0.13
```
