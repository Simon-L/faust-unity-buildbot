# faust-unity-buildbot

Depends on openresty, requires, `lua-resty-template`: `sudo opm get bungle/lua-resty-template`.  

Please run ` export PATH=/usr/local/openresty/nginx/sbin:$PATH` first on Debian-based distros before starting this service.  

```
docker build -t faust2unity .
nginx -p $(pwd) -c conf/nginx.conf
```