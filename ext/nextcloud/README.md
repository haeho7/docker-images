# NextCloud

- [x] Unraid & Normal

## Usage

```sh
docker run -d \
  --name=nextcloud \
  --network=br0 \
  --ip=192.168.1.248 \
  --restart=unless-stopped \
  --memory=2G \
  --memory-swap=4G \
  --user=99:100 \
  -e MYSQL_HOST='192.168.1.250:3306' \
  -e MYSQL_DATABASE=nextcloud \
  -e MYSQL_USER=nextcloud \
  -e MYSQL_PASSWORD='example' \
  -e NEXTCLOUD_ADMIN_USER=example \
  -e NEXTCLOUD_ADMIN_PASSWORD='example' \
  -e NEXTCLOUD_TRUSTED_DOMAINS='192.168.1.248 nextcloud.aimoyu.cc nextcloud.local.aimoyu.cc' \
  -e PHP_MEMORY_LIMIT=1024M \
  -e PHP_UPLOAD_LIMIT=0 \
  -v /mnt/user/appdata/nextcloud:/var/www/html \
  -v /mnt/user/datas/nextcloud:/var/www/html/data \
  -v /etc/localtime:/etc/localtime:ro
  nextcloud:24.0.0-fpm-alpine
```


### NGINX Webroot
If you use nginx to proxy nextcloud, you need to mount the nextcloud working directory to the nginx container.

```sh
# nginx container
-v /mnt/user/appdata/nextcloud:/var/www/html \
```


### PHP Memory and Upload Limit
variables in `nextcloud.ini` configuration files

```sh
cat /usr/local/etc/php/conf.d/nextcloud.ini

memory_limit=${PHP_MEMORY_LIMIT}
upload_max_filesize=${PHP_UPLOAD_LIMIT}
post_max_size=${PHP_UPLOAD_LIMIT}
```


###  Database and Trusted Domains List
variables in `config.php` configuration files

```sh
cat /var/www/html/config/config.php
```


### Crontab
if nextcloud container is run with `--user` parameter,cron tasks may fail to execute.need custom scheduled tasks.

```sh
# nextcloud default cron configuration files.
cat /etc/crontabs/www-data 
*/5 * * * * php -f /var/www/html/cron.php
```

custom scheduled tasks: 

```sh
# Unraid use User Scripts plugin
docker exec -i --user=99:100 nextcloud php -f /var/www/html/cron.php
```


