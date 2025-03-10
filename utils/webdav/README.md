# Webdav

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=webdav \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e PUID=99 \
  -e PGID=100 \
  -e USERNAME=example \
  -e PASSWORD='example' \
  -v /mnt/user/appdata/webdav/webdav-data:/config \
  -v /mnt/user/datas/webdav:/data \
  haeho7/docker-images:webdav
```
