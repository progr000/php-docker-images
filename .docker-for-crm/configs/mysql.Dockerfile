FROM progr000/mysql-server-5.5.62

# Dev env additional packages
ARG APP_ENVIRONMENT
ENV APP_ENVIRONMENT=${APP_ENVIRONMENT}
RUN if [ "$APP_ENVIRONMENT" = "development" ]; \
    then yum install -y procps; \
    fi

CMD ["/run.sh"]