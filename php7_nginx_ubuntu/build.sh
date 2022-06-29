#/bin/sh
# - 后面表示有更新，应该使用最新的
V=7.4-3
L=7.4
docker build -t taohuangtao/nginx-php:${V} .
docker push     taohuangtao/nginx-php:${V}
docker tag      taohuangtao/nginx-php:${V} taohuangtao/nginx-php:$L
docker push     taohuangtao/nginx-php:$L