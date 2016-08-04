#!/usr/bin/env bash

php artisan cache:clear

# Suppress errors caused when clearing the cache
#  because they will prevent us from fixing themselves otherwise
exit 0
