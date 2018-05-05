#
#--------------------------------------------------------------------------
# Image Setup
# $REF: $
#--------------------------------------------------------------------------
#
# https://docs.gitlab.com/ce/ci/README.html

ARG DOCKER_VERSION=stable
FROM docker:${DOCKER_VERSION}

#  207MB
RUN apk update && \
    apk add --no-cache py-pip git shadow bash su-exec sudo && \
    pip install --no-cache-dir docker-compose \
    # --
    && useradd --groups wheel --uid 1000 --user-group --create-home  dev \
    && sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers


LABEL \
  org.opencontainers.image.title="Docker Compose on docker base image" \
  org.opencontainers.image.workuser="dev"
