#!/bin/sh

docker build -t php7.2-apache-composer .

docker tag php7.2-apache-composer registry.cn-hangzhou.aliyuncs.com/rmt/php7.2-apache-composer:v1.1
docker push registry.cn-hangzhou.aliyuncs.com/rmt/php7.2-apache-composer:v1.1
