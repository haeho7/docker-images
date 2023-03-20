# MariaDB

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=mariadb \
  --network=host \
  --restart=unless-stopped \
  --memory=2G \
  --memory-swap=4G \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e MARIADB_ROOT_PASSWORD='example' \
  #-e MARIADB_DATABASE=example \
  #-e MARIADB_USER=example \
  #-e MARIADB_PASSWORD='example' \
  #-e MARIADB_ROOT_HOST='%' \
  -v /mnt/user/appdata/mariadb/conf.d/:/etc/mysql/conf.d \
  -v /mnt/user/appdata/mariadb/data:/var/lib/mysql \
  haeho7/docker-images:mariadb
```

## Fix Permission

If the configuration file does not take effect, you need to repair the configuration file permissions.

```sh
chmod 0644 /mnt/user/appdata/mariadb/conf.d/mariadb.cnf
```

## Case Sensitive

- [@mariadb.com/docs/server/system-variables](https://mariadb.com/docs/server/ref/mdb/system-variables/lower_case_table_names)

Determines whether table names, table aliases, and database names are compared in a case-sensitive manner, and whether tablespace files are stored on disk in a case-sensitive manner.

```cnf
# linux default
lower_case_table_names = 0

# windows default
lower_case_table_names = 1
```

## Variable

Default Variables per version: [default-variables](./variables)

```sql
show variables;
show global variables;
```

## Optimize

- [@csdn.net](https://blog.csdn.net/u014044812/article/details/78929579)
- [@segmentfault.com](https://segmentfault.com/a/1190000021408999)
