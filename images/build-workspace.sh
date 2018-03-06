#!/bin/bash
# set -e

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
# cd "$DIR"

cd "${DIR}/workspace"

# IMAGE_BASE_TAG="workspace:step"

docker build -f Dockerfile.system  -t "tmp/workspace:system" .
docker build -f Dockerfile.targets -t "tmp/workspace:php"    --target "build-php" .
docker build -f Dockerfile.targets -t "tmp/workspace:chrome" --target "build-chrome" .
docker build -f Dockerfile.targets -t "tmp/workspace:ssh"    --target "build-ssh" .


exit 0

# REF=$(git log -1 --pretty=format:%h)

# DOCKER_IMAGE_NAME="fobia/docker-php-fpm"
# DOCKER_IMAGE_TAG="71-${REF}"

# cd ./php-fpm

# echo "BUILD: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
# echo;

# docker build -t "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" .

# echo;
# echo;
# echo "BUILD COMPLETE : ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
# echo;
# echo;
# echo "PUSH HUB : ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
# echo;
# echo;

# docker push "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"

# echo;
# echo;
# echo "END PUSH HUB : ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
# echo;
# echo;



update-version()
{
    DOCKER_FILE=$1
    sed -i "s/^# \$REF: .*\$/# \$REF: `git log -1 --pretty="format:%h %cI"` \$/" $DOCKER_FILE
}

docker-build-php()
{
    cd "${DIR}/php-fpm"
    echo "BUILD: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
    echo;
    docker build -t "tmp/php-fpm:71-dev" -f Dockerfile .
    echo;
    echo;
    docker build -t "tmp/php-fpm:56-dev" -f Dockerfile56 .
}

docker-build-workspace()
{
    cd "${DIR}/workspace"
    echo "BUILD: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
    echo;
    docker build -t "tmp/workspace:71-dev" -f Dockerfile .
}

docker-build-dockerfile()
{
    DOCKER_FILE=$1
    DOCKER_TAG="${2}dev"

    DOCKER_IMAGE=$(basename $(dirname $DOCKER_FILE))

    cd "$(dirname $DOCKER_FILE)"
    sed -i "s/^# \$REF: .*\$/# \$REF: `git log -1 --pretty="format:%h %cI"` \$/" $DOCKER_FILE

    echo "BUILD : tmp/${DOCKER_IMAGE}:${DOCKER_TAG}"
    echo $DOCKER_FILE
    echo;

    docker build -t "tmp/${DOCKER_IMAGE}:${DOCKER_TAG}" -f "$(basename $DOCKER_FILE)" .

    sed -i "s/^# \$REF: .*\$/# \$REF: \$/" $DOCKER_FILE
    echo "Done"
}

docker-build-dockerfile "${DIR}/php-fpm/Dockerfile" "71-"
docker-build-dockerfile "${DIR}/php-fpm/Dockerfile56" "56-"
docker-build-dockerfile "${DIR}/workspace/Dockerfile" ""
