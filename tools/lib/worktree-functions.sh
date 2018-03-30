#!/bin/bash


# worktrees.dir
# worktrees.copy
# worktrees.script
# worktrees.afterscript
# worktrees.beforescript


# /srv/develop/docker-php-fpm/.git/worktrees/2cb2ff3
 # git config --get-regexp worktrees
 # git config --get-all worktrees.dir


# prints colored text
print_style () {

    if [ "$2" == "info" ] ; then
        COLOR="96m"
    elif [ "$2" == "success" ] ; then
        COLOR="92m"
    elif [ "$2" == "warning" ] ; then
        COLOR="93m"
    elif [ "$2" == "danger" ] ; then
        COLOR="91m"
    else #default color
        COLOR="0m"
    fi

    STARTCOLOR="\e[$COLOR"
    ENDCOLOR="\e[0m"

    printf "$STARTCOLOR%b$ENDCOLOR" "$1"
}

display_options () {
    printf "Available options:\n";
}

# Return config value
#
# Usage:
#
#     __get_config <KEY>
#
#     __get_config worktree.dir
#     __get_config worktree.copy
#
__get_config()
{
    if [[ $# == 0 ]]; then
        echo "Invalid arguments: __get_config <key> "
        echo $*
        exit 1
    fi

    local __worktree_config="$(__get_repository_dir)/.worktreeconfig"
    local __config_key=$1
    local __config_value=$(git config "${__config_key}")

    if [[ -r "${__worktree_config}" ]] && [[ "${__config_value}" == "" ]]; then
        __config_value=$(git config --file "${__worktree_config}" "${__config_key}")
    fi

    echo ${__config_value}
}

# get repository dir
#
# Usage:
#
#     __get_repository_dir
#
__get_repository_dir()
{
    local __repository_dir=$(git worktree list | head -n 1 | cut -d " " -f 1)
    if [[ "${__repository_dir}" == "" ]]; then
        exit 1
    fi
    echo ${__repository_dir}
}


# Директория GIT_DIR
#
# Usage:
#
#     __get_git_dir
#
__get_git_dir()
{
    local __repository_dir=$(__get_repository_dir)
    echo "${__repository_dir}/.git"
}


# Директория дочерних сборок
#
# Usage:
#
#     __get_worktree_dir <BRANCH|REF>
#
__get_worktree_dir()
{
    local __repository_dir=$(__get_repository_dir)
    local __worktree_dir=$(git config worktrees.dir)

    if [[ "${__worktree_dir}" == "" ]]; then
        __worktree_dir="${__repository_dir}/.git/worktrees_src"
        if [[ ! -d "${__worktree_dir}" ]]; then
            mkdir -p "${__worktree_dir}"
        fi
    fi

    if [[ "$1" != "" ]]; then
        local ref=$(git log -1 --pretty=format:%h $1)
        __worktree_dir="${__worktree_dir}/${ref}"
    fi

    echo "${__worktree_dir}"
}



# Директория дочерних сборок
#
# Usage:
#
#     __trim " asd "            # Output: "asd"
#     echo " asd " | __trim     # Output: "asd"
#
__trim()
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

__docker_cmd()
{
    local run__docker_cmd="docker"
    local ARGS="$*"

    if [[ $ARGS =~ "docker" && $ARGS =~ "exec" ]]; then
        echo "bash"
    fi
    docker
}


docker_cmd()
{
    # Grab OS type
    if [[ "$(uname)" == "Darwin" ]]; then
        OS_TYPE="OSX"
    else
        OS_TYPE=$(expr substr $(uname -s) 1 5)
    fi

    local run__docker_cmd="docker"
    local ARGS="$*"

    # If running on Windows, need to prepend with winpty :(
    if [[ $OS_TYPE == "MINGW" ]]; then
        if [[ $ARGS =~ "exec" ]]; then
            run__docker_cmd="winpty docker"
        fi
    else
        run__docker_cmd="sudo docker"
    fi

    $run__docker_cmd $*
}


docker_compose_cmd()
{
    # Grab OS type
    if [[ "$(uname)" == "Darwin" ]]; then
        OS_TYPE="OSX"
    else
        OS_TYPE=$(expr substr $(uname -s) 1 5)
    fi

    local run__docker_cmd="docker"
    local ARGS="$*"

    # If running on Windows, need to prepend with winpty :(
    if [[ $OS_TYPE == "MINGW" ]]; then
        if [[ $ARGS =~ "exec" ]]; then
            run__docker_cmd="winpty docker-compose"
        fi
    else
        run__docker_cmd="sudo docker-compose"
    fi

    $run__docker_cmd $*
}

__dockerip()
{
    docker_cmd inspect -f '{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}} ' "$@"
}


branch_init()
{
    local __repository_dir=$(__get_repository_dir)
    local __worktree_dir=$(__get_worktree_dir)

    cd "${__repository_dir}"

    # Обновляем удаленые ветки
    git fetch origin

    local ref=$(git log -1 --pretty=format:%h $1)
    local branch_project="${__worktree_dir}/${ref}"

    if [[ -d "${branch_project}" ]]; then
        echo "Директория уже существует: ${branch_project}"
        exit 1
    fi

    # Создаем отдельную директорию на ветку
    git worktree add "${branch_project}" "${ref}"

    echo "Init: ${branch_project}"
    # Скопируем папку с уже установлеными пакетами, чтоб быстрее прошла установка composer install
    # cp -r ./vendor "${branch_project}/"

    local run_copy=$(git config worktrees.copy)
    if [[ "$run_copy" != "" ]]; then
        echo;

        for i in $run_copy; do
            if [[ ! -e "$i" ]]; then
                continue
            fi

            local copy_dest="${branch_project}/${i}"
            local copy_dest_dir=$(dirname "${copy_dest}")
            echo "Copy: ${i} => ${copy_dest}"

            # if [[ -d "$i" ]]; then
                # copy_dest_dir=$copy_dest
            # elif [[ -f "$i" ]]; then
                # copy_dest_dir=$(dirname "${copy_dest}")
            # fi

            # echo "Copy: ${i}"
            mkdir -p  "${copy_dest_dir}"
            cp -r $i "${copy_dest}"
        done
    fi

    cd $branch_project

    # Выполняем скрипты
    local run_script=$(git config worktrees.script)

    # composer install
    # cp ./.env.example ./.env
    # php artisan key:generate
    if [[ "$run_script" != "" ]]; then
        echo;

        echo "Run:  ${run_script}"
        run_script="$run_script 2>&1"
        eval "${run_script}"
    fi
}

branch_down()
{
    local __worktree_dir=$(__get_worktree_dir)
    local ref=$(git log -1 --pretty=format:%h)
    local branch_project="${__worktree_dir}/${ref}"


    if [[ -d "$branch_project" ]]; then
        cd "$branch_project" && docker-compose down --rmi local -v 2>/dev/null
    else
        echo "No branch worktree: $branch_project"
        return
    fi

    local __worktrees=$(cut -d " " -f 2 "${branch_project}/.git")
    cd ${__worktree_dir} \
        && echo "Remove: ${branch_project}" && rm -rf "${branch_project}" \
        && echo "Remove: ${__worktrees}" && rm -rf "${__worktrees}" \
        && echo "ok"
}


branch_config()
{
    git config --get-regexp worktrees
    echo;
    echo;
    echo;
    __get_config $*
}


show_ips()
{
    local branch_project=$(__get_worktree_dir $1)
    cd $branch_project

    docker-compose ps | tail --lines=+3 | cut -d " " -f 1 | while read i; do
        local __docker_ip=$(docker_cmd inspect -f '{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}} ' "$i")
        IPC=$(__trim "${__docker_ip}" | cut -d " " -f 1)
        if [[ "$IPC" != "" ]]; then
            echo "$i: $IPC";
        fi
    done
}

#================================

if [[ "$0" = '-bash' || "$0" = 'bash' || "$0" = 'sh' ]]; then
    if [ "$(which git) 2>/dev/null" = "" ] && [ "$(which docker) 2>/dev/null" != "" ] && [ "$(which docker-compose) 2>/dev/null" != "" ]; then
        __INIT__WORKTREE_FUNCTIONS=true
    else
        echo "Error init functions"
    fi
else
    case $1 in
        init)
            # shift
            branch_init $2
            ;;
        down)
            branch_down $2
            ;;
        config)
            branch_config $2
            ;;
        *)
            echo "Error Arguments"
            exit 1
    esac
fi
# if [[ ]]
