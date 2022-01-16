#/bin/sh
# - 后面表示有更新，应该使用最新的
TAG=7.4-2
docker build -t taohuangtao/nginx-php:${TAG} .
docker push taohuangtao/nginx-php:${TAG}