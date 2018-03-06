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

    #SET_PUID=${USERUID%%:*}
    #SET_PGID=${USERUID##*:}
    SET_PUID=$(echo ":${USERUID}" | cut -d ":" -f 2)
    SET_PGID=$(echo ":${USERUID}" | cut -d ":" -f 3)

    if [ "$3" != "" ]; then
        SET_PGID=$3
    fi
    SET_PGID=${SET_PGID-:$PGID}


    if [ "$SET_PUID" = "" ]; then SET_PUID=0; fi
    if [ "$SET_PGID" = "" ]; then SET_PGID=0; fi

    if [ "$(which usermod)" != "" ]; then
        if [ "$SET_PUID" -gt  "1" ]; then
            if [ $(id -u $USER_WORKER) != "${SET_PUID}" ]; then
                usermod -u ${SET_PUID} $USER_WORKER 2>/dev/null
                id -u workuser > /etc/workuser.lock
            fi
        fi
    fi

    if [ "$(which groupmod)" != "" ]; then
        if [ "$SET_PGID" -gt  "1" ]; then
            if [ $(id -g $USER_WORKER) != "${SET_PGID}" ]; then
                groupmod -g ${SET_PGID} $USER_WORKER 2>/dev/null
            fi
        fi
    fi
}

workusermod $*
exit 0
