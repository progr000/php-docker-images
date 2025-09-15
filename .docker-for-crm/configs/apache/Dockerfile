#FROM progr000/php-5.6.40-apache
FROM progr000/php-5.3.29-base-libs

USER root

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Dev env additional packages
ARG APP_ENVIRONMENT
ENV APP_ENVIRONMENT=${APP_ENVIRONMENT}
RUN if [ "$APP_ENVIRONMENT" = "development" ]; \
    then apt-get update && apt-get install --fix-missing -y procps iputils-ping net-tools telnet nano mc aptitude; \
    fi

#RUN apt-get update && apt-get install --fix-missing -y iptables
RUN apt-get update && apt-get install --fix-missing -y socat

USER www-data

CMD ["/run.sh"]
