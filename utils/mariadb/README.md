# MariaDB

- [x] Unraid & Normal

## Usage

```sh
docker run -d \
  --name=mariadb \
  --network=host \
  --restart=unless-stopped \
  --memory=2G \
  --memory-swap=4G \
  -e PUID=99 \
  -e PGID=100 \
  -e TZ=Asia/Shanghai \
  -e MARIADB_ROOT_PASSWORD='example' \
  # -e MARIADB_DATABASE=example \
  # -e MARIADB_USER=example \
  # -e MARIADB_PASSWORD='example' \
  # -e MARIADB_ROOT_HOST='% localhost' \
  -v /mnt/user/appdata/mariadb/conf.d/:/etc/mysql/conf.d \
  -v /mnt/user/appdata/mariadb/data:/var/lib/mysql \
  haeho7/docker-images:mariadb
```

## Fix Permission

If the configuration file does not take effect, the configuration file repair permission is required.

```sh
chmod 0644 /mnt/user/appdata/mariadb/conf.d/mariadb.cnf
```

## Lower Case

Determines whether table names, table aliases, and database names are compared in a case-sensitive manner, and whether tablespace files are stored on disk in a case-sensitive manner.

```cnf
# linux default
lower_case_table_names = 0

# windows default
lower_case_table_names = 1
```

## Variables

```sql
show variables;
show global variables;
```

See more: [default-variables](./variables)

## Variables Tuning

```txt
https://blog.csdn.net/u014044812/article/details/78929579
https://segmentfault.com/a/1190000021408999
```
