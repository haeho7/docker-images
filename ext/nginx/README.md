# Nginx

- [x] unRAID
- [x] Normal

## docker for nginx official

```sh
docker run -d \
  --name=nginx \
  --network=host \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v /mnt/user/appdata/nginx/conf.d:/etc/nginx/conf.d \
  -v /mnt/user/appdata/acme.sh:/cert \
  nginx:1.23.1-alpine
```

## docker for linuxserver

```sh
docker run -d \
  --name=nginx \
  --network=host \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v /mnt/user/appdata/nginx/conf.d:/etc/nginx/conf.d \
  -v /mnt/user/appdata/acme.sh:/cert \
  linuxserver/nginx:latest
```

## Repair File Permissions

```sh
cd /mnt/user/appdata/nginx
find . -type f -iname "*.conf" -print -exec chmod 644 {} \;
```
