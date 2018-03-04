#! /bin/bash

docker-rmi-grep()
{
    docker image ls | grep $* | awk '{print $3}' | while read i; do docker rmi -f $i; done
}

docker-kill-grep()
{
    docker ps | grep $* | awk '{print $1}' | while read i; do docker kill $i; done
}

docker-rm-grep()
{
    docker ps -a | grep $* | awk '{print $1}' | while read i; do docker rm -f $i; done
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
