# EmbyServer

- [x] Unraid & Normal

## Usage

```sh
  docker run -d \
  --name=embyserver \
  --network=br0 \
  --ip=192.168.1.247 \
  --restart=unless-stopped \
  --memory=2G \
  --memory-swap=4G \
  -e UID=99 \
  -e GID=100 \
  -e GIDLIST="100,18" \
  # -p 8096:8096 \
  # -p 8920:8920 \
  -v /mnt/user/medias/moive/:/data/movies \
  -v /mnt/user/medias/series/:/data/series \
  -v /etc/localtime:/etc/localtime:ro \
  haeho7/docker-images:embyserver-4.6.7.0
```

## Used

```sh
haeho7/docker-images:embyserver-4.6.7.0
```

## FAQs

### Browser play video error: No compatible streams are currently available. Please try again later or contact your system administrator for more information.

Most browsers do not support decoding of HEVC videos, so you need enable transcoding on emby.Select Advanced for transcoding type, and it is recommended to use only the Intel QuickSync decoder.

### cannot be scraped Metadata and posters

Modify the Media Library Movie Metadata Downloader to TheMovieDb, Movie Image Fetchers to TheMovieDb and FanArt.

See more: https://emby.media/community/
