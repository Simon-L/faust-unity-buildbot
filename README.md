# faust-unity-buildbot

Depends on openresty, please run ` export PATH=/usr/local/openresty/nginx/sbin:$PATH` first on Debian-based distros

```
docker build -t faust2unity .
nginx -p $(pwd) -c conf/nginx.conf
```