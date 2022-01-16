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

RUN apk --update  --no-cache add zlib zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev librdkafka-dev

RUN apk --update  --no-cache add nginx \
    && rm -f /etc/nginx/http.d/default.conf \
    && sed -i '/include \/etc\/nginx\/http.d\/\*\.conf\;/a\\    include fastcgi\.conf\;'   /etc/nginx/nginx.conf

COPY nginx.ini /etc/nginx/nginx.conf

COPY php.ini /usr/local/etc/php/php.ini

RUN echo 'zend_extension=opcache.so' >> /usr/local/etc/php/conf.d/docker-php-ext-gd.ini \
    && echo 'extension=gd.so' > /usr/local/etc/php/conf.d/docker-php-ext-gd.ini \
    && echo 'extension=rdkafka.so' > /usr/local/etc/php/conf.d/docker-php-ext-rdkafka.ini \
    && echo 'extension=redis.so' > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini



EXPOSE 80

CMD ["sh","-c","php-fpm7.4 \n nginx -g 'daemon off;'"]