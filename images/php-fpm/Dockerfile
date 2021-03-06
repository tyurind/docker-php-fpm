#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
#

FROM php:7.1-fpm

RUN mkdir -p /var/www 2>&1 >/dev/null

COPY .      /bd_build
ADD ./bin /usr/sbin

#
#--------------------------------------------------------------------------
# Core Software's Installation
#--------------------------------------------------------------------------
#


RUN apt-get update -yqq
RUN apt-get install -y --no-install-recommends \
        wget \
        curl \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        libzip-dev libicu-dev zip unzip \
        libldap2-dev \
        librabbitmq-dev \
        libgmp-dev \
        libxml2-dev \
        python-setuptools \
        lsb-release

# END Core Software's Installation  -------------

#
#--------------------------------------------------------------------------
# PHP Installation
#--------------------------------------------------------------------------
#


RUN pecl update-channels

RUN docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

RUN docker-php-ext-install opcache
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install exif
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pgsql


#####################################
# xml :
#####################################
## dependency:
##      libxml2-dev
##
RUN docker-php-ext-install xml


#####################################
# redis :
#####################################
##
RUN pecl install -o -f redis     && docker-php-ext-enable redis



#####################################
# apcu :
#####################################
##
RUN pecl install -o -f apcu     && docker-php-ext-enable apcu


#####################################
# xDebug :
#####################################
##
RUN pecl install -o -f xdebug    && docker-php-ext-enable xdebug
# Disable xdebug
RUN sed -i 's/^zend_extension=/;zend_extension=/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


#####################################
# mongodb :
#####################################
## dependency:
##
##
#RUN pecl install -o -f mongodb   && docker-php-ext-enable mongodb


#####################################
# zip :
#####################################
## dependency:
##      libzip-dev zip unzip
##
RUN docker-php-ext-install zip


#####################################
# mcrypt :
#####################################
## dependency:
##      libmcrypt-dev
##
RUN docker-php-ext-install mcrypt


#####################################
# gmp :
#####################################
## dependency:
##      libgmp-dev
##
RUN docker-php-ext-install gmp

#####################################
# libmemcached :
#####################################
## dependency:
##      libmemcached-dev
##
RUN pecl install -o -f memcached && \
    docker-php-ext-enable memcached


#####################################
# SOAP:
#####################################
## dependency:
##      libxml2-dev php-soap
##
#RUN apt-get -y install libxml2-dev php-soap && \
#    docker-php-ext-install soap


#####################################
# amqp :
#####################################
## dependency:
##      librabbitmq-dev
##
RUN pecl install -o -f amqp  && \
    docker-php-ext-enable amqp


#####################################
# imagemagick :
#####################################
## dependency:
##     libmagickwand-dev imagemagick
##
# RUN pecl install -o -f imagick   && docker-php-ext-enable imagick

#####################################
# Human Language and Character Encoding Support:
#####################################
## dependency:
##     libicu-dev
##
RUN docker-php-ext-configure intl   && \
    docker-php-ext-install intl


#####################################
# Install XSL
#####################################
## dependency:
##     libxslt-dev
##
RUN apt-get install -y --no-install-recommends \
        libxslt-dev && \
    docker-php-ext-install xsl

#####################################
# LDAP:
#####################################
## dependency:
##     libldap2-dev
##
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

#####################################
# IMAP:
#####################################
## dependency:
##     libc-client-dev libkrb5-dev
##
RUN apt-get install -y --no-install-recommends \
        libc-client-dev libkrb5-dev && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap

#####################################
# pcntl:
#####################################
## dependency:
##     libc-dev
##
RUN docker-php-ext-install pcntl


# END PHP Installation --------------------------

ADD ./conf.d/*.ini /usr/local/etc/php/conf.d/
ADD ./php-fpm.d/*.conf /usr/local/etc/php-fpm.d/


#--------------------------------------------------------------------------
# Postgres client
#--------------------------------------------------------------------------
#


RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update -yqq && \
    apt-get install -y  --no-install-recommends postgresql-client

# END Postgres client ---------------------------

RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

#
#--------------------------------------------------------------------------
# Clear code
#--------------------------------------------------------------------------
#


RUN apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
