# https://stackoverflow.com/questions/55508604/docker-is-exited-immediately-when-runs-with-error-code-139
#FROM php:5.6.40-apache
FROM php:5.6.40-fpm

RUN <<EOF
  echo "deb [trusted=yes] http://archive.debian.org/debian stretch main non-free contrib" > /etc/apt/sources.list
  echo "deb [trusted=yes] http://archive.debian.org/debian-security stretch/updates main non-free contrib" >> /etc/apt/sources.list
  echo "deb-src [trusted=yes] http://archive.debian.org/debian stretch main non-free contrib" >> /etc/apt/sources.list
EOF

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions \
    intl \
    mbstring \
    gettext \
    fileinfo \
    geoip \
    curl \
    json \
    pspell \
    imagick \
    gd \
    gmp \
    bcmath \
    zip \
    iconv \
    mcrypt \
    mhash \
    mysqli mysql mysqlnd \
    pgsql \
    mssql \
    pdo pdo_mysql pdo_pgsql pdo_sqlite \
    odbc \
    interbase \
    ldap \
    radius \
    imap \
    memcached memcache \
    xsl  \
    xmlrpc  \
    xdebug  \
    tidy  \
    snmp  \
    recode  \
    enchant

RUN echo "<?php phpinfo(); ?>" > /var/www/html/info.php

#EXPOSE 80
#EXPOSE 443
EXPOSE 9000
