#
#--------------------------------------------------------------------------
# Image Setup
# $REF: $
#--------------------------------------------------------------------------
#
#

FROM php:7.1-fpm

# COPY .      /bd_build
ADD  ./bin/install_clean   /usr/sbin/install_clean
ADD  ./bin/setuser         /usr/sbin/setuser

#
#--------------------------------------------------------------------------
# Core Software's Installation
#--------------------------------------------------------------------------
#


#RUN apt-get -yqq update \
#    && apt-get -qy install --no-install-recommends \
RUN install_clean \
        wget curl \
        zip unzip \
        lsb-release \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        libzip-dev libicu-dev \
        libldap2-dev \
        librabbitmq-dev \
        libgmp-dev \
        libxml2-dev \
        python-setuptools \
        libxslt-dev \
        libc-client-dev libkrb5-dev

#    && apt-get autoremove -qy \
#    && apt-get clean -qy \
#    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# END Core Software's Installation  -------------

#
#--------------------------------------------------------------------------
# PHP Installation
#--------------------------------------------------------------------------
#
RUN echo "docker-php-ext-install"     && \
    pecl update-channels              && \
    docker-php-ext-configure gd      \
            --enable-gd-native-ttf   \
            --with-jpeg-dir=/usr/lib \
            --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd         && \
    docker-php-ext-install bcmath     && \
    docker-php-ext-install exif       && \
    docker-php-ext-install gmp        && \
    # docker-php-ext-install mbstring   && \
    docker-php-ext-install mcrypt     && \
    docker-php-ext-install opcache    && \
    docker-php-ext-install pcntl      && \
    # docker-php-ext-install pdo        && \
    docker-php-ext-install pdo_mysql  && \
    docker-php-ext-install pdo_pgsql  && \
    docker-php-ext-install pgsql      && \
    docker-php-ext-install sockets    && \
    # docker-php-ext-install tokenizer  && \
    # docker-php-ext-install xml        && \
    docker-php-ext-install xsl        && \
    docker-php-ext-install zip        && \
    # docker-php-ext-install soap       && \
#
    pecl install -o -f amqp      && docker-php-ext-enable amqp      && \
    pecl install -o -f apcu      && docker-php-ext-enable apcu      && \
    pecl install -o -f memcached && docker-php-ext-enable memcached && \
    # pecl install -o -f mongodb   && docker-php-ext-enable mongodb   && \
    pecl install -o -f redis     && docker-php-ext-enable redis     && \
    # pecl install -o -f swoole    && docker-php-ext-enable swoole    && \
    pecl install -o -f xdebug    && \
#
    docker-php-ext-configure intl            \
        && docker-php-ext-install intl          \
    && docker-php-ext-configure ldap            \
            --with-libdir=lib/x86_64-linux-gnu/ \
        && docker-php-ext-install ldap          \
    && docker-php-ext-configure imap            \
            --with-kerberos --with-imap-ssl      \
        && docker-php-ext-install imap          \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

#RUN pecl install -o -f imagick              && docker-php-ext-enable imagick


# END PHP Installation --------------------------

#ADD ./php.ini                  /usr/local/etc/php/
ADD ./50-custom.ini       /usr/local/etc/php/conf.d/
ADD ./php-fpm.d/*.conf    /usr/local/etc/php-fpm.d/

RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer global require "hirak/prestissimo" && \
    rm -rf /root/.composer/cache

RUN wget --no-check-certificate -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" \
    && chmod +x /usr/local/bin/gosu

ADD ./bin/phpenmod         /usr/local/bin/
RUN chmod +x /usr/local/bin/phpenmod \
    && ln -s /usr/local/bin/phpenmod /usr/local/bin/phpdismod

ADD ./bin/docker-php-entrypoint /usr/local/sbin/
RUN chmod +x /usr/local/sbin/docker-php-entrypoint

#
#--------------------------------------------------------------------------
# User www-data Configuration
#--------------------------------------------------------------------------
#
RUN cp -r /etc/skel /home/www-data \
    && cp -r /root/.composer /home/www-data/ \
    && chown -R www-data:www-data /home/www-data \
    && usermod -d /home/www-data www-data

RUN touch /usr/local/etc/php/conf.d/51-custom.ini \
    && chgrp www-data /usr/local/etc/php/conf.d/51-custom.ini \
    && chmod g+w      /usr/local/etc/php/conf.d/51-custom.ini

#
#--------------------------------------------------------------------------
# Clear code
#--------------------------------------------------------------------------
#
RUN apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www


CMD ["php-fpm"]

EXPOSE 9000
