# StrongSwan

- [x] unRAID
- [x] Normal

## Usage

```sh
docker run -d \
  --name strongswan \
  --network=host \
  --privileged=true \
  --restart unless-stopped \
  --log-opt max-file=1 \
  --log-opt max-size=20m \
  #-p 500:500/udp \
  #-p 4500:4500/udp \
  -e PSK='PreSharedKey' \
  -e USERS='user1:password1,user2:password2' \
  -e DEBUG=0 \
  pexcn/docker-images:strongswan
```

## Testing

```sh
iOS 16                   --> passed
Android 11               --> passed
Windows 10 Pro 1909      --> failed
```

## Reference

- [@hwdsl2/setup-ipsec-vpn](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-xauth.md)
