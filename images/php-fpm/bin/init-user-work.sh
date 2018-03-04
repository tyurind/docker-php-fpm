#!/bin/sh

##
## Инициализация пользователя и его ID по умолчанию
##

# Version 2
# workusermod <LOGIN> <PUID> [PGUID]

workusermod()
{
    # Usage:
    #    workusermod <LOGIN>
    #    workusermod <LOGIN> <PUID>
    #    workusermod <LOGIN> <PUID:PGID>
    #    workusermod <LOGIN> <PUID> <PGID>
    if [ "$1" = "" ]; then
        echo "Invalid arguments"
        echo "Usage: workusermod <LOGIN> [<PUID:PGID>]"
        return;
    fi

    USER_WORKER=$1
    USER_NAME=$(id -un $USER_WORKER 2>/dev/null)
    if [ "$USER_NAME" = "" ]; then
        echo "Invalid user: $USER_WORKER"
        return;
        # exit 1;
    fi

    USERUID=${2:-$PUID}

    SET_PUID=${USERUID%%:*}
    SET_PGID=${USERUID##*:}

    if [ "$3" != "" ]; then
        SET_PGID=$3
    fi
    SET_PGID=${SET_PGID-:$PGID}

    if [ "$SET_PUID" -gt  "1" ]; then
        if [ $(id -u $USER_WORKER) != "${SET_PUID}" ]; then
            usermod -u ${SET_PUID} $USER_WORKER 2>/dev/null
        fi
    fi


    if [ "$SET_PGID" -gt  "1" ]; then
        if [ $(id -g $USER_WORKER) != "${SET_PGID}" ]; then
            groupmod -g ${SET_PGID} $USER_WORKER 2>/dev/null
        fi
    fi
}

workusermod $*
exit 0

#########################################
#########################################
#########################################
# Old version
#########################################

USER_WORKER=${USER_WORKER-www-data}
PUID=${PUID-33}
PGID=${PGID-33}

## ID пользователя в системе
ID=$(id -u $USER_WORKER 2>/dev/null)

# echo "USER_WORKER: $USER_WORKER"
# echo "PUID: $PUID"
# echo "PGID: $PGID"
# echo "ID: $ID"

# Меньше чем пользовательский ID
# if [ "$PUID" -lt  "1000" ]; then
    # exit 0
# else

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
#============================================
