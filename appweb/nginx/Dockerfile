FROM nginx:alpine
# ----------------

ARG PUID=1000
ENV PUID ${PUID}

ADD nginx.conf /etc/nginx/
COPY proxy_params /etc/nginx/proxy_params

# Add a non-root user to prevent files being created with root permissions on host machine.
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash shadow \
    # && adduser -D -H -u ${PUID} -s /bin/bash www-data
    && adduser -D -H -u 1000 -s /bin/bash www-data \
    && usermod -u ${PUID} www-data >/dev/null 2>&1

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf


# RUN chown -R www-data:www-data /var/log/nginx

CMD ["nginx"]

EXPOSE 80 443
