# Movie Data Capture

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=mdc \
  --network=host \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/mdc:/config \
  -v /mnt/user/9kg/scan:/data \
  vergilgao/mdc:6.4.1-r0
```
