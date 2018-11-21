#!/bin/bash
set -eux
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push ${REPO}:${TAG}
docker push ${REPO}:latest
