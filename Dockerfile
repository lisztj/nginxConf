FROM node:4.0-wheezy

MAINTAINER sino "sino@vip56.cn"

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.7.12-1~wheezy

RUN apt-get update && \
    apt-get install -y ca-certificates nginx && \
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /logs /var/log/nginx/access.log
RUN ln -sf /logs /var/log/nginx/error.log
# RUN rm -fv /usr/local/nginx/conf/nginx.conf
# COPY /conf/nginx.conf /usr/local/nginx/conf/nginx.conf
RUN ln -s /conf /etc/nginx/conf.d

EXPOSE 80
COPY /www/*  /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]