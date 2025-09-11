FROM debian:jessie

MAINTAINER Maksym <mhaivoronskyi@hoststar.ch>

ENV PHP_VERSION 5.3.29
ENV OPENSSL_VERSION 1.0.2d
ENV PHP_INI_DIR /etc/php5/apache2

#7
COPY docker-php-* /usr/local/bin/
#8
COPY apache2-foreground /usr/local/bin/

#9
RUN <<EOF
  echo "deb [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" > /etc/apt/sources.list
  echo "deb-src [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" >> /etc/apt/sources.list
  echo "deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main non-free contrib" >> /etc/apt/sources.list
EOF

#10
RUN echo "Installing all necessary packages" \
    && apt-get update && apt-get install -y --no-install-recommends --fix-missing \
        aptitude \
        procps \
        ca-certificates \
        curl \
        iputils-ping \
        net-tools \
        telnet \
        socat \
        nano \
        mc \
        \
        autoconf \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkg-config \
        re2c \
        \
        apache2-bin apache2-dev apache2.2-common \
        \
        librecode0 libmysqlclient-dev libsqlite3-0 libxml2 \
        autoconf2.13 libcurl4-openssl-dev libreadline6-dev librecode-dev libsqlite3-dev libssl-dev libxml2-dev xz-utils \
        libpng-dev libjpeg-dev libgif-dev libxpm-dev libfreetype6-dev\
        intltool libicu-dev \
        mcrypt libtomcrypt-dev libmcrypt-dev  \
        libxslt-dev libxslt1.1 libxslt1-dev \
        libltdl-dev libltdl7 libltdl7-dev libltdl3-dev \
        libssh2-1-dev \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

#11
RUN echo "Small fix for freetype, need for php ./configure" \
    && mkdir /usr/include/freetype2/freetype \
    && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h \
    \
    && echo "Prepare environment for apache and php" \
    && rm -rf /var/www/html  \
    && mkdir -p /var/lock/apache2 \
                /var/run/apache2 \
                /var/log/apache2 \
                /var/www/html \
                /var/lib/apache2/module/enabled_by_admin \
                /var/lib/apache2/module/disabled_by_admin \
    && chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html /etc/apache2 /var/lib/apache2 \
    && chmod +x /usr/local/bin/apache2-foreground \
    && mkdir -p $PHP_INI_DIR/conf.d \
    && chmos +x /usr/local/bin/docker-php-ext-* \
    \
    && echo "Apache + PHP requires preforking Apache for best results" \
    && a2dismod mpm_event  \
    && a2enmod mpm_prefork \
    && mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist

#bzip2 libzip-dev \

#12
COPY apache2.conf /etc/apache2/apache2.conf

#13
# compile openssl, otherwise --with-openssl won't work
RUN set -x \
    \
    && echo "Compiling openssl" \
    && CFLAGS="-fPIC" \
    && mkdir -p /usr/src/openssl \
    && cd /usr/src \
    && curl -sL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -o openssl.tar.gz \
    && tar -xzf openssl.tar.gz -C openssl --strip-components=1 \
    && rm openssl.tar.gz \
    && cd /usr/src/openssl \
    && ./config -fPIC && make && make install \
    \
    && echo "Compiling php with all necessary extensions" \
    && mkdir -p /usr/src/php \
    && cd /usr/src \
    && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror" -o php.tar.xz \
    && tar -xof php.tar.xz -C /usr/src/php --strip-components=1 \
    && rm php.tar.xz* \
    && cd /usr/src/php \
    && ./configure \
        $(command -v apxs2 > /dev/null 2>&1 && echo '--with-apxs2=/usr/bin/apxs2' || true) \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-ctype \
        --with-curl \
        --enable-dom \
        --enable-ftp \
        --with-gd \
        --with-iconv \
        --enable-json \
        --enable-mbstring \
        --with-mcrypt \
        --with-mysql \
        --with-mysqli \
        --enable-mysqlnd \
        --with-pdo-mysql \
        --with-pdo-sqlite \
        --with-openssl=/usr/local/ssl \
        --enable-phar \
        --enable-soap \
        --enable-sockets \
        --with-sqlite \
        --with-sqlite3 \
        --enable-tokenizer \
        --enable-xmlreader \
        --enable-xmlwriter \
        --with-freetype-dir=/usr/include/freetype2 \
        --enable-gd-native-ttf \
        --with-readline \
        --with-recode \
        --with-zlib \
        --with-pcre-regex \
        --with-mhash \
        --enable-calendar \
        --enable-mbregex \
        --enable-zip \
        --with-xsl \
    && make -j"$(nproc)" \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && make clean \
    \
    && echo "Compiling ssh2 extension" \
    && mkdir -p /usr/src/ssh2 \
    && cd /usr/src \
    && curl -SL http://pecl.php.net/get/ssh2-0.12.tgz -o ssh2.tgz \
    && tar -xof ssh2.tgz -C /usr/src/ssh2 --strip-components=1 \
    && cd /usr/src/ssh2 \
    && phpize \
    && ./configure && make && make install \
    \
    && echo "Creating preferences for php.ini" \
    && echo "default_charset = " > $PHP_INI_DIR/conf.d/charset.ini \
    && echo "date.timezone = Europe/Zurich" > $PHP_INI_DIR/conf.d/tz.ini \
    && echo "extension=ssh2.so" > $PHP_INI_DIR/conf.d/ssh2.ini

#--with-icu-dir=/usr \
#--enable-intl \
#--with-png \
#--with-jpeg \
#--with-gif \
#--with-xbmp \
#--with-freetype \
#--enable-xsl \
#--with-bz2 \
#--enable-cgi \
#--enable-ftp \
#--with-t1lib \
#--enable-t1lib \
#--with-pgsql \
#--with-pdo-pgsql \

#14
WORKDIR /var/www/html

#15
USER www-data

#16
EXPOSE 80
CMD ["apache2-foreground"]