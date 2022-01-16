FROM php:8.0-fpm

USER root

RUN echo 'deb http://mirrors.aliyun.com/debian/ bullseye main non-free contrib \n\
deb-src http://mirrors.aliyun.com/debian/ bullseye main non-free contrib \n\
deb http://mirrors.aliyun.com/debian-security/ bullseye-security main \n\
deb-src http://mirrors.aliyun.com/debian-security/ bullseye-security main \n\
deb http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib \n\
deb-src http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib \n\
deb http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib \n\
deb-src http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib' > /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN pecl install -f redis \
  && docker-php-ext-enable redis

RUN apt update \ 
  && apt install -y librdkafka-dev \
  && pecl install -f rdkafka \
  && docker-php-ext-enable rdkafka \
  && apt clean

RUN docker-php-ext-enable opcache

RUN docker-php-ext-install pdo_mysql



RUN apt update \
  && apt install -y vim \
  && apt clean




# RUN apt -y install autoconf
# RUN apt -y install gcc make openssl curl libbz2-dev libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev libzip-dev libssl-dev
# RUN apt -y install pkg-config
# RUN apt -y install libsqlite3-dev
# RUN apt -y install automake libtool
# RUN apt -y install librust-onig-dev
#RUN apt-get install -y libcurl4-openssl-dev libgd-dev libwebp-dev libpng++-dev libfreetype6-dev libghc-zlib-dev libmcrypt-dev libxml++2.6-dev libssl-dev libbz2-dev
# COPY php-8.1.0.tar.gz ./
# RUN tar -xvf php-8.1.0.tar.gz \
#   && cd php-8.1.0 \
#   && ./configure --enable-fpm --with-pdo-mysql \
#   && make \
#   && make install \
#   && cp php.ini-development /usr/local/php/php.ini \
#   && cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf \
#   && cp sapi/fpm/php-fpm /usr/local/bin

# RUN apt-get update && apt-get install -y \
#         libfreetype6-dev \
#         libjpeg62-turbo-dev \
#         libpng-dev \
#     && docker-php-ext-configure gd --with-freetype --with-jpeg \
#     && docker-php-ext-install -j$(nproc) gd
# 
# 
# 
# RUN pecl install redis-5.3.4 \
#     && pecl install xdebug-2.8.1 \
#     && docker-php-ext-enable redis xdebug
    
    
    
# RUN apt update \
#   && apt install -y php8.0-fpm \
#   && apt install -y php8.0-cli php8.0-gd php8.0-curl php8.0-mysql \
#   php8.0-ldap php8.0-zip php8.0-fileinfo php8.0-xml php8.0-common php8.0-mbstring \
#   php8.0-opcache php8.0-zip \
#   php-redis \
#   nginx \
#   && apt clean


# RUN apt update \
#     && apt install -y vim \
#     && apt install -y php-pear \
#     && apt install -y php-dev \
#     && apt install -y librdkafka-dev \
#     && pecl install rdkafka \
#     && echo 'extension=rdkafka.so' > /etc/php/8.0/cli/conf.d/kafka.ini && echo 'extension=rdkafka.so' > /etc/php/8.0/fpm/conf.d/kafka.ini \
#     && apt clean

# RUN echo '' > /etc/nginx/sites-enabled/default \
#   && sed -i 's/listen = \/run\/php\/php8.0-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/7.4/fpm/pool.d/www.conf \
#   && sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/8.0/fpm/pool.d/www.conf \
#   && sed -i "s/^error_reporting.*/error_reporting = E_ALL/g" /etc/php/7.4/fpm/php.ini \
#   && chmod 777 /var/log \
#   && sed -i 's/;error_log = php_errors.log/error_log = \/var\/log\/php_errors.log/g' /etc/php/8.0/fpm/php.ini


COPY composer.phar /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer


RUN groupadd -g 2001 web \
    && useradd  -g web  -u 2001 -r -m -s /bin/bash  web

RUN mkdir -p /data/project \
    && mkdir -p /data/storage \
    && chown web:web /data/project \
    && chown web:web /data/storage

WORKDIR /data/project

USER web

RUN composer config -g repos.packagist composer https://mirrors.cloud.tencent.com/composer/

EXPOSE 80

# CMD ["sh","-c","php-fpm8.0 \n nginx -g 'daemon off;'"]

# php 配置目录 /etc/php/7.4/fpm
# nginx 配置目录 /etc/nginx
# php 日志 /var/log/php_errors.log
# php 用户 www-data