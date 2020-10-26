FROM composer:1.9.3 AS composer

FROM php:7.3-fpm-alpine

ENV DEPLOYER_VERSION=6.8.0

RUN apk update --no-cache \
    && apk add --no-cache \
        openssh-client \
        nodejs \
        nodejs-current-npm \
        php7 \
        php7-openssl \
        php7-json \
        php7-phar \
        php7-gd \
        php7-intl \
        php7-zlib \
        php7-curl \
        php7-mbstring \
        php7-iconv \
        php7-pear \
        php7-tokenizer \
        php7-dev \
        php7-pdo \
        php7-pdo_mysql \
        php7-dom \
        php7-xml \
        php7-simplexml \
        php7-xmlreader \
        php7-xmlwriter \
        php7-fileinfo \
        php7-zip \
        php7-ctype \
        imagemagick \
        imagemagick-libs \
        imagemagick-dev \
        git \
        g++ \
        musl-dev \
        make \
        icu-dev \
        libpng-dev \
        rsync \
        openssh \
        curl \
        python3 \
        py-pip \
        jq \
        bash \
        groff \
        less \
        mailcap \
        zip \
        libzip-dev \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        jpeg-dev \
        libjpeg \
        libjpeg-turbo-dev

RUN docker-php-ext-install gd zip mysqli
RUN docker-php-ext-configure zip

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/lib/ \
        --with-png-dir=/usr/lib/ \
        --with-jpeg-dir=/usr/lib/ \
        --with-gd

COPY --from=composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1 
ENV COMPOSER_CACHE_DIR /.cache/composer
ENV NPM_CONFIG_CACHE /.cache/npm


RUN curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar > /usr/local/bin/deployer \
    && chmod +x /usr/local/bin/deployer

run mkdir -p ${COMPOSER_CACHE_DIR} && mkdir -p ${NPM_CONFIG_CACHE} && chmod -cR 777 /.cache

ARG PUID=106
ARG PGID=106

RUN addgroup -g ${PGID} jenkins && \
    adduser -D -u ${PUID} -G jenkins jenkins


WORKDIR /var/www/html