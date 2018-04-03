#!/bin/bash


#
#--------------------------------------------------------------------------
# PHP Installation
#--------------------------------------------------------------------------
#

#####################################
# SOAP:
#####################################
apt-get -qy install libxml2-dev php7.1-soap && \
    apt-get install -qy libldap2-dev && \
    apt-get install -qy php7.1-ldap  && \
    apt-get install -qy php7.1-imap

#####################################
# xDebug:
#####################################
pecl update-channels

apt-get install -qy php7.1-xdebug && \
    sed -i 's/^;//g' /etc/php/7.1/cli/conf.d/20-xdebug.ini


#####################################
# AMQP:
#####################################
apt-get install librabbitmq-dev -qy && \
    # Install the mongodb extension
    pecl -q install amqp && \
    echo "extension=amqp.so" >> /etc/php/7.1/mods-available/amqp.ini && \
    ln -s /etc/php/7.1/mods-available/amqp.ini /etc/php/7.1/cli/conf.d/30-amqp.ini

#####################################
# PHP REDIS EXTENSION FOR PHP 7.1
#####################################
pecl -q install -o -f redis && \
    echo "extension=redis.so" >> /etc/php/7.1/mods-available/redis.ini && \
    phpenmod redis

#####################################
# Swoole EXTENSION FOR PHP 7
#####################################
pecl -q install swoole && \
    echo "extension=swoole.so" >> /etc/php/7.1/mods-available/swoole.ini && \
    ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini

curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer


apt-get clean -qy
rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
