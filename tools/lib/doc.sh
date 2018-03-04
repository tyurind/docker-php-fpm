#!/bin/bash


DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
source "$DIR/read_ini.sh"

# DOCKER_RUN="docker run -u 1001 -v $PWD:/var/www -v /docker/php/fpm/conf/localetc:/usr/local/etc --entrypoint=bash miiix/php7fpm:miiix -c"

#ARGS=' -v --env=prod'
#ARGS='--env=prod'
# ARGS='--ansi'

# COMMAND=$@

#$DOCKER_RUN "$COMMAND $ARGS"
# $DOCKER_RUN "php bin/console $ARGS $COMMAND"
#############################




DOCKER_EXEC_CMD="docker exec"

# Grab OS type
if [[ "$(uname)" == "Darwin" ]]; then
    OS_TYPE="OSX"
else
    OS_TYPE=$(expr substr $(uname -s) 1 5)
fi

if [[ $OS_TYPE == "MINGW" ]]; then
    DOCKER_EXEC_CMD="winpty ${DOCKER_EXEC_CMD}"
fi


xdebug_status ()
{
    echo 'xDebug status'

    # If running on Windows, need to prepend with winpty :(
    if [[ $OS_TYPE == "MINGW" ]]; then
        winpty docker exec -it $PHP_FPM_CONTAINER bash -c 'php -v'

    else
        docker exec -it $PHP_FPM_CONTAINER bash -c 'php -v'
    fi
}


cd "$DIR"
read_ini ../../app/default.ini srv1
# echo $INI__ALL_VARS

export DOCKER_PORT_PREFIX=$INI__srv1__DOCKER_PORT_PREFIX
export COMPOSE_PROJECT_NAME=$INI__srv1__COMPOSE_PROJECT_NAME

env
