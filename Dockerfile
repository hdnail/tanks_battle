FROM php:7.4.33-fpm-bullseye

RUN apt-get -y update \
    && apt-get -y install --no-install-recommends nginx

# COPY ./dockerfiles/nginx.conf /etc/nginx/sites-available/nginx.conf
COPY ./dockerfiles/default.conf /etc/nginx/sites-available/default.conf
COPY ./dockerfiles/entrypoint.sh /entrypoint.sh

RUN cd /etc/nginx/sites-enabled && rm -f * \
    && ln -s /etc/nginx/sites-available/default.conf default

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
# CMD ["tail", "-f", "/dev/null"]
CMD ["nginx", "-g", "daemon off;"]

# docker-compose stop && docker-compose down && docker-compose build && docker-compose up

# apt-get install software-properties-common