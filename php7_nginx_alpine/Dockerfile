FROM php:7.4-fpm-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

RUN apk --update  --no-cache add zlib zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev autoconf gcc g++ make automake \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis \
    && apk --update --no-cache add librdkafka-dev \
    && pecl install rdkafka


FROM php:7.4-fpm-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/redis.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/
COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/rdkafka.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/
COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/

RUN apk --update  --no-cache add zlib zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev librdkafka-dev util-linux

RUN apk --update  --no-cache add nginx \
    && rm -f /etc/nginx/http.d/default.conf \
    && sed -i '/include \/etc\/nginx\/http.d\/\*\.conf\;/a\\    include fastcgi\.conf\;'   /etc/nginx/nginx.conf


RUN echo 'zend_extension=opcache.so' >> /usr/local/etc/php/conf.d/docker-php-ext-gd.ini \
    && echo 'extension=gd.so' > /usr/local/etc/php/conf.d/docker-php-ext-gd.ini \
    && echo 'extension=rdkafka.so' > /usr/local/etc/php/conf.d/docker-php-ext-rdkafka.ini \
    && echo 'extension=redis.so' > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini

RUN docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-enable pdo pdo_mysql mysqli 
RUN sed -i 's/^pm.max_children = 5/pm.max_children = 100/g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/user = www-data/user = web/g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/group = www-data/group = web/g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/listen.owner = www-data/listen.owner = web/g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/listen.group = www-data/listen.group = web/g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^daemonize = no/daemonize = yes/g' /usr/local/etc/php-fpm.d/zz-docker.conf \
    && sed -i "s/pm = static/pm = dynamic/g"  /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;clear_env = no/clear_env = no/g" /usr/local/etc/php-fpm.d/www.conf

COPY nginx.conf /etc/nginx/nginx.conf

COPY php.ini /usr/local/etc/php/php.ini

# 基础调整都在上面进行，否则会没有权限执行
RUN addgroup -g 2001 -S web \
    && adduser web    -u 2001  -D -S -s /bin/bash -G web



EXPOSE 80

CMD ["sh","-c","php-fpm \n nginx -g 'daemon off;'"]