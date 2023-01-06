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
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -v /mnt/user/appdata/alist:/opt/alist/data \
  haeho7/docker-images:alist
```

## Admin info

```sh
docker exec -it alist alist admin
```

## Upstream

- [@alist-org/alist](https://github.com/alist-org/alist)
