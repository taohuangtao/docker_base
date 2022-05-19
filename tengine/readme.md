# 压缩镜像大小
/Users/huangtao/development/docker-slim/docker-slim build --http-probe=false tengine:latest
docker tag tengine.slim:latest hub.pengbei.tech:18080/bigdata/tengine.slim:latest
docker push hub.pengbei.tech:18080/bigdata/tengine.slim:latest