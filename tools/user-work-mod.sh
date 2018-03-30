#!/bin/sh

##    usermod
##    -------

##
## Инициализация пользователя и его ID по умолчанию
##

ARGS=1
if [ $# -lt "$ARGS" ]
then
    # echo "Usage: `basename $0` <user> [uid] [gid]"
    echo "Usage: `basename $0` <WUSERID> [gid] [workuser]"
    echo "    WUSERID <string>     format: <uid>[:<gid>]"
    echo;
    exit 1;
fi

USER=$1
USER_UID=$2
USER_GID=$3

USER_NAME=$(id -un $USER 2>/dev/null)
if [ "$USER_NAME" = "" ]; then
    echo "Invalid user: $USER"
    echo;
    exit 1;
fi


SUID=${USER_UID:-$PUID}
SGID=${USER_GID:-$PGID}


# SET_PUID=${USERID%%:*}
# SET_PGID=${USERID%%:*}
# group: ${USERID##*:}

echo "
User name: $USER_NAME

PUID: $PUID
PGID: $PGID

User uid: $SUID
User gid: $SGID

"


# RUN useradd seluser \
         # --shell /bin/bash  \
         # --create-home \
  # && usermod -a -G sudo seluser \
  # && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  # && echo 'seluser:secret' | chpasswd

# USER_WORKER=${USER_WORKER-www-data}
# PUID=${PUID-33}
# PGID=${PGID-33}

# ## ID пользователя в системе
# ID=$(id -u $USER_WORKER 2>/dev/null)

# # echo "USER_WORKER: $USER_WORKER"
# # echo "PUID: $PUID"
# # echo "PGID: $PGID"
# # echo "ID: $ID"

# # Меньше чем пользовательский ID
# # if [ "$PUID" -lt  "1000" ]; then
#     # exit 0
# # else

# if [ -z "$ID" ]; then
#     # если пользователя нет, то создадим
#     adduser --system --shell /bin/bash --no-create-home --uid ${PUID} --disabled-password $USER_WORKER  2>/dev/null
# else
#     if [ "$PUID" != "33" ]; then
#         # если пользователя уже есть, установим UID и GID из переменных окружения
#         if [ $(id -u $USER_WORKER) != "${PUID}" ]; then
#             usermod -u ${PUID} $USER_WORKER 2>/dev/null
#         fi

#         if [ $(id -g $USER_WORKER) != "${PGID}" ]; then
#             groupmod -g ${PGID} $USER_WORKER 2>/dev/null
#         fi
#     fi
# fi

USER_WORKER=${USER_WORKER-www-data}
if [ "$1" != "" ]; then
  USER_WORKER=$1
fi

ID=$(id -u $USER_WORKER 2>/dev/null)
if [ -z "$ID" ]; then
  # пользователя нет, то создадим
  # adduser --system --shell /bin/bash --no-create-home --uid ${PUID} --disabled-password $USER_WORKER  2>/dev/null
  echo "Invalid user: $USER_WORKER"
  echo;
  exit 1;
else

PUID=${PUID-33}
PGID=${PGID-33}
#     if [ "$PUID" != "33" ]; then
#         # если пользователя уже есть, установим UID и GID из переменных окружения
#         if [ $(id -u $USER_WORKER) != "${PUID}" ]; then
#             usermod -u ${PUID} $USER_WORKER 2>/dev/null
#         fi

#         if [ $(id -g $USER_WORKER) != "${PGID}" ]; then
#             groupmod -g ${PGID} $USER_WORKER 2>/dev/null
#         fi
#     fi


ls -land .git | cut -d " " -f 3

_usermod_by_dir()
{
  local user_dir="$1/.git"
  local USER_WORKER="$2"

  local user_id=$(ls -land $user_dir | cut -d " " -f 3)
  local group_id=$(ls -land $user_dir | cut -d " " -f 4)

  usermod -o -u ${user_id} $USER_WORKER 2>/dev/null
  usermod -o -g ${group_id} $USER_WORKER 2>/dev/null
}
