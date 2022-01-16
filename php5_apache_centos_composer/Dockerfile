FROM centos:7

# author huangtao tao_huangtao@qq.com
# php  包括 composer, 用于运行laravel-admin项目的基础镜像 
USER root

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
    && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo \
    && yum install -y httpd \
    && yum clean all

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum install -y yum-utils \
    && yum-config-manager --enable remi-php56 \
    && yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo \
    && yum install -y php-xml \
    && yum clean all


#RUN curl -sS https://getcomposer.org/installer | php \
#    && mv composer.phar /usr/local/bin/composer
COPY composer.phar /usr/local/bin/composer




EXPOSE 80
CMD [ "/usr/sbin/apachectl","-D","FOREGROUND" ]
