#!/bin/bash

function help_long()
{
        cat <<EOF
Init docker compose configuration.

USAGE:
docker-app-init <GIT_DIR> <DOCKER_APP_DIR>

    GIT_DIR           local path project or url git repository
    DOCKER_APP_DIR    storage docker images

EOF

        return
}


D_UID=$(id -u)
D_GID=$(id -g)

echo "D_UID: $D_UID"
echo "D_GID: $D_GID"
echo "SUDO_UID: $SUDO_UID"
echo "SUDO_GID: $SUDO_GID"

# PUID=${PUID-33}
# PGID=${PGID-33}

# env | grep SUDO
#

# SUDO_GID=1000
# SUDO_COMMAND=/bin/bash init.sh
# SUDO_USER=tyurin
# SUDO_UID=1000

# $GIT_DIR

# I_UID=${SUDO_UID-$D_UID}
# I_GID=${SUDO_GID-$D_GID}

I_UID=${SUDO_UID-`id -u`}
I_GID=${SUDO_GID-`id -g`}

USERWORK="${I_UID}:${I_GID}"

echo $USERWORK
#  -----------------


# user: ${WUSERID%%:*}
# group: ${WUSERID##*:}

#########################################
APPDOCK_USER_CONFIG="~/.local/appdock/config"

mkdir -p ~/.local/appdock/data
echo "" >> $APPDOCK_USER_CONFIG

echo "PUID=1000" >> $APPDOCK_USER_CONFIG
echo "PGID=1000" >> $APPDOCK_USER_CONFIG
echo "DOCKER_HOST_IP=10.0.75.1" >> $APPDOCK_USER_CONFIG
echo "DOCKER_PORT_PREFIX=18" >> $APPDOCK_USER_CONFIG
echo "DOCKER_PHP_IDE_CONFIG=serverName=laradock" >> $APPDOCK_USER_CONFIG
echo "COMPOSER_HOME=./storage/composer" >> $APPDOCK_USER_CONFIG
echo "COMPOSE_PATH_SEPARATOR=:" >> $APPDOCK_USER_CONFIG
echo "COMPOSE_FILE=docker-compose.services.yml:_compose/ports.yml" >> $APPDOCK_USER_CONFIG

# DOCKER_APPLICATION=.
# DATA_SAVE_PATH=./.laradock/data

wget -O /tmp/baseimage-docker.zip https://github.com/phusion/baseimage-docker/archive/master.zip && \
unzip -q -o /tmp/baseimage-docker.zip -d /tmp/ && \
bash /tmp/baseimage-docker-master/install-tools.sh && \
rm -rf /tmp/baseimage-docker.zip /tmp/baseimage-docker-master
