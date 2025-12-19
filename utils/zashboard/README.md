# Zashboard

## Usage

```sh
docker run -d \
  --name=zashboard \
  --restart=unless-stopped \
  --network=host \
  --log-opt=max-file=1 \
  --log-opt=max-size=20m \
  -e TZ=Asia/Taipei \
  -e ZASHBOARD_PORT=9091 \
  haeho7/docker-images:zashboard
```

## Upstream

- [@Zephyruso/zashboard](https://github.com/Zephyruso/zashboard)
