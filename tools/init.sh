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



