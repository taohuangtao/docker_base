# php7-nginx基础镜
基于多阶段构建，在保证功能和模块的情况下，尽量缩小镜像大小
## 支持模块(详细可以查看dockerfile文件)
- 1、redis
- 2、kafka

## nginx
nginx 配置文件/etc/nginx/nginx.conf
ningx 子域名配置目录/etc/nginx/http.d/

和框架集成，配置参考 VirtualHost.conf文件，修改后放入/etc/nginx/http.d/目录