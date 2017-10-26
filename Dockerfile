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
# COPY nginx.conf /usr/local/nginx/conf/nginx.conf
# RUN ln -sf /conf /usr/local/nginx-1.13.4/conf/nginx.conf
EXPOSE 80 443
# RUN cp -R /app/dist/*  /usr/share/nginx/html


CMD ["nginx", "-g", "daemon off;"]