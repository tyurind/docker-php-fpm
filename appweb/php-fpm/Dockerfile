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

FROM fobia/php-fpm:71

ARG PUID=0
ARG PGID=0

ENV PUID ${PUID}
ENV PGID ${PGID}

RUN if [ -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ]; then \
    sed -i 's/^;//' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
;fi

RUN if [ -n "${PUID}" ] && [ "${PUID%:*}" != 0 ]; then \
  usermod -u ${PUID} www-data >/dev/null 2>&1 \
;fi

# RUN usermod -u ${PUID} www-data >/dev/null 2>&1
# RUN groupmod -g ${PGID} www-data >/dev/null 2>&1

RUN install_clean supervisor cron

COPY supervisord.conf /etc/supervisord.conf
COPY ./crontab/www-data /etc/cron.d/www-data
RUN chmod -R 644 /etc/cron.d/www-data

# RUN echo "" > /etc/profile.d/histdisable.sh \
#     && echo "export HISTFILESIZE=0" >> /etc/profile.d/histdisable.sh \
#     && echo "export HISTSIZE=0" >> /etc/profile.d/histdisable.sh \
#     && echo "export unset HISTFILE" >> /etc/profile.d/histdisable.sh \
#     && echo "" >> /etc/profile.d/histdisable.sh

ENV HISTFILE=/tmp/.bash_history

USER www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
