#!/bin/bash


# Config
GIT_DIR=${GIT_DIR}                    # Репозиторий GIT
WORKTREE_DIR=${WORKTREE_DIR} # ".worktree"    # Директория дочерних проектов

##
## Arguments
##
BRANCH=$1


# /home/tyurin/Projects/wellmax/app


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


__get_git_dir()
{
    local __git_dir=$(git worktree list | head -n 1 | cut -d " " -f 1)
    if [[ "${__git_dir}" == "" ]]; then
        exit 1
    fi

    echo "${__git_dir}/.git"
}

__get_worktree_dir()
{
    local __git_dir=$(__get_git_dir)
    local __worktree_dir=$(git config worktrees.dir)

    if [[ "${__worktree_dir}" == "" ]]; then
        __worktree_dir="${__git_dir}/.worktrees_src"
    fi

    echo "${__worktree_dir}"
}

branch_init()
{
    cd $GIT_DIR
    # Обновляем удаленые ветки
    git fetch origin

    local ref=$(git log -1 --pretty=format:%h $1)
    local branch_project="${WORKTREE_DIR}/${ref}"



    # Создаем отдельную директорию на ветку
    git worktree add "${branch_project}" "origin/${ref}"
    # Скопируем папку с уже установлеными пакетами, чтоб быстрее прошла установка composer install
    cp -r ./vendor "${branch_project}/"

    cd $branch_project

    composer install

    # Генерируем параметры
    cp ./.env.example ./.env
    php artisan key:generate
}

branch_down()
{
    local BASE__WORKTREE_DIR="${WORKTREE_DIR}"
    if [[ "$BASE__WORKTREE_DIR" == "" ]]; then
        BASE__WORKTREE_DIR="`pwd`/.worktree"
        echo "Default WORKTREE_DIR: ${BASE__WORKTREE_DIR}"
    fi

    local ref=$(git log -1 --pretty=format:%h)
    local branch_project="${BASE__WORKTREE_DIR}/${ref}"

    if [[ -d "$branch_project" ]]; then
        cd "$branch_project" && docker-compose down 2>/dev/null
        cd "${branch_project}/.." && rm -rf "$branch_project"
    else
        echo "No branch worktree: $branch_project"
    fi
}


if [[ "$GIT_DIR" == "" ]]; then
    GIT_DIR=$(__get_git_dir)
fi
if [[ "$WORKTREE_DIR" == "" ]]; then
    WORKTREE_DIR=$(__get_worktree_dir)
fi


case $1 in
    init)
        # shift
        branch_init $2
        ;;
    down)
        branch_down $2
        ;;
    *)
        echo "Error Arguments"
        exit 1
esac
