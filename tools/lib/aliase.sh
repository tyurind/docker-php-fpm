#! /bin/bash

docker-rmi-grep()
{
    docker image ls | tail -n +2 | grep $* | awk '{print $3}' | while read i; do docker rmi -f $i; done
}

docker-kill-grep()
{
    docker ps | tail -n +2 | grep $* | awk '{print $1}' | while read i; do docker kill $i; done
}

docker-rm-grep()
{
    docker ps -a | tail -n +2 | grep $* | awk '{print $1}' | while read i; do docker rm -f $i; done
}

dockerip ()
{
    docker inspect -f '{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}} ' "$@"
}

dockerips ()
{
    for dock in $(docker ps|tail -n +2|cut -d" " -f1);
    do
        local dock_ip=$(dockerip $dock);
        regex="s/$dock\s\{4\}/${dock:0:4}  ${dock_ip:-local.host}/g;$regex";
    done;
    docker ps -a | sed -e "$regex"
}


is_windows()
{
    # Grab OS type
    if [[ "$(uname)" == "Darwin" ]]; then
        OS_TYPE="OSX"
    else
        OS_TYPE=$(expr substr $(uname -s) 1 5)
    fi

    # If running on Windows, need to prepend with winpty :(
    if [[ $OS_TYPE == "MINGW" ]]; then
        winpty docker exec -it $PHP_FPM_CONTAINER bash -c 'php -v'
    else
        docker exec -it $PHP_FPM_CONTAINER bash -c 'php -v'
    fi
}

# dockerip appdocker_nginx_1 | sed 's/\s\+/\n/g' | sed '/^$/d'

trim()
{
    if [[ $# = 0 ]]; then
        while read i; do
            trim $i
            echo;
        done
        return
    fi

    local var="$*"
    local var0=""

    # remove leading whitespace characters
    var0="${var%%[![:space:]]*}"
    var="${var#$var0}"

    # remove trailing whitespace characters
    var0="${var##*[![:space:]]}"
    var="${var%$var0}"
    echo -n "$var"
}
# dockerip appdocker_nginx_1 | trim | cut -d " " -f 1
# docker-compose ps | tail --lines=+3 | cut -d " " -f 1 | while read i; do IPC=$(dockerip $i | trim | cut -d " " -f 1); echo "$i:$IPC"; done
