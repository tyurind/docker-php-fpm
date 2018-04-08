#
#--------------------------------------------------------------------------
# Image Setup
# $REF: $
#--------------------------------------------------------------------------
#
# https://docs.gitlab.com/ce/ci/README.html

FROM docker:stable

#  207MB
RUN apk update && \
    apk add --no-cache python py2-pip git bash su-exec && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir docker-compose
