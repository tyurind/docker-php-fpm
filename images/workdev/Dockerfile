#
#--------------------------------------------------------------------------
# Image Setup
# $REF: $
#--------------------------------------------------------------------------
#
# To edit the 'workspace' base Image, visit its repository on Github
#    https://github.com/Laradock/workspace
#
# Базовый контейне
#   See: https://github.com/phusion/baseimage-docker
#
# FROM laradock/workspace
#   See: https://github.com/laradock/workspace/blob/master/Dockerfile-71
#
# FROM laradock/workspace:2.0-71
FROM phusion/baseimage:latest

RUN rm -rf /var/log/lastlog /var/log/faillog

RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

ADD  ./bin             /usr/sbin

#
#--------------------------------------------------------------------------
# Mandatory Software's Installation
#--------------------------------------------------------------------------
#
# Mandatory Software's such as ("php7.1-cli", "git", "vim", ....) are
# installed on the base image 'laradock/workspace' image. If you want
# to add more Software's or remove existing one, you need to edit the
# base image (https://github.com/Laradock/workspace).
#

#####################################
# Non-Root User:
#####################################
USER root

ARG TZ=UTC

ENV TZ ${TZ}

COPY ./src/apt-image-setup.sh  /usr/local/etc/src/apt-image-setup.sh
RUN bash /usr/local/etc/src/apt-image-setup.sh

COPY ./src/apt-install.sh  /usr/local/etc/src/apt-install.sh
RUN bash /usr/local/etc/src/apt-install.sh
# RUN bash /usr/local/etc/src/useradd.sh


#
#--------------------------------------------------------------------------
# PHP Installation
#--------------------------------------------------------------------------
#
COPY ./laravel.ini /etc/php/7.1/cli/conf.d/50-laravel.ini
COPY ./src/php.sh  /usr/local/etc/src/php.sh
RUN bash /usr/local/etc/src/php.sh
## -----------------------------------


#####################################
# ssh:
#####################################

# ARG INSTALL_WORKSPACE_SSH=true
# ENV INSTALL_WORKSPACE_SSH ${INSTALL_WORKSPACE_SSH}

ADD insecure_id_rsa     /tmp/id_rsa
ADD insecure_id_rsa.pub /tmp/id_rsa.pub

COPY ./src/ssh.sh  /usr/local/etc/src/ssh.sh
RUN bash /usr/local/etc/src/ssh.sh
## -----------------------------------


#####################################
# Dusk Dependencies:
#####################################

COPY ./src/dusk.sh  /usr/local/etc/src/dusk.sh

#ARG CHROME_DRIVER_VERSION=2.32
#ENV CHROME_DRIVER_VERSION ${CHROME_DRIVER_VERSION}

# RUN bash /usr/local/etc/src/dusk.sh
## -----------------------------------


#####################################
# Node / NVM:
#####################################
COPY ./src/node.sh  /usr/local/etc/src/node.sh
RUN bash /usr/local/etc/src/node.sh


#####################################
# useradd:
#####################################

ENV WORKUSER workuser
ENV PUID 1000
ENV PGID 1000

COPY ./aliases.sh      /etc/aliases.sh
RUN cp /etc/aliases.sh /root/.bash_aliases

COPY ./src/useradd.sh  /usr/local/etc/src/useradd.sh
RUN bash /usr/local/etc/src/useradd.sh

COPY ./src/init-work.sh  /usr/local/etc/src/init-work.sh
RUN mkdir -p /etc/my_init.d && \
    chmod +x /usr/local/etc/src/init-work.sh && \
    ln -s /usr/local/etc/src/init-work.sh /etc/my_init.d/15-init-work.sh
## -----------------------------------


COPY ./Dockerfile      /etc/Dockerfile
COPY ./README.md       /etc/README.md

ENV PATH vendor/bin:/var/www:/var/www/vendor/bin:$PATH

RUN install_clean

# Set default work directory
WORKDIR /var/www

CMD ["sudo", "/sbin/my_init"]
