# Redis

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=redis \
  --network=host \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  -e PUID=99 \
  -e PGID=100 \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/redis:/data \
  haeho7/docker-images:redis
```

### Redis Auth

Authentication is required to connect to redis. For the default password, refer to the configuration file: [redis.conf](./redis-data/redis.conf)

Modify the `requirepass` parameter in the configuration file, or creating the container add the `--requirepass password` extra parameter.

### Redis Tuning

If you need high performance, you can optimize the default redis parameters.

Please refer to the following parameters: [redis.conf](./redis-data/redis.conf)

### Redis Command

``` sh
# show all cinfig
CONFIG GET *
CONFIG GET requirepass
```

``` sh
# show all key
SELECT 0
KEYS *
```
