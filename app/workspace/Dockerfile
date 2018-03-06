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

FROM fobia/php-fpm:workspace-dev
USER root

ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

# Remove Faillog and Lastlog to reduce the size of the final image.
RUN rm -f /var/log/lastlog /var/log/faillog

RUN /usr/sbin/init-user-work.sh workuser 2>/dev/null && \
    chown -R workuser:workuser /home/workuser/
# RUN passwd -d laradock

# Clean up
RUN /usr/sbin/install_clean
# Set default work directory
WORKDIR /var/www

USER workuser
CMD ["sudo", "/sbin/my_init"]
