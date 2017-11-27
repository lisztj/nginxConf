# nginxConf
nginxconf

build: docker build -t imagesName . //最后的点是构建当前目录下

run： docker run -p 88:80 -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/conf/default.conf:/etc/nginx/conf.d/default.conf -d imagesName