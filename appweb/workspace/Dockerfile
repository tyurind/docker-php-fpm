#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
# To edit the 'workspace' base Image, visit its repository on Github
#    https://github.com/Laradock/workspace
#
# To change its version, see the available Tags on the Docker Hub:
#    https://hub.docker.com/r/laradock/workspace/tags/
#
# Note: Base Image name format {image-tag}-{php-version}
#

FROM fobia/php-fpm:workspace
USER root

ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

RUN usermod -u ${PUID} workuser >/dev/null 2>&1
RUN groupmod -g ${PGID} workuser >/dev/null 2>&1


WORKDIR /var/www

USER workuser
CMD ["sudo", "/sbin/my_init"]
