#!/bin/sh
set -e
V=v2.2
docker build -t taohuangtao/php:php7.4-nginx-kafka-$V .
docker push taohuangtao/php:php7.4-nginx-kafka-$V