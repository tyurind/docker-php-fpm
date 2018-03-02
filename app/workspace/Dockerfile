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

FROM laradock/workspace:latest

# Remove Faillog and Lastlog to reduce the size of the final image.
RUN rm -f /var/log/lastlog /var/log/faillog
ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}


USER root
RUN if id laradock >/dev/null 2>&1; then \
    echo "laradock user exists" && \
	usermod -u ${PUID} -g ${PGID} laradock >/dev/null 2>&1 \
;else \
	groupadd -g ${PGID} laradock && \
	useradd -u ${PUID} -g laradock -m laradock \
    mkdir -p /home/laradock && chown -R laradock:laradock /home/laradock \
;fi

## NEW CODE
RUN passwd -d laradock
COPY ./ssh_config /etc/ssh/ssh_config
COPY ./sshd_config /etc/ssh/sshd_config
RUN cp -r /root/.ssh /home/laradock/.ssh && \
    chown -R laradock:laradock /home/laradock/.ssh
#####################################

# COPY ./crontab /etc/cron.d
# RUN chmod -R 644 /etc/cron.d
RUN rm -rf /etc/cron.d/crontab

RUN composer self-update
COPY ./composer.json /home/laradock/composer.json


USER laradock
RUN composer global update

# Clean up
USER root

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default work directory
WORKDIR /var/www

