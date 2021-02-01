FROM composer:1.9.3 AS composer

FROM jakubfrajt/docker-ci-php-security-checker:1.0.0 AS  checker

FROM php:8-fpm-alpine

ENV DEPLOYER_VERSION=6.8.0

RUN apk update --no-cache \
    && apk add --no-cache \
        openssh-client \
        nodejs-current \
        nodejs-npm \
        php8 \
        php8-openssl \
        php8-json \
        php8-phar \
        php8-gd \
        php8-intl \
        php8-zlib \
        php8-curl \
        php8-mbstring \
        php8-iconv \
        php8-pear \
        php8-tokenizer \
        php8-dev \
        php8-pdo \
        php8-pdo_mysql \
        php8-dom \
        php8-xml \
        php8-simplexml \
        php8-xmlreader \
        php8-xmlwriter \
        php8-fileinfo \
        php8-zip \
        php8-ctype \
        imagemagick \
        imagemagick-libs \
        imagemagick-dev \
        git \
        g++ \
        gcc \
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
        libjpeg-turbo-dev \
        python2


# configure, install and enable all php packages
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure zip

RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) zip

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY --from=checker /usr/bin/local-php-security-checker /usr/bin/local-php-security-checker

ENV COMPOSER_ALLOW_SUPERUSER 1 
ENV COMPOSER_CACHE_DIR /.cache/composer
ENV NPM_CONFIG_CACHE /.cache/npm

run mkdir -p ${COMPOSER_CACHE_DIR} && mkdir -p ${NPM_CONFIG_CACHE} && chmod -cR 777 /.cache

ARG PUID=106
ARG PGID=106

RUN addgroup -g ${PGID} jenkins && \
    adduser -D -u ${PUID} -G jenkins jenkins

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    touch /root/.ssh/known_hosts

RUN mkdir -p /home/jenkins/.ssh && \
    chmod 0700 /home/jenkins/.ssh && \
    touch /home/jenkins/.ssh/known_hosts && \
    chown -cR jenkins:jenkins /home/jenkins/.ssh

WORKDIR /var/www/html