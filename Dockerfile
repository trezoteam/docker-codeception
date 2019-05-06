FROM php:7.0-alpine

RUN apk add zlib-dev

# Install php extensions
RUN docker-php-ext-install \
    bcmath \
    zip

# Configure php
RUN echo "date.timezone = UTC" >> /usr/local/etc/php/php.ini

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin

RUN composer require codeception/codeception:2.5.2 --dev
RUN composer install --prefer-dist --no-interaction --optimize-autoloader --classmap-authoritative

ENTRYPOINT ["/vendor/codeception/codeception/codecept"]

# Prepare host-volume working directory
RUN mkdir /project
WORKDIR /project
