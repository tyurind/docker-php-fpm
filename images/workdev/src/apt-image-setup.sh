
# FROM phusion/baseimage:latest

# MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>

# DEBIAN_FRONTEND=noninteractive
# locale-gen en_US.UTF-8

# ENV LANGUAGE=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8
# ENV LC_CTYPE=en_US.UTF-8
# ENV LANG=en_US.UTF-8
# ENV TERM xterm

# Add the "PHP 7" ppa
apt-get install -qy software-properties-common && \
    add-apt-repository -y ppa:ondrej/php

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#

install_clean --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        php7.1-cli \
        php7.1-common \
        php7.1-curl \
        php7.1-intl \
        php7.1-json \
        php7.1-xml \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-mysql \
        php7.1-pgsql \
        php7.1-sqlite \
        php7.1-sqlite3 \
        php7.1-zip \
        php7.1-bcmath \
        php7.1-memcached \
        php7.1-gd \
        php7.1-dev \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3 \
        git \
        curl \
        vim \
        nano
