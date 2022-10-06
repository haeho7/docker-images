# AdGuard Home

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name=adguardhome \
  --network=host \
  --restart=unless-stopped \
  --memory=512M \
  --memory-swap=1G \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/adguardhome/conf:/opt/adguardhome/conf \
  -v /mnt/user/appdata/adguardhome/work:/opt/adguardhome/work \
  adguard/adguardhome:v0.107.15
```
