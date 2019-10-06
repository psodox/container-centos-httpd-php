FROM centos:centos7
LABEL maintainer="Denny Brandes <d.brandes@pixel-pro.de>"

RUN yum -y update \
 && yum -y install \
                    epel-release \
                    httpd


RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && \
        yum-config-manager --enable remi-php73 \
    && \
        yum -y install \
            php73-php \
            php73-php-common \
            php73-php-devel \
            php73-php-pdo \
	        php73-php-intl \
	        php73-php-xml


RUN sed -i 's/;error_log = syslog/error_log = \/dev\/stderr/' /etc/opt/remi/php72/php.ini && \
    ln -sf /dev/stdout /var/log/httpd/access_log && \
    ln -sf /dev/stderr /var/log/httpd/error_log && \
    ln -sf /opt/remi/php73/root/usr/share/php /usr/share/php && \
    chmod -R g+w /opt/remi/php73/root/usr/share/php && \
    ln -sf /var/opt/remi/php73/lib/php /var/lib/php && \
    chmod -R g+w /var/www/html && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -f /etc/httpd/conf.d/{userdir.conf,welcome.conf} && \
    sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf


EXPOSE 8080
ENV HOME /var/www


CMD ["/usr/sbin/httpd", "-DFOREGROUND"]