#!/bin/sh
set -e
T=alpine-latest
docker build -t hub.pengbei.tech:18080/bigdata/nginx:$T .
docker push     hub.pengbei.tech:18080/bigdata/nginx:$T