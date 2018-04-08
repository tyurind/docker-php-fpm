#
#--------------------------------------------------------------------------
# Image Setup
# $REF: $
#--------------------------------------------------------------------------
#

# FROM node:9.10
# FROM node:alpine
FROM node:9.11-alpine

ENV WORKUSER node

ADD run-as-user /usr/sbin
ADD setuser     /usr/sbin
ADD su-node     /usr/sbin

USER root
WORKDIR /root

RUN apk update \
    && apk add --no-cache bash shadow sudo su-exec \
                 curl nano wget

RUN npm i -g gulp-cli yarn bower \
    && npm i -g cross-env   \
    && chmod +x /usr/local/lib/node_modules/yarn/bin/yarn.js \
    && rm -rf /root/.npm    \
    && echo "cache=/tmp/.npm" >> .npmrc \
    && echo "prefix=/tmp" >> .npmrc     \
    && chmod +x /sbin/su-node


# RUN npm i node-sass      \
#      && mv node_modules/node-sass /usr/local/lib/node_modules/   \
#      && cd /usr/local/lib/node_modules/node-sass && npm i        \
#      && cd /usr/local/bin/ && ln -s ../lib/node_modules/node-sass/bin/node-sass  \
#      && rm -rf /root/package* /root/.npm /root/node_modules


VOLUME /var/www

EXPOSE 3000

WORKDIR /var/www

CMD ["tail", "-f", "/dev/null"]


