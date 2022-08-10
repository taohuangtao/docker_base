FROM nginx:1.23.1-alpine


RUN addgroup -g 2001 -S web \
    && adduser web    -u 2001  -D -S -s /bin/bash -G web


RUN sed -i 's/user  nginx;/user  web;/g' /etc/nginx/nginx.conf