FROM php:8.2.11-fpm-bullseye

RUN apt-get -y update \
    && apt-get -y install --no-install-recommends software-properties-common nginx libpcre3-dev gpg git wget \
    && pecl install zephir_parser \
    && echo "extension=zephir_parser.so" >> /usr/local/etc/php/conf.d/zephir_parser.ini \
    && cd /tmp \
    && wget https://github.com/zephir-lang/zephir/releases/download/0.17.0/zephir.phar \
    && mv zephir.phar /usr/local/bin \
    && cd /usr/local/bin/ \
    && mv zephir.phar zephir \
    && chmod a+x zephir \
    && pecl install --configureoptions 'enable-event-debug="no"' apcu \
    && echo "extension=apcu.so" >> /usr/local/etc/php/conf.d/apcu.ini \
    && cd /usr/local/ \
    && git clone https://github.com/phalcon/cphalcon \
    && cd cphalcon \
    && git checkout tags/v5.6.2 ./ \
    && zephir fullclean \
    && zephir compile \
    && cd ext \
    && phpize \
    && ./configure \
    && make && make install \
    && echo "extension=phalcon.so" >> /usr/local/etc/php/conf.d/30-phalcon.ini

# Composer and MongoDB
RUN cd /root \
    && apt-get -y update && apt-get install -y zlib1g-dev libzip-dev unzip libcurl4-openssl-dev pkg-config libssl-dev \
    && pecl install zip \
    && echo "extension=zip.so" >> /usr/local/etc/php/conf.d/zip.ini \
    && wget https://raw.githubusercontent.com/composer/getcomposer.org/cd8ca011326ab9a17a555846c69461c1d53c1895/web/installer -O - -q | php -- --quiet \
    && chmod a+x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && pecl install mongodb  \
    && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

# nginx config
COPY ./dockerfiles/site.conf /etc/nginx/sites-available/site.conf
COPY ./dockerfiles/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN cd /etc/nginx/sites-enabled && rm -f * && ln -s /etc/nginx/sites-available/site.conf default

# Entrypoint.
COPY ./dockerfiles/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Clean
RUN rm -f /var/www/html/index.nginx-debian.html \
    && apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove

EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]
