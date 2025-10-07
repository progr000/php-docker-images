#FROM progr000/php-5.6.40-apache
FROM progr000/php-5.3.29-base-libs

USER root

# Dev env additional packages
ARG APP_ENVIRONMENT
ENV APP_ENVIRONMENT=${APP_ENVIRONMENT}
RUN if [ "$APP_ENVIRONMENT" = "development" ]; \
    then apt-get update && apt-get install --fix-missing -y procps iputils-ping net-tools telnet nano mc aptitude; \
    fi

# Init www-data user
ARG APACHE_UID
ARG APACHE_GID
RUN userdel www-data \
    && groupdel www-data || true \
    && groupadd -g ${APACHE_GID} www-data \
    && useradd -M -g www-data -u ${APACHE_UID} -d /var/www -s /usr/sbin/nologin www-data \
    && chown -R www-data:www-data /var/cache/apache2 \
                                  /var/log/apache2 \
                                  /run/apache2 \
                                  /run/lock/apache2 \
                                  /var/lib/apache2 \
                                  /var/cache/modsecurity \
                                  /var/www/html

#RUN apt-get update && apt-get install --fix-missing -y iptables
RUN mkdir -p /var/run/mysqld && chown www-data:www-data /var/run/mysqld \
    && mkdir -p /srv/www/cgi-bin && chown www-data:www-data /srv/www/cgi-bin \
    && chown -R www-data:www-data /var/log \
    && chown -R www-data:www-data /var/www

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
      wget \
      msmtp \
      openssh-client \
    && ln -s /usr/local/bin/php /usr/bin/php \
    && ln -s /home/backup /backup


COPY cron/usr_local_bin/* /usr/local/bin
COPY cron/root-crontab.local /var/spool/cron/crontabs/www-data
RUN chown www-data:crontab /var/spool/cron/crontabs/www-data \
    && chmod 0600 /var/spool/cron/crontabs/www-data \
    && chmod gu+s /usr/sbin/cron \
    && chmod gu+s /usr/sbin/logrotate
    #&& chmod gu+rw /run

# uncomment this on real server
USER www-data

#
CMD ["/run.sh"]
