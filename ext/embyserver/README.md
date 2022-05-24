# EmbyServer

- [x] Unraid & Normal

## docker

```sh
  docker run -d \
  --name=embyserver \
  --network=br0 \
  --ip=192.168.1.247 \
  --restart=unless-stopped \
  --memory=2G \
  --memory-swap=4G \
  -e TZ=Asia/Shanghai \
  -e UID=99 \
  -e GID=100 \
  -e GIDLIST=100 \
  -e UMASK=022 \
  # -p 8096:8096 \
  # -p 8920:8920 \
  -v /mnt/user/medias/moive/:/data/movies \
  -v /mnt/user/medias/series/:/data/tvshows \
  haeho7/docker-images:embyserver-4.6.7.0
```
