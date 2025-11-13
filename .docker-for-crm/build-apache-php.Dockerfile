#FROM progr000/php-5.6.40-apache
FROM progr000/php-5.3.29-base-libs

USER root

ARG branch
ENV GIT_BRANCH ${branch}

# Reinstall mysql libs to use mysqlnd driver
RUN rm /etc/php5/apache2/conf.d/docker-php-ext-mysql.ini \
    /etc/php5/apache2/conf.d/docker-php-ext-mysqli.ini \
    /etc/php5/apache2/conf.d/docker-php-ext-pdo_mysql.ini \
    /usr/local/lib/php/extensions/no-debug-non-zts-20090626/mysql.so \
    /usr/local/lib/php/extensions/no-debug-non-zts-20090626/mysqli.so \
    /usr/local/lib/php/extensions/no-debug-non-zts-20090626/pdo_mysql.so \
    \
    && docker-php-ext-configure mysql --with-mysql=mysqlnd \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install mysql mysqli pdo_mysql

RUN mkdir -p /var/run/mysqld && chown www-data:www-data /var/run/mysqld \
    && mkdir -p /srv/www/cgi-bin && chown www-data:www-data /srv/www/cgi-bin \
    && chown -R www-data:www-data /var/log \
    && mkdir -p /etc/php5/apache2 /home/www /usr/share/apache2-mod_security2 /usr/local/apache2 /etc/apache2

RUN apt update && apt install -y --fix-missing mc

COPY configs/php/php.ini /etc/php5/apache2/php.ini
COPY configs/apache/run.sh /run.sh
COPY configs/apache/etc_apache2/ /etc/apache2
COPY configs/apache/usr_sbin/apache2-systemd-ask-pass /usr/sbin/apache2-systemd-ask-pass
COPY configs/apache/usr_share_apache2-mod_security2/ /usr/share/apache2-mod_security2
COPY configs/apache/usr_local_apache2/ /usr/local/apache2
#COPY app/ /home/www

#USER www-data

CMD ["/run.sh"]
