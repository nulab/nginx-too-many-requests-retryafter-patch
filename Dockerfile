FROM alpine:3.5

MAINTAINER Taichiro Yoshida "taichiro.yoshida@nulab-inc.com"
LABEL version=1.19.2
ENV NGINX_VERSION 1.19.2
STOPSIGNAL SIGQUIT
EXPOSE 80

RUN addgroup -S nginx \
&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
&& apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    curl \
    gnupg \
    libxslt-dev \
    gd-dev \
    geoip-dev \
&& curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
&& mkdir -p /usr/src \
&& tar -zxC /usr/src -f nginx.tar.gz \
&& rm nginx.tar.gz

COPY nginx-too-many-requests-retryafter.patch /usr/src/nginx-$NGINX_VERSION/nginx-too-many-requests-retryafter.patch
COPY nginx.conf /usr/src/nginx-$NGINX_VERSION/nginx.conf

CMD cd /usr/src/nginx-$NGINX_VERSION \
&& patch -p1 < /usr/src/nginx-$NGINX_VERSION/nginx-too-many-requests-retryafter.patch \
&& ./configure \
&& make install \
&& cp /usr/src/nginx-$NGINX_VERSION/nginx.conf /usr/local/nginx/conf/nginx.conf \
&& /usr/local/nginx/sbin/nginx -g "daemon off;"
