#FROM progr000/php-5.6.40-apache
FROM progr000/php-5.3.29-base-libs

USER root

# Dev env additional packages
ARG APP_ENVIRONMENT
ENV APP_ENVIRONMENT=${APP_ENVIRONMENT}
RUN if [ "$APP_ENVIRONMENT" = "development" ]; \
    then apt-get update && apt-get install --fix-missing -y procps iputils-ping net-tools telnet nano mc aptitude; \
    fi

#RUN apt-get update && apt-get install --fix-missing -y iptables
RUN mkdir -p /var/run/mysqld && chown www-data:www-data /var/run/mysqld \
    && mkdir -p /srv/www/cgi-bin && chown www-data:www-data /srv/www/cgi-bin \
    && chown -R www-data:www-data /var/log

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

# Cron tasks and all for this tasks
RUN apt-get update && apt-get install --fix-missing -y \
      cron \
      mysql-client \
      ntpdate \
      logrotate \
      xzdec \
      rsync \
    && ln -s /usr/local/bin/php /usr/bin/php

#USER www-data

CMD ["/run.sh"]
