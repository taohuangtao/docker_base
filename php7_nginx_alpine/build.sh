#!/bin/sh
set -e
docker build -t hub.pengbei.tech:18080/bigdata/php:php7.4-nginx-kafka .
docker push hub.pengbei.tech:18080/bigdata/php:php7.4-nginx-kafka