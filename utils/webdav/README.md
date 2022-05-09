# webdav

- [x] Unraid & Normal

## docker

```sh
docker run -d \
  --name=webdav \
  --restart=unless-stopped \
  --network=bridge \
  --memory=512M --memory-swap=1G \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=000 \
  -e TZ=Asia/Shanghai \
  -p 8080:8080/tcp \
  -v /mnt/user/appdata/webdav/config.yml:/etc/webdav/config.yml \
  -v /mnt/user/datas/webdav:/data \
  # -v /etc/localtime:/etc/localtime:ro \
  haeho7/docker-images:webdav
```
