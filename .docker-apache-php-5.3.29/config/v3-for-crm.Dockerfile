FROM debian:jessie

#MAINTAINER Maksym <mhaivoronskyi@hoststar.ch>

# && curl -sL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -o openssl.tar.gz \
# && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror" -o php.tar.xz \
#ENV PHP_VERSION=5.3.29
#ENV OPENSSL_VERSION=1.0.2d
ENV PHP_INI_DIR=/etc/php5/apache2

#2,3
COPY bin/* /usr/local/bin/
COPY src/* /tmp/

#4
RUN <<EOF
  echo "deb [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" > /etc/apt/sources.list
  echo "deb-src [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" >> /etc/apt/sources.list
  echo "deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main non-free contrib" >> /etc/apt/sources.list
EOF

#aptitude \
#procps \
#iputils-ping \
#net-tools \
#telnet \
#socat \
#nano \
#mc \

#5
RUN echo "Installing all necessary packages" \
    && apt-get update && apt-get install -y --no-install-recommends --fix-missing \
        ca-certificates \
        curl \
        autoconf \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkg-config \
        re2c \
        apache2-bin apache2-dev apache2.2-common \
        libapache2-mod-security2 \
        libxml2-dev \
        libzip-dev \
        socat \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

#6
RUN echo "Prepare environment for apache and php" \
    && rm -rf /var/www/html  \
    && mkdir -p /var/lock/apache2 \
                /var/run/apache2 \
                /var/log/apache2 \
                /var/www/html \
                /var/lib/apache2/module/enabled_by_admin \
                /var/lib/apache2/module/disabled_by_admin \
    && chown -R www-data:www-data /var/lock/apache2 \
                                  /var/run/apache2  \
                                  /var/log/apache2 \
                                  /var/www/html \
                                  /etc/apache2 \
                                  /var/lib/apache2 \
    && chmod +x /usr/local/bin/apache2-foreground \
    && chmod +x /usr/local/bin/docker-php-ext-* \
    && mkdir -p $PHP_INI_DIR/conf.d \
    \
    && echo "Apache + PHP requires preforking Apache for best results" \
    && a2dismod mpm_event  \
    && a2enmod mpm_prefork \
    && mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist

#7
COPY apache2.conf /etc/apache2/apache2.conf

#8
# Compiling openssl, otherwise --with-openssl won't work
RUN set -x \
    && echo "Compiling openssl" \
    && CFLAGS="-fPIC" \
    && mkdir -p /usr/src/openssl \
    && tar -xzf /tmp/openssl-1.0.2d.tar.gz -C /usr/src/openssl --strip-components=1 \
    && cd /usr/src/openssl \
    && ./config -fPIC && make && make install && make clean

#9
# Compiling php
RUN set -x \
    && echo "Compiling php" \
    && mkdir -p /usr/src/php \
    && tar -xof /tmp/php-5.3.29.tar.xz -C /usr/src/php --strip-components=1 \
    && cd /usr/src/php \
    && ./configure \
        $(command -v apxs2 > /dev/null 2>&1 && echo '--with-apxs2=/usr/bin/apxs2' || true) \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --with-openssl=/usr/local/ssl \
        --with-mhash \
        --enable-mysqlnd \
        --with-zlib \
    && make -j"$(nproc)" && make install && make clean
# && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
# --enable-mysqlnd is included below because it's harder to compile after the fact the extensions are (since it's a plugin for several extensions, not an extension in itself)
# --with-mhash can be installed only here
# --with-openssl - required for another extensions
# --with-zlib  - required for another extensions

# 10
# Prepare ssh2 extention for php
RUN set -x \
    && echo "Prepare ssh2 extention for php" \
    && mkdir -p /usr/src/php/ext/ssh2 \
    && tar -xof /tmp/ssh2-0.12.tgz -C /usr/src/php/ext/ssh2 --strip-components=1
# && echo "extension=ssh2.so" > $PHP_INI_DIR/conf.d/ssh2.ini

#11
# Installing extensions
RUN echo "Installing dev packages for extensions and extensions which we need" \
    && apt-get update \
    && apt-get install -y --no-install-recommends --fix-missing libicu-dev \
    && docker-php-ext-install intl \
    && apt-get install -y --no-install-recommends --fix-missing libcurl4-openssl-dev \
    && docker-php-ext-install curl \
    && apt-get install -y --no-install-recommends --fix-missing libmcrypt-dev \
    && docker-php-ext-install mcrypt \
    && apt-get install -y --no-install-recommends --fix-missing libpng-dev libjpeg-dev libgif-dev libxpm-dev libfreetype6-dev \
    && echo "Small fix for freetype, needed for php ./configure for correct installation gd lib" \
    && mkdir /usr/include/freetype2/freetype \
    && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h \
    && docker-php-ext-configure gd --with-gd \
                                     --with-freetype-dir=/usr/include/freetype2 \
                                     --enable-gd-native-ttf \
                                     --with-jpeg-dir=/usr \
    && docker-php-ext-install gd \
    && apt-get install -y --no-install-recommends --fix-missing libssh2-1-dev \
    && docker-php-ext-install ssh2 \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pdo \
    && apt-get install -y --no-install-recommends --fix-missing libmysqlclient-dev \
    && docker-php-ext-install mysql mysqli pdo_mysql \
    && apt-get install -y --no-install-recommends --fix-missing libsqlite3-dev \
    && docker-php-ext-install sqlite pdo_sqlite \
    && docker-php-ext-install soap \
    && docker-php-ext-install sockets \
    && apt-get install -y --no-install-recommends --fix-missing libxslt-dev \
    && docker-php-ext-install xsl \
    && docker-php-ext-install zip \
    && apt-get install -y --no-install-recommends --fix-missing libbz2-dev \
    && docker-php-ext-install bz2 \
    && apt-get install -y --no-install-recommends --fix-missing libssl-dev \
    && docker-php-ext-install ftp

# If you need myslnd (native driver instead, please use this before && docker-php-ext-install mysql mysqli pdo_mysql \)
#    && docker-php-ext-configure mysql --with-mysql=mysqlnd \
#    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
#    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \

#12
# Composer
COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer

#13
RUN echo "Creating preferences for php.ini" \
    && echo "default_charset = " > $PHP_INI_DIR/conf.d/manual-php-ext-charset.ini \
    && echo "date.timezone = Europe/Zurich" > $PHP_INI_DIR/conf.d/manual-php-ext-tz.ini \
    && echo "Info" \
    && echo "<?php phpinfo(); ?>" > /var/www/html/info.php

#14
WORKDIR /var/www/html

#15
USER www-data

#16
EXPOSE 80
CMD ["apache2-foreground"]