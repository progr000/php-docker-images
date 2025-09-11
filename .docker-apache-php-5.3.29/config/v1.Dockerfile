FROM debian:jessie

MAINTAINER Maksym <mhaivoronskyi@hoststar.ch>

#RUN <<EOF
#  echo "deb [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" > /etc/apt/sources.list
#  echo "deb-src [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" >> /etc/apt/sources.list
#  echo "deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main non-free contrib" >> /etc/apt/sources.list
#EOF

#7
RUN echo "deb [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" > /etc/apt/sources.list
#8
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian jessie main non-free contrib" >> /etc/apt/sources.list
#9
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main non-free contrib" >> /etc/apt/sources.list

#11
# persistent / runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      librecode0 \
      libmysqlclient-dev \
      libsqlite3-0 \
      libxml2 \
      iputils-ping \
      net-tools \
      telnet \
      mc \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

#12
# phpize deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      autoconf \
      file \
      g++ \
      gcc \
      libc-dev \
      make \
      pkg-config \
      re2c \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

#13
##<apache2>##
RUN apt-get update && apt-get install -y apache2-bin apache2-dev apache2.2-common --no-install-recommends && rm -rf /var/lib/apt/lists/*

#14
RUN rm -rf /var/www/html && mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html && chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html

#15
# Apache + PHP requires preforking Apache for best results
RUN a2dismod mpm_event && a2enmod mpm_prefork

#16
RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist

#17
COPY apache2.conf /etc/apache2/apache2.conf
##</apache2>##

ENV PHP_INI_DIR /etc/php5/apache2
#18
RUN mkdir -p $PHP_INI_DIR/conf.d

ENV GPG_KEYS 0B96609E270F565C13292B24C13C70B87267B52D 0A95E9A026542D53835E3F3A7DEC4E69FC9C83D7 0E604491
#19
RUN set -xe \
  && for key in $GPG_KEYS; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key"; \
  done

#20
# compile openssl, otherwise --with-openssl won't work
RUN CFLAGS="-fPIC" && OPENSSL_VERSION="1.0.2d" \
      && cd /tmp \
      && mkdir openssl \
      && curl -sL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -o openssl.tar.gz \
      && curl -sL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz.asc" -o openssl.tar.gz.asc \
      && gpg --verify openssl.tar.gz.asc \
      && tar -xzf openssl.tar.gz -C openssl --strip-components=1 \
      && cd /tmp/openssl \
      && ./config -fPIC && make && make install \
      && rm -rf /tmp/*

ARG PHP_VERSION
ENV PHP_VERSION 5.3.29

#21 mcrypt
RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
      aptitude \
      apache2-dev autoconf2.13 libcurl4-openssl-dev libreadline6-dev librecode-dev libsqlite3-dev libssl-dev libxml2-dev xz-utils \
      libpng-dev libjpeg-dev libgif-dev libxpm-dev libfreetype6-dev\
      intltool libicu-dev \
      mcrypt libtomcrypt-dev libmcrypt-dev  \
      libxslt-dev libxslt1.1 libxslt1-dev \
      libltdl-dev libltdl7 libltdl7-dev libltdl3-dev \
      libssh2-1-dev \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/* \
    && mkdir /usr/include/freetype2/freetype \
    && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h

#bzip2 libzip-dev \

#22
# php 5.3 needs older autoconf
# --enable-mysqlnd is included below because it's harder to compile after the fact the extensions are (since it's a plugin for several extensions, not an extension in itself)
RUN set -x \
    && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror" -o php.tar.xz \
    && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror" -o php.tar.xz.asc \
    && gpg --verify php.tar.xz.asc \
    && mkdir -p /usr/src/php \
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
      && cd /usr/src \
      && curl -SL http://pecl.php.net/get/ssh2-0.12.tgz -o ssh2.tgz \
      && mkdir -p /usr/src/ssh2 \
      &&  tar -xof ssh2.tgz -C /usr/src/ssh2 --strip-components=1 \
      && cd /usr/src/ssh2 \
      && phpize \
      && ./configure && make && make install

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


#23
RUN echo "default_charset = " > $PHP_INI_DIR/conf.d/my-preferences.ini \
    && echo "date.timezone = Europe/Zurich" >> $PHP_INI_DIR/conf.d/my-preferences.ini \
    && echo "extension=ssh2.so" >> $PHP_INI_DIR/conf.d/my-preferences.ini \

#24
COPY docker-php-* /usr/local/bin/
#25
COPY apache2-foreground /usr/local/bin/
#26
RUN chmod +x /usr/local/bin/apache2-foreground

#27
WORKDIR /var/www/html

#28
EXPOSE 80
CMD ["apache2-foreground"]