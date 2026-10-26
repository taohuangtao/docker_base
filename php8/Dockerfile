# # syntax=docker/dockerfile:1  —— 该指令需联网拉取 BuildKit 前端镜像，离线/受限网络环境下必须保持注释状态
###############################################################################
# PHP-FPM + Nginx 一体化镜像（基于内部公共基础镜像）
#
# 基础镜像 hub.pengbei.tech:18080/bigdata/php-base:8.5.12（见 Dockerfile.base）
#   = dhi.io/php:8-debian-dev + 阿里云源 + adm/www-data 修复 + php-fpm
#   已具备：apt / pecl / phpize / gcc / php-fpm / 国内源 / 系统用户修复
#
# 本 Dockerfile 只做两件事：
#   阶段1：pecl 编译 redis、rdkafka 扩展
#   阶段2：安装 nginx/vim/curl/procps 等系统软件，拷入扩展与启动脚本
#
# 背景知识：DHI 的 dhi.io/php:8-debian-fpm 运行时变体无 shell、无 apt、无
#   pecl、无编译器，RUN 指令无法执行，所以扩展编译必须在 dev/base 变体上做。
###############################################################################

ARG BASE_IMAGE=hub.pengbei.tech:18080/bigdata/php-base:8.5.12

###############################################################################
# 阶段 1：编译 PHP 扩展（redis、rdkafka）
###############################################################################
FROM ${BASE_IMAGE} AS builder

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# apt 全量走国内源加速（华为云镜像，实测 Packages 索引 9.6MB 仅需 ~2s；
# aliyun 源在当前网络下大文件索引频繁超时导致构建失败）：
#   1. 整文件覆写 debian.sources：仅 deb 类型（索引量减半）、指向华为云
#   2. 移除境外 dhi.io 软件源（境内访问慢且不稳定）
# PHP 本体已在基础镜像内，本阶段安装的包全部来自华为云 Debian 镜像
RUN printf '%s\n' \
        'Types: deb' \
        'URIs: http://mirrors.huaweicloud.com/debian' \
        'Suites: trixie trixie-updates' \
        'Components: main' \
        'Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp' \
        '' \
        'Types: deb' \
        'URIs: http://mirrors.huaweicloud.com/debian-security' \
        'Suites: trixie-security' \
        'Components: main' \
        'Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp' \
        > /etc/apt/sources.list.d/debian.sources \
    && rm -f /etc/apt/sources.list.d/dhi.sources

# rdkafka 扩展编译需要 librdkafka-dev 与 pkg-config
# GD 扩展编译需要 freetype（字体）/libpng（PNG）/libjpeg（JPG）/libwebp（WebP）的 dev 包
# Strict-Pinning=false + allow-downgrades：DHI 基础镜像的 zlib1g 等核心库是
# 自家补丁版（版本号高于 Debian 官方），而 -dev 包精确依赖官方版本号，
# trixie 新版 apt 求解器默认拒绝降级解决，需放宽精确版本锁；
# builder 是一次性编译环境，降级不影响最终镜像（运行时库在阶段 2 单独安装）
RUN apt-get update \
    && apt-get install -y --allow-downgrades -o APT::Solver::Strict-Pinning=false --no-install-recommends \
        librdkafka-dev \
        pkg-config \
        libfreetype-dev \
        libpng-dev \
        libjpeg-dev \
        libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# 编译扩展（base 自带 pecl / phpize / gcc，无官方镜像的 docker-php-ext-* 脚本）
RUN pecl install redis \
    && pecl install rdkafka

# 编译 PHP 自带的 mysqli / pdo_mysql / gd 扩展（源码随 base 镜像提供于
# /opt/php-8.5/src/ext/，基于内置 mysqlnd 驱动，无额外系统依赖；
# 这些扩展不在 pecl，不能用 pecl install，需 phpize 源码编译。
# gd 的 freetype/jpeg/webp 依赖已在上方 apt 安装）
RUN cd /opt/php-8.5/src/ext/mysqli \
    && phpize \
    && ./configure --with-mysqli=mysqlnd \
    && make -j"$(nproc)" && make install \
    && cd /opt/php-8.5/src/ext/pdo_mysql \
    && phpize \
    && ./configure --with-pdo-mysql=mysqlnd \
    && make -j"$(nproc)" && make install \
    && cd /opt/php-8.5/src/ext/gd \
    && phpize \
    && ./configure --enable-gd --with-freetype --with-jpeg --with-webp \
    && make -j"$(nproc)" && make install

# 把编译产物集中到固定目录，方便拷贝
RUN EXT_DIR="$(php-config --extension-dir)" \
    && mkdir -p /ext-out \
    && cp "${EXT_DIR}/redis.so" "${EXT_DIR}/rdkafka.so" \
          "${EXT_DIR}/mysqli.so" "${EXT_DIR}/pdo_mysql.so" \
          "${EXT_DIR}/gd.so" /ext-out/

###############################################################################
# 阶段 2：运行时镜像
###############################################################################
FROM ${BASE_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# apt 全量走国内源加速（同 builder 阶段：覆写为华为云源、移除境外 dhi.io 源）
RUN printf '%s\n' \
        'Types: deb' \
        'URIs: http://mirrors.huaweicloud.com/debian' \
        'Suites: trixie trixie-updates' \
        'Components: main' \
        'Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp' \
        '' \
        'Types: deb' \
        'URIs: http://mirrors.huaweicloud.com/debian-security' \
        'Suites: trixie-security' \
        'Components: main' \
        'Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp' \
        > /etc/apt/sources.list.d/debian.sources \
    && rm -f /etc/apt/sources.list.d/dhi.sources

# 系统软件：nginx / vim / curl / procps（ps、top 等，探活脚本常依赖）
#   cron         —— 定时任务服务（crond），计划任务放 /etc/cron.d/ 下
#   tzdata       —— 支持 TZ=Asia/Shanghai
#   librdkafka1  —— rdkafka 扩展的运行时动态库（只装运行库，不带头文件）
#   libfreetype6 / libpng16-16 / libjpeg62-turbo / libwebp7
#                —— gd 扩展的运行时动态库
# Strict-Pinning=false + allow-downgrades：DHI 基础镜像的 zlib1g/libtinfo6 等
# 核心库是自家补丁版（版本号高于 Debian 官方），部分运行时包精确依赖官方
# 版本号；这些库上游版本相同、ABI 兼容，放宽后降级不影响功能
RUN apt-get update \
    && apt-get install -y --allow-downgrades -o APT::Solver::Strict-Pinning=false --no-install-recommends \
        nginx \
        vim \
        curl \
        procps \
        cron \
        tzdata \
        librdkafka1 \
        libfreetype6 \
        libpng16-16 \
        libjpeg62-turbo \
        libwebp7 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 系统时区落地为 Asia/Shanghai（ENV TZ 只对读该变量的进程生效，
# /etc/localtime 才是 date/cron 等的兜底时区来源）
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装扩展 .so 与 ini 注册文件
# 注意：ini 扫描目录是 /opt/php-8.5/etc/php/conf.d（php -i 可确认），
#       不要写到官方镜像的 /usr/local/etc/php/conf.d
COPY --from=builder /ext-out/ /tmp/ext-out/
RUN EXT_DIR="$(php-config --extension-dir)" \
    && mkdir -p "${EXT_DIR}" /opt/php-8.5/etc/php/conf.d \
    && cp /tmp/ext-out/*.so "${EXT_DIR}/" \
    && echo "extension=redis.so"      > /opt/php-8.5/etc/php/conf.d/20-redis.ini \
    && echo "extension=mysqli.so"     > /opt/php-8.5/etc/php/conf.d/21-mysqli.ini \
    && echo "extension=pdo_mysql.so"  > /opt/php-8.5/etc/php/conf.d/22-pdo_mysql.ini \
    && echo "extension=gd.so"         > /opt/php-8.5/etc/php/conf.d/23-gd.ini \
    && echo "extension=rdkafka.so"    > /opt/php-8.5/etc/php/conf.d/30-rdkafka.ini \
    && rm -rf /tmp/ext-out

# PHP / php-fpm 参数覆盖（memory_limit、post_max_size、upload_max_filesize、
# pm、request_terminate_timeout、clear_env 等，文件内容见 php/ 目录）
COPY php/99-overrides.ini    /opt/php-8.5/etc/php/conf.d/99-overrides.ini
COPY php/zz-fpm-overrides.conf /opt/php-8.5/etc/php-fpm.d/zz-overrides.conf

# nginx 主配置：worker_processes 调整为 1（默认是 auto）
RUN sed -i 's/^worker_processes.*/worker_processes 1;/' /etc/nginx/nginx.conf

# 覆盖 nginx 默认站点配置（带 PHP FastCGI 支持）
COPY nginx/default.conf /etc/nginx/sites-available/default

# 启动脚本（拷入后强制去掉可能存在的 Windows CRLF，并赋执行权限）
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

ENV PATH="/opt/php-8.5/bin:/opt/php-8.5/sbin:${PATH}"

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
