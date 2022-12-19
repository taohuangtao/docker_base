FROM php:7.4-fpm-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

RUN apk --update  --no-cache add zlib zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev autoconf gcc g++ make automake \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis \
    && apk --update --no-cache add librdkafka-dev \
    && pecl install rdkafka

RUN apk --update  --no-cache add libmcrypt-dev \
    && pecl install mcrypt 


FROM hub.pengbei.tech:18080/base/tengine-php-fpm:7.4.29

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

RUN apk --update  --no-cache add zlib zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev librdkafka-dev util-linux

COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/redis.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20190902
COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/rdkafka.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20190902
COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/gd.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20190902
COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/mcrypt.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20190902

RUN echo 'extension=gd.so' >> /usr/local/php/etc/docker-php-ext.ini \
    && echo 'extension=rdkafka.so' >> /usr/local/php/etc/docker-php-ext.ini \
    && echo 'extension=redis.so' >> /usr/local/php/etc/docker-php-ext.ini \
    && echo 'extension=mcrypt.so' >> /usr/local/php/etc/docker-php-ext.ini