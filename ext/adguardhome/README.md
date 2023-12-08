# AdGuard Home

- [x] unRAID
- [x] OpenWrt
- [x] Normal

## Usage

```sh
docker run -d \
  --name=adguardhome \
  --network=host \
  --restart=unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/adguardhome/adguardhome-data/conf:/opt/adguardhome/conf \
  -v /mnt/user/appdata/adguardhome/adguardhome-data/work:/opt/adguardhome/work \
  adguard/adguardhome:v0.107.23
```
