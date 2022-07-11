# Webdav

- [x] Unraid & Normal

## Usage

```sh
docker run -d \
  --name=webdav \
  --network=bridge \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=000 \
  -e TZ=Asia/Shanghai \
  -e USERNAME=example \
  -e PASSWORD='example' \
  -p 8080:8080 \
  -v /mnt/user/appdata/webdav:/config \
  -v /mnt/user/datas/webdav:/data \
  # -v /mnt/user/appdata/webdav/config.yml:/etc/webdav/config.yml \
  # -v /etc/localtime:/etc/localtime:ro \
  haeho7/docker-images:webdav
```
