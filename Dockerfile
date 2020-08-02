FROM php:7.4-cli

RUN apt-get update \
  && apt-get install -y \
    libbz2-dev \
    libicu-dev \
    libpng-dev \
    libtidy-dev \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev \
  && docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    tidy \
    xmlrpc \
    xsl \
    zip

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
