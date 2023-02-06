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
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -v /mnt/user/appdata/redis:/data \
  haeho7/docker-images:redis
```

### Redis Auth

Authentication is required to connect to redis. For the default password, refer to the configuration file: [redis.conf](./redis-data/redis.conf)

Modify the `requirepass` parameter in the configuration file, or creating the container add the `--requirepass password` extra parameter.

### Redis Optimize

If you need high performance, you can optimize the default redis parameters.

Please refer to the following parameters: [redis.conf](./redis-data/redis.conf)

### Redis Command

``` sh
# login
redis-cli -h 127.0.0.1 -p 6379 -a password

# show all cinfig
CONFIG GET *
CONFIG GET requirepass

# show all key
SELECT 0
KEYS *
```
