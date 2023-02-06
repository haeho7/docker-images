# WebDAV-Client

## Usage

```sh
docker run -d \
  --name=webdav-cilnet \
  --network=host \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  --cap-add=SYS_ADMIN \
  --device=/dev/fuse \
  -e TZ=Asia/Shanghai \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e DAVFS2_ASK_AUTH=0 \
  -e WEBDRIVE_URL='http://locathost:5244/dav' \
  -e WEBDRIVE_USERNAME=example \
  -e WEBDRIVE_PASSWORD='example' \
  -v /mnt/user/appdata/webdav-cilnet:/mnt/webdrive:rshared \
  haeho7/docker-images:webdav-client
```

## Acknowledgments

- [@efrecon/docker-webdav-client](https://github.com/efrecon/docker-webdav-client)
