#!/bin/bash
if [ "$1" != "" ]; then
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
    docker push simplifi/docker-presto:$1
else
    echo "A tag must be passed in!"
    exit 1
fi
