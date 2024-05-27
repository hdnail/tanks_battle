#!/bin/bash

php-fpm -D

exec "$@"