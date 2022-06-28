FROM ubuntu:20.04

RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse \n\
' >  /etc/apt/sources.list

RUN apt update \
  && apt install -y php7.4-fpm \
  && apt install -y php7.4-cli php7.4-gd php7.4-curl php7.4-mysql \
  php7.4-ldap php7.4-zip php7.4-fileinfo php7.4-xml php7.4-common php7.4-mbstring \
  php7.4-opcache php7.4-zip \
  php-redis \
  nginx \
  && apt clean

RUN apt update \
    && apt install -y vim \
    && apt install -y php-pear \
    && apt install -y php-dev \
    && apt install -y librdkafka-dev \
    && pecl install rdkafka \
    && echo 'extension=rdkafka.so' > /etc/php/7.4/cli/conf.d/kafka.ini && echo 'extension=rdkafka.so' > /etc/php/7.4/fpm/conf.d/kafka.ini \
    && apt clean

RUN apt update \
  && apt install -y php7.4-gmp \
  && apt clean

RUN apt update \
    && apt install -y php-pear php-dev libmcrypt-dev \
    && pecl install mcrypt \
    && echo 'extension=mcrypt.so' >  /etc/php/7.4/cli/conf.d/mcrypt.ini && echo 'extension=mcrypt.so' >  /etc/php/7.4/fpm/conf.d/mcrypt.ini

RUN echo '' > /etc/nginx/sites-enabled/default \
  && sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' /etc/php/7.4/fpm/pool.d/www.conf \
  && sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/7.4/fpm/pool.d/www.conf \
  && sed -i 's/user = www-data/user = web/g' /etc/php/7.4/fpm/pool.d/www.conf \
  && sed -i 's/group = www-data/group = web/g' /etc/php/7.4/fpm/pool.d/www.conf \
  && sed -i 's/listen.owner = www-data/listen.owner = web/g' /etc/php/7.4/fpm/pool.d/www.conf \
  && sed -i 's/listen.group = www-data/listen.group = web/g' /etc/php/7.4/fpm/pool.d/www.conf \
  && chmod 777 /var/log \
  && sed -i 's/;error_log = php_errors.log/error_log = \/var\/log\/php_errors.log/g' /etc/php/7.4/fpm/php.ini

RUN sed -i "s/^error_reporting.*/error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT/g" /etc/php/7.4/fpm/php.ini

RUN groupadd -g 2001 web \
    && useradd  -g web  -u 2001 -r -m -s /bin/bash  web


EXPOSE 80

CMD ["sh","-c","php-fpm7.4 \n nginx -g 'daemon off;'"]

# php 配置目录 /etc/php/7.4/fpm
# nginx 配置目录 /etc/nginx
# php 日志 /var/log/php_errors.log
# php 用户 www-data
