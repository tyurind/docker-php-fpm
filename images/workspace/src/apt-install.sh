#!/bin/bash

add-apt-repository -y ppa:ondrej/php

apt-get update -yqq

apt-get install -qy \
            sudo \
            lsb-release \
            mc \
            iputils-ping \
            net-tools


TZ=${TZ-UTC}
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#####################################
# PYTHON:
#####################################
apt-get -qy install python python-pip python-dev build-essential  \
  && pip install --upgrade pip  \
  && pip install --upgrade virtualenv


#####################################
# pgsql client
#####################################
curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update -yqq && \
    apt-get install -yq postgresql-client

apt-get clean -qy
rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
