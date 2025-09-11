FROM progr000/php-5.4.45

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

CMD ["/usr/local/bin/apache-foreground"]
#CMD ["/usr/local/bin/fpm-foreground"]