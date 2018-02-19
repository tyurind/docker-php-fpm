#!/bin/bash



REF=$(git log -1 --pretty=format:%h)

DOCKER_IMAGE_NAME="fobia/docker-php-fpm"
DOCKER_IMAGE_TAG="71-${REF}"

cd ./php-fpm

echo "BUILD: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
echo;

docker build -t "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" .

echo;
echo;
echo "BUILD COMPLETE : ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
echo;
echo;
echo "PUSH HUB : ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
echo;
echo;

docker push "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"

echo;
echo;
echo "END PUSH HUB : ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
echo;
echo;
