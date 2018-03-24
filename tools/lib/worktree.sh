#!/bin/bash


# Config
GIT_DIR=${GIT_DIR}                    # Репозиторий GIT
WORKTREE_DIR=${WORKTREE_DIR} # ".worktree"    # Директория дочерних проектов

##
## Arguments
##
BRANCH=$1


# git config worktrees.dir
# git config worktrees.copy
# git config worktrees.script



# redis-cli FLUSHALL

# git log -1 --pretty=format:'%h %D'
# Merge branch '329' into 'master'

# git merge -m "Merge branch '358' into 'master'" origin/358


# WORKTREE_DIR=".worktree/${BRANCH}"

# REF=$(git log -1 --pretty=format:%h)

##        # Обновляем удаленые ветки
##        git fetch origin
##
##        # Создаем отдельную директорию на ветку
##        git worktree add ".worktree/${BRANCH}" "origin/${BRANCH}"
##        # Скопируем папку с уже установлеными пакетами, чтоб быстрее прошла установка composer install
##        cp -r ./vendor "${WORKTREE_DIR}/"
##
##        cd $WORKTREE_DIR
##
##        composer install
##
##        # Генерируем параметры
##        cp ./.env.example ./.env
##        php artisan key:generate

docker_cmd()
{
    sudo docker $*
}

docker_exec_cmd()
{
    # Grab OS type
    if [[ "$(uname)" == "Darwin" ]]; then
        OS_TYPE="OSX"
    else
        OS_TYPE=$(expr substr $(uname -s) 1 5)
    fi

    # If running on Windows, need to prepend with winpty :(
    if [[ $OS_TYPE == "MINGW" ]]; then
        winpty docker exec $*
    else
        sudo docker exec $*
    fi
}

docker_compose_cmd()
{
    # Grab OS type
    if [[ "$(uname)" == "Darwin" ]]; then
        OS_TYPE="OSX"
    else
        OS_TYPE=$(expr substr $(uname -s) 1 5)
    fi

    # If running on Windows, need to prepend with winpty :(
    if [[ $OS_TYPE == "MINGW" ]]; then
        winpty docker-compose $*
    else
        sudo docker-compose $*
    fi
}

__dockerip()
{
    docker_cmd inspect -f '{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}} ' "$@"
}

__get_git_dir()
{
    local __repository_dir=$(__get_repository_dir)
    echo "${__repository_dir}/.git"
}

__get_repository_dir()
{
    local __repository_dir=$(git worktree list | head -n 1 | cut -d " " -f 1)
    if [[ "${__repository_dir}" == "" ]]; then
        exit 1
    fi
    echo ${__repository_dir}
}

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
        cd "$branch_project" && docker-compose down 2>/dev/null
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
}


show_ips()
{
    local branch_project=$(__get_worktree_dir $1)
    cd $branch_project

    docker-compose ps | tail --lines=+3 | cut -d " " -f 1 | while read i; do IPC=$(__dockerip $i | __trim | cut -d " " -f 1); echo "$i:$IPC"; done

    docker_cmd inspect -f '{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}} ' "$@"
}

#================================

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


# /srv/develop/docker-php-fpm/.git/worktrees/2cb2ff3
 # git config --get-regexp worktrees
 # git config --get-all worktrees.dir
