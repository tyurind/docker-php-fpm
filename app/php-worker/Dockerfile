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

RUN apt-get update -yqq && \
    apt-get install -y \
        python-setuptools \
        supervisor
RUN apt-get autoremove -y

RUN usermod -u ${PUID} www-data

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

WORKDIR /etc/supervisor/conf.d/
