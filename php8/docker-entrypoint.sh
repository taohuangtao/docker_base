#!/bin/bash
# 同时拉起 php-fpm 与 nginx：
#   php-fpm 以守护进程方式在后台运行
#   nginx 以 daemon off 前台运行并接管 PID 1（保证 docker stop 能正常停止容器）
# 用法：
#   docker run image                 → 启动 php-fpm + nginx（默认）
#   docker run image php -m          → 跳过服务直接执行命令（调试用）
set -e

if [ $# -gt 0 ]; then
    exec "$@"
fi

# php-fpm 的 pid / log 目录（默认配置写到 /opt/php-8.5/var 下）
mkdir -p /opt/php-8.5/var/run /opt/php-8.5/var/log

echo "[entrypoint] starting php-fpm ..."
/opt/php-8.5/sbin/php-fpm --daemonize

echo "[entrypoint] starting crond ..."
# cron 默认以守护进程方式运行；计划任务放 /etc/cron.d/（需 644 权限且含用户字段）
cron

echo "[entrypoint] starting nginx ..."
exec nginx -g 'daemon off;'
