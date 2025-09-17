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

USER www-data

CMD ["/run.sh"]
