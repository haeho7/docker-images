# Nginx

- [x] Unraid & Normal

## docker for nginx official

```sh
  docker run -d \
  --name=nginx \
  --network=br0 \
  --ip=192.168.1.249 \
  --restart=unless-stopped \
  --memory=512M --memory-swap=1G \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v /mnt/user/appdata/nginx/conf.d:/etc/nginx/conf.d \
  -v /mnt/user/appdata/acme.sh:/cert \
  # -v /etc/localtime:/etc/localtime:ro \
  nginx:1.21.6-alpine
```


## docker for linuxserver

```sh
  docker run -d \
  --name=nginx \
  --network=br0 \
  --ip=192.168.1.249 \
  --restart=unless-stopped \
  --memory=512M --memory-swap=1G \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v /mnt/user/appdata/nginx/conf.d:/etc/nginx/conf.d \
  -v /mnt/user/appdata/acme.sh:/cert \
  # -v /etc/localtime:/etc/localtime:ro \
  lscr.io/linuxserver/nginx
```





