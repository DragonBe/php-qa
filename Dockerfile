FROM php:7.4-cli

RUN apt-get update \
  && apt-get install -y \
    libbz2-dev \
    libicu-dev \
    libpng-dev \
    libsqlite3-dev \
    libtidy-dev \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev \
    sqlite3 \
    unzip \
  && docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    pdo_sqlite \
    soap \
    tidy \
    xmlrpc \
    xsl \
    zip

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get auto-remove -y \
  && apt-get clean
