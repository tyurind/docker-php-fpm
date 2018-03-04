#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
FROM fobia/php-fpm:latest${IMAGE_TAG}


ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

RUN install_clean python-setuptools supervisor

RUN usermod -u ${PUID} www-data
# RUN /usr/sbin/init-user-work.sh www-data 2>/dev/null

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

WORKDIR /etc/supervisor/conf.d/
