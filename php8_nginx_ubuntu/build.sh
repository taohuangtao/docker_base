#/bin/sh
# - 后面表示有更新，应该使用最新的
TAG=8
docker build -t hub.pengbei.tech:18080/bigdata/nginx-php:${TAG} .
# docker push hub.pengbei.tech:18080/bigdata/nginx-php:${TAG}