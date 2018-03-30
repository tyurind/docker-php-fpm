#!/bin/sh
set -e

INIT_CMD="/srv/develop/docker-php-fpm/images/workspace/bin/init-user-work.sh"

if [ ! -e /etc/workuser.lock -a -x $INIT_CMD ]; then
    echo $INIT_CMD
    sudo $INIT_CMD workuser >/dev/null 2>&1
    id -n workuser > sudo tee /etc/workuser.lock
fi

exec "$@"
