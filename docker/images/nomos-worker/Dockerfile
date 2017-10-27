FROM ubuntu:xenial

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        git \
        php7.0 \
        php7.0-bcmath \
        php7.0-cli \
        php7.0-common \
        php7.0-curl \
        php7.0-fpm \
        php7.0-json \
        php7.0-mbstring \
        php7.0-mysql \
        php7.0-opcache \
        php7.0-readline \
        php7.0-xml \
        unzip \
        && apt-get clean && rm -r /var/lib/apt/lists/*

COPY ["composer.json", "/www/"]

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/www/ && \
    cd /www/ && \
    php composer.phar install

RUN echo 'listen = 9000' >> /etc/php/7.0/fpm/pool.d/www.conf

RUN mkdir /run/php

COPY ["app", "/www/app"]
COPY ["vhs", "/www/vhs"]
COPY ["migrations", "/www/migrations"]
COPY ["tools", "/www/tools"]
COPY ["docker", "/usr/local/docker"]
COPY ["conf/config.ini.php.docker", "/www/conf/config.ini.php"]

EXPOSE 9000

CMD ["/usr/local/docker/docker_run.sh"]
