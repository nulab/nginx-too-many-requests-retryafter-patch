# Nginx patch to response "429 Too Many Requests" with "Retry-After" header

## Installation

```
tar zxfv nginx-1.12.0.tar.gz
cd nginx-1.12.0
patch -p1 < ../nginx-1.12.x-too-many-requests-retryafter.patch
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
$ docker build -t patched.nginx.1.12 . -f Dockerfile-1.12.x 
$ docker run -i -t -p 80:80 patched.nginx.1.12
$ ab -i -v 2 -n 2 -c 2 http://127.0.0.1/
...
LOG: header received:
HTTP/1.1 429 Too Many Requests
Server: nginx/1.12.0
Date: Tue, 25 Apr 2017 00:03:28 GMT
Content-Type: text/html
Content-Length: 185
Connection: close
Retry-After: 1
...
```
