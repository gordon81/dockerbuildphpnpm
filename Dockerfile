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
        zip

RUN pecl channel-update pecl.php.net \
    pecl install mcrypt exif imagick-3.4.3

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar > /usr/local/bin/deployer \
    && chmod +x /usr/local/bin/deployer

WORKDIR /var/www/html