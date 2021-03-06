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
  -e TZ=Asia/Shanghai \
  -e MYSQL_HOST='192.168.1.250:3306' \
  -e MYSQL_DATABASE=nextcloud \
  -e MYSQL_USER=nextcloud \
  -e MYSQL_PASSWORD='example' \
  -e REDIS_HOST='192.168.1.250' \
  -e REDIS_HOST_PORT=6379 \
  -e REDIS_HOST_PASSWORD='example' \
  -e NEXTCLOUD_ADMIN_USER=example \
  -e NEXTCLOUD_ADMIN_PASSWORD='example' \
  -e NEXTCLOUD_TRUSTED_DOMAINS='192.168.1.248 nextcloud.demo.com nextcloud.local.demo.com' \
  -e PHP_MEMORY_LIMIT=1024M \
  -e PHP_UPLOAD_LIMIT=0 \
  -v /mnt/user/appdata/nextcloud:/var/www/html \
  -v /mnt/user/datas/nextcloud:/var/www/html/data \
  haeho7/docker-images:nextcloud-normal
```

### Ngnix Webroot

If you use nginx to proxy nextcloud, you need to mount the nextcloud working directory to the nginx container.

```sh
# nginx container add volumes
-v /mnt/user/appdata/nextcloud:/var/www/html \
```

### Redis

If you need to use a redis database, please create a [redis container](../redis/README.md) first. For redis parameters, please refer to [redis.conf](../redis/redis-data/redis.conf)

### Mariadb

If you need to use a mariadb database, please create a [mariadb container](../mariadb/README.md) first. For mariadb parameters, please refer to [mariadb.conf](../mariadb/mariadb-data/conf.d/mariadb.cnf)

Initialize the database used by the nextcloud container in mariadb.

```sql

CREATE DATABASE `nextcloud` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';

CREATE USER `nextcloud`@`%` IDENTIFIED BY 'example';

GRANT Alter, Alter Routine, Create, Create Routine, Create Temporary Tables, Create View, Delete, Drop, Event, Execute, Grant Option, Index, Insert, Lock Tables, References, Select, Show View, Trigger, Update ON `nextcloud`.* TO `nextcloud`@`%`;

FLUSH PRIVILEGES;
```

### PHP Memory and Upload Limit

variables in `nextcloud.ini` configuration files.

```ini
# cat /usr/local/etc/php/conf.d/nextcloud.ini

memory_limit=${PHP_MEMORY_LIMIT}
upload_max_filesize=${PHP_UPLOAD_LIMIT}
post_max_size=${PHP_UPLOAD_LIMIT}

# php temp directory (custom variables)
upload_tmp_dir=/var/www/html/temp
```

### Database and Trusted Domains List

variables in `config.php` configuration files

```sh
cat /var/www/html/config/config.php
```

### OPcache Default

```ini
# cat /usr/local/etc/php/conf.d/opcache-recommended.ini

opcache.enable=1
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=60
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

### APCu and Crontab

APCu is disabled by default on CLI which could cause issues with nextcloud???s cron jobs.  
See more: <https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/caching_configuration.html#id1>

```ini
# cat /usr/local/etc/php/conf.d # cat docker-php-ext-apcu.ini
extension=apcu
apc.enable_cli=1
```

### PHP OCC Command

See more: <https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/occ_command.html>

Find the path where occ is located in the container.

```sh
find / -iname "*occ*"

cd /var/www/html
./occ --version
```

``` sh
# display config
docker exec --user=99:100 nextcloud php /var/www/html/occ config:list
```

```sh
# display get single value 
docker exec --user=99:100 nextcloud php /var/www/html/occ config:system:get trusted_domains
```

``` sh
# display user list
docker exec --user=99:100 nextcloud php /var/www/html/occ user:list
```

```sh
# display user setting
docker exec --user=99:100 nextcloud php /var/www/html/occ user:setting <usernmae>
```

```sh
# display config and private
docker exec --user=99:100 nextcloud php /var/www/html/occ config:list --private
```

```sh
# scan user file
docker exec --user=99:100 nextcloud php /var/www/html/occ files:scan <usernmae1> <usernmae2>
```

```sh
# scan user file and limit the search path
docker exec --user=99:100 nextcloud php /var/www/html/occ files:scan --path="/<username>/files/Photos"
```

```sh
# scan all user file,show directories and files verbose 
docker exec --user=99:100 nextcloud php /var/www/html/occ files:scan --all --verbose
```

```sh
# clear users trashbin
docker exec --user=99:100 php /var/www/html/occ trashbin:cleanup <usernmae1> <usernmae2>
docker exec --user=99:100 php /var/www/html/occ trashbin:cleanup --all-users
```

```sh
# Not tested
# clean database tables not match files
docker exec --user=99:100 nextcloud php /var/www/html/occ files:cleanup
```

### Upload Chunk Size

For upload performance improvements in environments with high upload bandwidth, the server???s upload chunk size may be adjusted.Default is 10485760 (10 MiB).

```sh
# disable upload chunk size
docker exec --user=99:100 nextcloud php /var/www/html/occ config:app:set files max_chunk_size --value 0
```

### Extend Config

See more: <https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html>

```php
  // enable extra preview
  // preview video need install ffmpeg
  'enable_previews' => true,
  'enabledPreviewProviders' => [
    'OC\Preview\PNG',
    'OC\Preview\JPEG',
    'OC\Preview\GIF',
    'OC\Preview\BMP',
    'OC\Preview\XBitmap',
    'OC\Preview\PDF',
    'OC\Preview\TXT',
    'OC\Preview\MarkDown',
    'OC\Preview\OpenDocument',
    'OC\Preview\MSOfficeDoc',
    'OC\Preview\MSOffice2003',
    'OC\Preview\MSOffice2007',
    'OC\Preview\OpenDocument',
    'OC\Preview\Krita',
    'OC\Preview\MP3',
    'OC\Preview\Movie',
    'OC\Preview\MKV',
    'OC\Preview\MP4',
    'OC\Preview\AVI',
    'OC\Preview\HEIC',
  ],

  // filelocking defaul true
  'filelocking.enabled' => true,

  // cookie lifetime default 15 day
  'remember_login_cookie_lifetime' => 60*60*24*3,

  // session lifetime default 1 day
  'session_lifetime' => 60 * 60 * 24,

  // session keepalive default true
  'session_keepalive' => true,

  // force logout default false
  'auto_logout' => true,

  // auto scan files changes default 0
  'filesystem_check_changes' => 1,

  // file versions control default auto
  'versions_retention_obligation' => 'auto',

  // clear trashbin default auto(30 day)
  'trashbin_retention_obligation' => 'auto',

  // temp directory you need create and chown
  //'tempdirectory' => '/var/www/html/temp',

  // logfile
  'log_type' => 'file',
  'logfile' => '[datadirectory]/nextcloud.log',
  'loglevel' => 2,
  'logdateformat' => 'Y-m-d H:i:s',
  'logtimezone' => 'Asia/Shanghai',
```

### Error Fix

- WARNING: [pool www] server reached pm.max_children setting (5), consider raising it.

Please refer to the following parameters: [www.conf](./nextcloud-data/php-fpm.d/www.conf)

- Module php-imagick in this instance has no SVG support. For better compatibility it is recommended to install it.

```sh
docker exec -it -u root:root nextcloud sh
apk add --no-cache imagemagick
```

### PHP-FPM Tuning

If you need high performance, you can optimize the default PHP-FPM parameters.

Please refer to the following parameters: [www.conf](./nextcloud-data/php-fpm.d/www.conf)

```sh
# nextcloud container add volumes
-v /mnt/user/appdata/nextcloud/config/php-fpm.d/www.conf:/usr/local/etc/php-fpm.d/www.conf \
```

Tips: It is recommended to do it after the nextcloud container is initialized, otherwise it may cause initialization errors or other problems.

### PHP-FPM STATUS Monitoring

If you need to monitor the running status of php-fpm:

- Uncomment in the `www.conf` configuration file the `pm.status_path`

```conf
pm.status_path = /status
```

- nginx configuration add `location` ,it is recommended to enable it only on internal networks.

```conf
    # php-fpm running status monitoring
    location /status {
        fastcgi_index   index.php;
        fastcgi_pass    php-handler;
        include         fastcgi_params;
        fastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param   SCRIPT_NAME        $fastcgi_script_name;
    }    
```
