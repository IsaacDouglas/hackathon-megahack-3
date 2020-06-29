#!/bin/bash

IMAGE_NAME="swift_base_image"
IMAGE_EXIST=$(docker images | grep -c ${IMAGE_NAME})
SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)

if [ "$IMAGE_EXIST" == 1 ]; then
    echo "${IMAGE_NAME} exist"
else
    echo "${IMAGE_NAME} does not exist, create now!!!"
    docker build -t swift_base_image $SCRIPT_PATH/base --no-cache
fi

docker-compose down
docker-compose up --build