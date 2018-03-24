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


curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update -yqq && \
    apt-get install -y postgresql-client
