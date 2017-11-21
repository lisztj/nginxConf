FROM node:4.0-wheezy

MAINTAINER sino "sino@vip56.cn"

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

# ENV NGINX_VERSION 1.7.12-1~wheezy
ENV NGINX_VERSION 1.10.3
ENV OPENSSL_VERSION 1.0.2k
ENV PCRE_VERSION 8.40
ENV ZLIB_VERSION 1.2.11
ENV PURGE_VERSION 2.3
ENV BUILD_ROOT /usr/local/nginx
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak \
    && sed -i "s/archive\.ubuntu\.com/mirrors\.163\.com/g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install -f zip unzip curl make gcc g++ \
    && mkdir -p $BUILD_ROOT \
    && cd $BUILD_ROOT \
    && curl https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.zip -o $BUILD_ROOT/pcre-$PCRE_VERSION.zip \
    && curl https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz -o $BUILD_ROOT/openssl-$OPENSSL_VERSION.tar.gz \
    && curl http://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz -o $BUILD_ROOT/zlib-$ZLIB_VERSION.tar.gz \
    && curl http://labs.frickle.com/files/ngx_cache_purge-$PURGE_VERSION.tar.gz -o $BUILD_ROOT/ngx_cache_purge-$PURGE_VERSION.tar.gz \
    && curl https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o $BUILD_ROOT/nginx-$NGINX_VERSION.tar.gz \
    && tar zxvf nginx-$NGINX_VERSION.tar.gz \
    && unzip pcre-$PCRE_VERSION.zip \
    && tar zxvf zlib-$ZLIB_VERSION.tar.gz \
    && tar zxvf ngx_cache_purge-$PURGE_VERSION.tar.gz \
    && tar zxvf openssl-$OPENSSL_VERSION.tar.gz \
    && cd nginx-$NGINX_VERSION \
    && BUILD_CONFIG="\
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --with-openssl=$BUILD_ROOT/openssl-$OPENSSL_VERSION \
    --with-pcre=$BUILD_ROOT/pcre-$PCRE_VERSION \
    --with-zlib=$BUILD_ROOT/zlib-$ZLIB_VERSION \
    --with-http_ssl_module \
    --with-http_v2_module \ 
    --with-threads \
    --add-module=$BUILD_ROOT/ngx_cache_purge-$PURGE_VERSION \
    " \
    && mkdir -p /var/cache/nginx \
    && mkdir -p /usr/share/nginx/html/ \
    && ./configure $BUILD_CONFIG \
    && make && make install \
    && rm -rf $BUILD_ROOT \
    && apt-get -y remove zip unzip curl make gcc g++ \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && cp /etc/apt/sources.list.bak /etc/apt/sources.list \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# RUN apt-get update && \
#     apt-get install -y ca-certificates nginx && \
#     rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /var/cache/proxy_temp
# RUN mkdir -p /var/cache/proxy_cache

RUN ln -sf /logs /var/log/nginx/access.log
RUN ln -sf /logs /var/log/nginx/error.log

COPY /conf/nginx.conf /etc/nginx/nginx.conf
COPY /conf/default.conf /etc/nginx/conf.d/default.conf

# docker run --name nginxxx -i -t -v //c/Users/pablodocs/www/a-examplec:/www -d -p 80:80 nginxx
EXPOSE 80
COPY . /www/
WORKDIR /www

RUN cp -R /www/*  /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]