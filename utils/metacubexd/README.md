# MetacubeXD

## Usage

```sh
docker run -d \
  --name=metacubexd \
  --restart=unless-stopped \
  --network=host \
  --log-opt=max-file=1 \
  --log-opt=max-size=20m \
  -e TZ=Asia/Taipei \
  -e METACUBEXD_PORT=9091 \
  haeho7/docker-images:metacubexd
```

## Upstream

- [@MetaCubeX/metacubexd](https://github.com/MetaCubeX/metacubexd)
