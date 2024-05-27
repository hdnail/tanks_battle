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

# nginx config
COPY ./dockerfiles/site.conf /etc/nginx/sites-available/site.conf
COPY ./dockerfiles/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN cd /etc/nginx/sites-enabled && rm -f * && ln -s /etc/nginx/sites-available/site.conf default

# Entrypoint.
COPY ./dockerfiles/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]

# files
# /usr/local/include/php/