#!/bin/sh
set -e
docker build -t taohuangtao/php:php7.4-nginx-kafka-v2.1 .
docker push taohuangtao/php:php7.4-nginx-kafka-v2.1