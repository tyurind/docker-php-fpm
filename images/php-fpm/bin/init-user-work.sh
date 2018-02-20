#!/bin/sh

##
## Инициализация пользователя и его ID по умолчанию
##

USER_WORKER=${USER_WORKER-www-data}
PUID=${PUID-33}
PGID=${PGID-33}

## ID пользователя в системе
ID=$(id -u $USER_WORKER 2>/dev/null)

# echo "USER_WORKER: $USER_WORKER"
# echo "PUID: $PUID"
# echo "PGID: $PGID"
# echo "ID: $ID"

if [ -z "$ID" ]; then
    # если пользователя нет, то создадим
    adduser --system --shell /bin/bash --no-create-home --uid ${PUID} --disabled-password $USER_WORKER  2>/dev/null
else
    if [ "$PUID" != "33" ]; then
        # если пользователя уже есть, установим UID и GID из переменных окружения
        if [ $(id -u $USER_WORKER) != "${PUID}" ]; then
            usermod -u ${PUID} $USER_WORKER 2>/dev/null
        fi

        if [ $(id -g $USER_WORKER) != "${PGID}" ]; then
            groupmod -g ${PGID} $USER_WORKER 2>/dev/null
        fi
    fi
fi
