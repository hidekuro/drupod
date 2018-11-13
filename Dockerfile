FROM drupal:8.6.2-fpm-alpine
LABEL maintainer="hidekuro"

ENV COMPOSER_ALLOW_SUPERUSER=1
ARG COMPOSER_VERSION="1.7.3"

# install XDebug
RUN set -ex \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install xdebug \
    && apk del .build-deps

# setup composer
RUN curl -sSLo /usr/local/bin/composer https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar \
    && chmod +x /usr/local/bin/composer \
    && composer global require "hirak/prestissimo"

# setup drush
RUN composer global require "drush/drush:8.*" \
    && ln -sf ~/.composer/vendor/bin/drush /usr/local/bin/drush \
    && drush -y init

# setup php.ini
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
COPY ./php/conf.d/custom.ini /usr/local/etc/php/conf.d/custom.ini

# install or update libs
COPY ./drupal/composer.json /var/www/html/composer.json
COPY ./drupal/composer.json /var/www/html/composer.lock
RUN composer install --no-dev

# copy app sources
COPY ./drupal/modules /var/www/html/modules
COPY ./drupal/profiles /var/www/html/profiles
COPY ./drupal/themes /var/www/html/themes

# set debug flag
ENV ENABLE_XDEBUG="false"

# set ENTRYPOINT
COPY ./docker-drupod-entrypoint.sh /usr/local/bin/docker-drupod-entrypoint
RUN chmod +x /usr/local/bin/docker-drupod-entrypoint
ENTRYPOINT ["docker-drupod-entrypoint"]
CMD ["php-fpm"]
