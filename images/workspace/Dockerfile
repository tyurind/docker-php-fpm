#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM laradock/workspace:2.0-71


# Remove Faillog and Lastlog to reduce the size of the final image.
RUN rm /var/log/lastlog /var/log/faillog
RUN mkdir -p /var/www

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


COPY .      /bd_build
ADD ./bin /usr/sbin

#####################################
# Non-Root User:
#####################################
USER root
RUN add-apt-repository -y ppa:ondrej/php && \
    apt-get update -yqq && \
    apt-get install -y sudo lsb-release


# ARG PUID=1000
# ARG PGID=1000

# ENV PUID ${PUID}
# ENV PGID ${PGID}

RUN groupadd -g 1000 workuser && \
    useradd -u 1000 -g workuser -m workuser && \
    mkdir -p /home/workuser && \
    cp /bd_build/aliases.sh /home/workuser/aliases.sh && \
    touch  /home/workuser/.bashrc && \
    echo "" >> /home/workuser/.bashrc && \
    echo "# Load Custom Aliases" >> /home/workuser/.bashrc && \
    echo "source /home/workuser/aliases.sh" >> /home/workuser/.bashrc && \
    echo "" >> /home/workuser/.bashrc && \
    chown -R workuser:workuser /home/workuser

#####################################
# Set Timezone
#####################################

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Crontab
RUN rm -rf /etc/cron.d/*


#####################################
# ssh:
#####################################
ARG INSTALL_WORKSPACE_SSH=true
ENV INSTALL_WORKSPACE_SSH ${INSTALL_WORKSPACE_SSH}

ADD insecure_id_rsa /tmp/id_rsa
ADD insecure_id_rsa.pub /tmp/id_rsa.pub

RUN if [ ${INSTALL_WORKSPACE_SSH} = true ]; then \
    rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    && chmod 400 /root/.ssh/id_rsa \
#    && cp -rf /root/.ssh /home/laradock \
#    && chown -R laradock:laradock /home/laradock/.ssh \
;fi


#
#--------------------------------------------------------------------------
# PHP Installation
#--------------------------------------------------------------------------
#

#####################################
# SOAP:
#####################################
RUN apt-get -y install libxml2-dev php7.1-soap && \
    apt-get install -y libldap2-dev && \
    apt-get install -y php7.1-ldap  && \
    apt-get install -y php7.1-imap

#####################################
# xDebug:
#####################################
RUN pecl update-channels

RUN apt-get install -y php7.1-xdebug && \
    sed -i 's/^;//g' /etc/php/7.1/cli/conf.d/20-xdebug.ini
# ADD for REMOTE debugging
COPY ./xdebug.ini /etc/php/7.1/cli/conf.d/xdebug.ini


#####################################
# AMQP:
#####################################
RUN apt-get install librabbitmq-dev -y && \
    # Install the mongodb extension
    pecl -q install amqp && \
    echo "extension=amqp.so" >> /etc/php/7.1/mods-available/amqp.ini && \
    ln -s /etc/php/7.1/mods-available/amqp.ini /etc/php/7.1/cli/conf.d/30-amqp.ini

#####################################
# PHP REDIS EXTENSION FOR PHP 7.1
#####################################
RUN printf "\n" | pecl -q install -o -f redis && \
    echo "extension=redis.so" >> /etc/php/7.1/mods-available/redis.ini && \
    phpenmod redis

#####################################
# Swoole EXTENSION FOR PHP 7
#####################################
RUN pecl -q install swoole && \
    echo "extension=swoole.so" >> /etc/php/7.1/mods-available/swoole.ini && \
    ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini

RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

#####################################
# PYTHON:
#####################################
RUN apt-get -y install python python-pip python-dev build-essential  \
  && pip install --upgrade pip  \
  && pip install --upgrade virtualenv


#####################################
# pgsql client
#####################################
RUN curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update -yqq && \
    apt-get install -y postgresql-client

#####################################
# Dusk Dependencies:
#####################################
USER root
ARG CHROME_DRIVER_VERSION=2.32
ENV CHROME_DRIVER_VERSION ${CHROME_DRIVER_VERSION}
RUN add-apt-repository ppa:ondrej/php \
  && apt-get update \
  && apt-get -y install zip wget unzip xdg-utils \
    libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 xvfb \
    gtk2-engines-pixbuf xfonts-cyrillic xfonts-100dpi xfonts-75dpi \
    xfonts-base xfonts-scalable x11-apps \
  && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
  && apt-get -y -f install \
  && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb \
  && wget https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip \
  && mv chromedriver /usr/local/bin/ \
  && rm chromedriver_linux64.zip

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

# Set default work directory
WORKDIR /var/www
