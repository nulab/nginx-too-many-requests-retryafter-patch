# Nginx patch to response "429 Too Many Requests" with "Retry-After" header

## Installation

```
tar zxfv nginx-1.6.0.tar.gz
cd nginx-1.6.0
patch -p1 < ../nginx-1.6.x-too-many-requests-retryafter.patch
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
