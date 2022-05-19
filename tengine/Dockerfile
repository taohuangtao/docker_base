FROM alpine:3.12.1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

RUN apk update \
    && apk add --no-cache autoconf gcc g++ make automake
RUN apk add --no-cache zlib zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev \
    && apk add --no-cache -U bash \
	&& apk add --no-cache -U tzdata \
	&& apk add --no-cache -U gd \
	&& apk add --no-cache -U su-exec

# COPY pcre-8.45.tar.gz /
# RUN tar xvf pcre-8.45.tar.gz

RUN apk add --no-cache geoip geoip-dev pcre \
    libxslt gd openssl-dev pcre-dev zlib-dev \
	build-base linux-headers libxslt-dev gd-dev \
	openssl-dev libstdc++ libgcc patch logrotate \
	supervisor inotify-tools

RUN addgroup -g 10001 -S web 2> /dev/null \
    && adduser web -u 10001 -D -H -S -s /sbin/nologin -G web 2> /dev/null

RUN wget http://tengine.taobao.org/download/tengine-2.3.3.tar.gz
RUN tar -xvf tengine-2.3.3.tar.gz
WORKDIR /tengine-2.3.3
RUN pwd \
    && ls \
    && ./configure \
	--prefix=/usr/local/tengine \
	--user=web \
	--group=web \
	--with-poll_module \
    --without-select_module \
	--with-threads \
	--with-http_v2_module \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-http_gzip_static_module \
	--with-http_flv_module \
	--with-http_mp4_module \
	--add-module=./modules/ngx_http_concat_module \
	--add-module=./modules/ngx_http_upstream_check_module \
	--with-http_realip_module \
	--with-http_image_filter_module 
RUN make
RUN make install

WORKDIR /



RUN rm -rf /var/cache/apk/* \
    && rm -rf /tengine-2.3.3 \
	&& rm -rf tengine-2.3.3.tar.gz


ENV TZ=Asia/Shanghai

RUN echo $TZ > /etc/timezone
# base image

# FROM alpine:3.12.1



# ENV TIME_ZONE=Asia/Shanghai
# COPY --from=0 /usr/local/nginx /usr/local/tengine
# COPY --from=0 /usr/local/nginx/sbin/nginx /usr/sbin/nginx
# # COPY tengine usr/local/tengine
# # COPY nginx /usr/sbin/nginx

# RUN set -x \
# 	&& echo "http://mirrors.aliyun.com/alpine/v3.12/main" > /etc/apk/repositories	\
# 	&& echo "http://mirrors.aliyun.com/alpine/v3.12/community" >> /etc/apk/repositories \
# 	&& apk update \
# 	&& apk upgrade \
# 	&& apk add --no-cache -U bash \
# 	&& apk add --no-cache -U tzdata \
# 	&& apk add --no-cache -U lua5.1 \
# 	&& apk add --no-cache -U luajit \
# 	&& apk add --no-cache -U gd \
# 	&& apk add --no-cache -U su-exec\
# 	&& rm -rR /var/cache/apk/* \
# 	&& cp /usr/share/zoneinfo/$TIME_ZONE /etc/localtime \
# 	&& echo $TIME_ZONE > /etc/timezone \
# 	&& addgroup -g 10001 -S web 2> /dev/null \
# 	&& adduser web -u 10001 -D -H -S -s /sbin/nologin -G web 2> /dev/null \
# 	&& mkdir -p /var/tmp/tengine/{proxy_temp,fastcgi_temp,uwsgi_temp,scgi_temp,proxy_temp_dir,client_body_temp} \
# 	&& mkdir -p /var/log/tengine \
# 	&& ln -sf /dev/stdout /var/log/tengine/access.log \
# 	&& ln -sf /dev/stderr /var/log/tengine/error.log \
# 	&& chmod 0755 -fR /usr/sbin/nginx

EXPOSE 80 443

CMD [ "sh","-c","/usr/local/tengine/sbin/nginx -g 'daemon off;'" ]