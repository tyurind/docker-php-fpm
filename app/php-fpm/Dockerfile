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

# FROM gitlab.dev-ifc.com:4567/wellmax/app-image-for-build/images/php-fpm:develop
FROM fobia/php-fpm:latest${IMAGE_TAG}

ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

RUN if [ -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ]; then \
    sed -i 's/^;//' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
;fi

RUN usermod -u ${PUID} www-data >/dev/null 2>&1
RUN groupmod -g ${PGID} www-data >/dev/null 2>&1
# RUN /usr/sbin/init-user-work.sh www-data 2>/dev/null

USER www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
