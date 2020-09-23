# Nginx patch to response "429 Too Many Requests" with "Retry-After" header

## Installation

```
tar zxfv nginx-1.61.1.tar.gz
cd nginx-1.61.1
patch -p1 < ../nginx-too-many-requests-retryafter.patch
./configure ...
```


## Example Configuration

```
limit_req_zone  $binary_remote_addr  zone=api:1m   rate=4r/s;

location = /429_API.html {
    internal;
    root html;
}

location /api {
    limit_req  zone=api;
    error_page 429 /429_API.html;
    :
}
```

## Run sample request using Docker

```
$ docker build -t patched.nginx . -f Dockerfile 
$ docker run -i -t -p 80:80 patched.nginx
$ ab -i -v 2 -n 2 -c 2 http://127.0.0.1/
...
LOG: header received:
HTTP/1.1 429 Too Many Requests
Server: nginx/1.16.1
Date: Tue, 08 Oct 2019 03:49:19 GMT
Content-Type: text/html
Content-Length: 169
Connection: close
Retry-After: 1
...
```

## Compatibility

The following versions of Nginx should work with this module:

Module version | Nginx version
--- | ---
1.2.0 | 1.16.x or higher
1.1.0 | 1.14.x or higher
1.0.0 | 1.13.x or earlier

