FROM php:8.2.11-fpm-bullseye

# nginx
RUN apt-get -y update && apt-get -y install --no-install-recommends nginx

# nginx config
COPY ./dockerfiles/site.conf /etc/nginx/sites-available/site.conf
COPY ./dockerfiles/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN cd /etc/nginx/sites-enabled && rm -f * && ln -s /etc/nginx/sites-available/site.conf default

# Entrypoint.
COPY ./dockerfiles/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]