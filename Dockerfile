FROM node:4.0-wheezy

MAINTAINER sino "sino@vip56.cn"

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.7.12-1~wheezy
# RUN yum install -y gcc make pcre-devel zlib-devel
# RUN ./configure --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf
# RUN make
# RUN make install
RUN apt-get update && \
    apt-get install -y ca-certificates nginx && \
    rm -rf /var/lib/apt/lists/*
    

RUN ln -sf /logs /var/log/nginx/access.log
RUN ln -sf /logs /var/log/nginx/error.log
# RUN rm -fv /usr/local/nginx/conf/nginx.conf

COPY /conf/nginx.conf /etc/nginx/nginx.conf
COPY /conf/default.conf /etc/nginx/conf.d/default.conf

# RUN ln -sf /conf /etc/nginx/nginx.conf
# docker run --name nginxxx -i -t -v //c/Users/pablodocs/www/a-examplec:/www -d -p 80:80 nginxx
EXPOSE 80
COPY /www/*  /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]