# https://stackoverflow.com/questions/55508604/docker-is-exited-immediately-when-runs-with-error-code-139
FROM debian:wheezy

MAINTAINER Maksym <mhaivoronskyi@hoststar.ch>

RUN echo "deb [trusted=yes] http://archive.debian.org/debian wheezy main non-free contrib" > /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian wheezy main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security wheezy/updates main non-free contrib" >> /etc/apt/sources.list


# Packages
RUN apt-get update &&  apt-get install --fix-missing -y \
      apache2 \
      mysql-client \
      postgresql-client \
      libapache2-mod-php5 \
      php5 \
      php5-adodb \
      php5-cgi \
      php5-cli \
      php5-common \
      php5-curl \
      php5-dbg \
      php5-dev \
      php5-enchant \
      php5-exactimage \
      php5-ffmpeg \
      php5-fpm \
      php5-gd \
      php5-gdcm \
      php5-geoip \
      php5-gmp \
      php5-idn \
      php5-imagick \
      php5-imap \
      php5-interbase \
      php5-intl \
      php5-json \
      php5-lasso \
      php5-ldap \
      php5-librdf \
      php5-mapscript \
      php5-mcrypt \
      php5-memcache \
      php5-memcached \
      php5-mhash \
      php5-ming \
      php5-mssql \
      php5-mysql \
      #php5-mysqlnd \
      php5-odbc \
      php5-pgsql \
      php5-ps \
      php5-pspell \
      php5-radius \
      php5-recode \
      php5-remctl \
      php5-rrd \
      php5-sasl \
      php5-snmp \
      php5-sqlite \
      php5-svn \
      php5-sybase \
      php5-tidy \
      php5-tokyo-tyrant \
      php5-vtkgdcm \
      php5-xcache \
      php5-xdebug \
      php5-xmlrpc \
      php5-xsl \
      iputils-ping \
      net-tools \
      telnet \
      mc

COPY apache/bin/apache-foreground /usr/local/bin/apache-foreground
RUN chmod +x /usr/local/bin/apache-foreground

COPY fpm/www.conf /etc/php5/fpm/pool.d/www.conf

COPY fpm/bin/fpm-foreground /usr/local/bin/fpm-foreground
RUN chmod +x /usr/local/bin/fpm-foreground

RUN echo "<?php phpinfo(); ?>" > /var/www/info.php

#EXPOSE 80
CMD ["/usr/local/bin/apache-foreground"]
#CMD ["/usr/local/bin/fpm-foreground"]
