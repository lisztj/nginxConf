# nginxConf
nginxconf

build: docker build -t imagesName . //最后的点是构建当前目录下

run： docker run -p 88:80 -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/conf/default.conf:/etc/nginx/conf.d/default.conf -v $PWD/www:/usr/share/nginx/html -d imagesName //启动容器运行镜像并挂载相应目录

查看容器 docker ps -a

查看镜像 docker images

查看容器日志 docker logs 容器id

启动容器 docker start 容器id

重启容器 docker restart 容器id

查看容器或image底层信息 docker inspect 容器id或镜像id

进入容器 docker attach 容器id