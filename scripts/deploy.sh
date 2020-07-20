#!/bin/bash
set -eux
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push "${REPO}:llvm${LLVM_VERSION:=12}-${DATE}"
docker push "${REPO}:llvm${LLVM_VERSION}-latest"
if [[ ${LLVM_VERSION} -eq 12 ]]; then
    docker push "${REPO}:latest"
fi
