#!/bin/sh
set -e
V=v2.2
L=v2.latest
docker build -t taohuangtao/php:php7.4-nginx-kafka-$V .
docker push     taohuangtao/php:php7.4-nginx-kafka-$V

docker tag      taohuangtao/php:php7.4-nginx-kafka-$V  taohuangtao/php:php7.4-nginx-kafka-$L
docker push     taohuangtao/php:php7.4-nginx-kafka-$L