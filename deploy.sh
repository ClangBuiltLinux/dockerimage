#!/bin/bash
set -eux
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push ${REPO}:${TAG}
if [[ ${BASE} = "debian" ]]; then
    docker tag ${REPO}:${TAG} ${REPO}:latest
    docker push ${REPO}:latest
fi
