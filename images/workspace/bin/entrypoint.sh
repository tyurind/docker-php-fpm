#!/bin/sh
set -e

if [ ! -e /etc/workuser.lock ]; then
    sudo /usr/sbin/init-user-work.sh workuser >/dev/null 2>&1
    id -n workuser > sudo tee /etc/workuser.lock > /dev/null
fi

exec "$@"
