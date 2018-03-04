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

FROM fobia/php-fpm:71-work-dev

# Remove Faillog and Lastlog to reduce the size of the final image.
RUN rm -f /var/log/lastlog /var/log/faillog

ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

RUN /usr/sbin/enable_insecure_key
RUN /usr/sbin/init-user-work.sh www-data 2>/dev/null

## NEW CODE
# RUN passwd -d laradock
# COPY ./ssh_config /etc/ssh/ssh_config
# COPY ./sshd_config /etc/ssh/sshd_config
# RUN cp -r /root/.ssh /home/laradock/.ssh && \
#     chown -R laradock:laradock /home/laradock/.ssh
#####################################


# Clean up
RUN apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*


# Set default work directory
WORKDIR /var/www

