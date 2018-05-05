#!/bin/bash

# apt-get update -qy
# apt-get install -qy --no-install-recommends php-pear

#
#--------------------------------------------------------------------------
# PHP Installation
#--------------------------------------------------------------------------
#

#####################################
# SOAP:
#####################################
apt-get update -qy && \
    apt-get install -qy libxml2-dev php7.1-soap && \
    apt-get install -qy libldap2-dev && \
    apt-get install -qy php7.1-ldap  && \
    apt-get install -qy php7.1-imap

#####################################
# xDebug:
#####################################
pecl update-channels

apt-get install -qy php7.1-xdebug && \
    # sed -i 's/^;//g' /etc/php/7.1/cli/conf.d/20-xdebug.ini
    # sed -i 's/^zend_extension=/;zend_extension=/g' /etc/php/7.1/cli/conf.d/20-xdebug.ini
    rm -f /etc/php/7.1/cli/conf.d/20-xdebug.ini

#####################################
# AMQP:
#####################################
apt-get install librabbitmq-dev -qy && \
    # Install the mongodb extension
    pecl -q install -o -f amqp && \
    echo "extension=amqp.so" >> /etc/php/7.1/mods-available/amqp.ini && \
    ln -s /etc/php/7.1/mods-available/amqp.ini /etc/php/7.1/cli/conf.d/30-amqp.ini

#####################################
# PHP REDIS EXTENSION FOR PHP 7.1
#####################################
pecl -q install -o -f redis && \
    echo "extension=redis.so" >> /etc/php/7.1/mods-available/redis.ini && \
    ln -s /etc/php/7.1/mods-available/redis.ini /etc/php/7.1/cli/conf.d/20-redis.ini
    # phpenmod redis

#####################################
# Swoole EXTENSION FOR PHP 7
#####################################
pecl -q install  -o -f swoole && \
    echo "extension=swoole.so" >> /etc/php/7.1/mods-available/swoole.ini && \
    ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini



#####################################
# composer
#####################################
curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

composer global require "hirak/prestissimo"


__install_code_style()
{
    local BASE_DIR=/usr/local/lib/composer/code-style

    mkdir -p $BASE_DIR
    cd $BASE_DIR

    echo '{"config": {"preferred-install": "dist", "sort-packages": true, "optimize-autoloader": true}}' > composer.json
    composer require symplify/easy-coding-standard

    cd /usr/local/bin

    find "${BASE_DIR}/vendor/bin/" -type l -print -exec ln -b -s {} \;
}

__install_code_style

# rm -rf /home/workuser/.composer
rm -rf /root/.composer/cache
# mv /root/.composer /home/workuser/

# chown -R workuser:workuser /home/workuser/.composer

install_clean
# apt-get clean -qy
# rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
