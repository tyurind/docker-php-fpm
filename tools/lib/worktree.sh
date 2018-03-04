#!/bin/bash


# Config
GIT_DIR=
WORKTREE_DIR=".worktree"
WORKTREE_MASTER_DIR="${WORKTREE_DIR}/master"

##
## Arguments
##
BRANCH=$1
WORKTREE_DIR=".worktree/${BRANCH}"

# REF=$(git log -1 --pretty=format:%h)

# Обновляем удаленые ветки
git fetch origin

# Создаем отдельную директорию на ветку
git worktree add ".worktree/${BRANCH}" "origin/${BRANCH}"
# Скопируем папку с уже установлеными пакетами, чтоб быстрее прошла установка composer install
cp -r ./vendor "${WORKTREE_DIR}/"

cd $WORKTREE_DIR

composer install

# Генерируем параметры
cp ./.env.example ./.env
php artisan key:generate



# redis-cli FLUSHALL

# git log -1 --pretty=format:'%h %D'
# Merge branch '329' into 'master'

# git merge -m "Merge branch '358' into 'master'" origin/358

