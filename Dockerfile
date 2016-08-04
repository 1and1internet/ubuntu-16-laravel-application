FROM 1and1internet/ubuntu-16-nginx-php-7.0
MAINTAINER brian.wojtczak@1and1.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
ENV \
    DOCUMENT_ROOT=html/public \
    APP_WORKER_QUEUES=high,low \
    APP_WORKER_TIMEOUT=180 
RUN \
    apt-get update -q && \
    apt-get install -q -o Dpkg::Options::=--force-confdef -y php7.0-bcmath php7.0-gmp php7.0-json php7.0-ldap php7.0-recode php7.0-pspell php7.0-soap php7.0-bz2 && \
    apt-get install -q -o Dpkg::Options::=--force-confdef -y sqlite3 libmysqlclient-dev mysql-common mysql-client && \
    apt-get autoremove -q -y && \
    apt-get clean -q -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/www/html && \
    rm -rf /var/www && \
    rm -rf /var/log/nginx/*.log && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    sed -i -e 's/^access_log .*;$/access_log \/var\/log\/access\.log/g' /etc/nginx/sites-enabled/site.conf && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    sed -i -e 's/^error_log .*;$/error_log stderr;/g' /etc/nginx/sites-enabled/site.conf && \
    chmod -R 777 /etc/supervisor/conf.d /etc/supervisor/conf.d/* && \
    chmod -R 755 /hooks/supervisord-pre.d/* && \
    mkdir -p /var/www/html && \
    composer create-project \
    --no-ansi \
    --no-dev \
    --no-interaction \
    --no-progress \
    --prefer-dist \
    laravel/laravel /var/www/html ~5.2.0 && \
    ln -sf /var/www/html/artisan /usr/bin/artisan && \
    chmod 755 /var/www/html/artisan && \
    touch /var/www/html/storage/logs/laravel.log && \
    rm -f /var/www/html/database/migrations/*.php /var/www/html/app/Users.php && \
    find /var/www/html/ -type d -exec chmod 755 {} + && \
    find /var/www/html/ -type d -exec chmod ug+s {} + && \
    find /var/www/html/ -type f -exec chmod 644 {} + && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 777 /var/www/html/storage && \
    chmod -R 777 /var/www/html/bootstrap/cache/
WORKDIR /var/www/html
ONBUILD RUN php artisan key:generate
