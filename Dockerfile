#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
# To edit the 'php-fpm' base Image, visit its repository on Github
#    https://github.com/Laradock/php-fpm
#
# To change its version, see the available Tags on the Docker Hub:
#    https://hub.docker.com/r/laradock/php-fpm/tags/
#
# Note: Base Image name format {image-tag}-{php-version}
#

FROM php:7.1-fpm


#
#--------------------------------------------------------------------------
# Core Software's Installation
#--------------------------------------------------------------------------
#

RUN apt-get update -yqq
RUN apt-get install -y --no-install-recommends \
    autoconf \
    curl \
    g++ \
    libfreetype6-dev \
    libgmp-dev \
    libicu-dev \
    libicu-dev \
    libjpeg-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng12-dev \
    libpq-dev \
    librabbitmq-dev \
    libssl-dev \
    libxml2-dev \
    libz-dev \
    wget \
    zlib1g-dev


# Image optimizers:
RUN apt-get update -yqq && \
    apt-get install -y jpegoptim optipng pngquant gifsicle

RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN apt-get update -yqq && \
    apt-get install -y lsb-release
#
#--------------------------------------------------------------------------
# PHP Installation
#--------------------------------------------------------------------------
#

RUN docker-php-ext-install bcmath
RUN docker-php-ext-install exif
RUN docker-php-ext-install gmp
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install soap
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip

RUN pecl update-channel
RUN pecl install -o -f redis     && docker-php-ext-enable redis
RUN pecl install -o -f xdebug    && docker-php-ext-enable xdebug
RUN pecl install -o -f swoole    && docker-php-ext-enable swoole
RUN pecl install -o -f amqp      && docker-php-ext-enable amqp
RUN pecl install -o -f mongodb   && docker-php-ext-enable mongodb
RUN pecl install -o -f memcached && docker-php-ext-enable memcached

# imagemagick
RUN apt-get install -y libmagickwand-dev imagemagick
RUN pecl install -o -f imagick   && docker-php-ext-enable imagick

#####################################
# Human Language and Character Encoding Support:
#####################################

RUN docker-php-ext-configure intl && \
    docker-php-ext-install intl

#####################################
# LDAP:
#####################################

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
ADD ./laravel.ini /usr/local/etc/php/conf.d
ADD ./xlaravel.pool.conf /usr/local/etc/php-fpm.d/

#
#--------------------------------------------------------------------------
# Postgres client
#--------------------------------------------------------------------------
#

# USER root
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update -yq && \
	apt-get install -y postgresql-client
#
#--------------------------------------------------------------------------
# PHAP Lib Installation
#--------------------------------------------------------------------------
#

RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer

RUN curl -L http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o php-cs-fixer && \
    chmod a+x php-cs-fixer && \
    mv php-cs-fixer /usr/local/bin/php-cs-fixer

RUN curl -L https://phar.phpunit.de/phpunit-skelgen.phar -o phpunit-skelgen && \
    chmod a+x phpunit-skelgen && \
    mv phpunit-skelgen /usr/local/bin/phpunit-skelgen
#
#--------------------------------------------------------------------------
# Clear code
#--------------------------------------------------------------------------
#

RUN apt-get autoremove -y && apt-get autoclean -y && apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/* /var/tmp/* /tmp/pear && \
    mkdir -p /var/www

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
