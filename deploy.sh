#!/bin/bash
set -eux
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push nathanchance/cbl:${BASE}-${TAG}
docker tag nathanchance/cbl:${BASE}-${TAG} nathanchance/cbl:${BASE}
if [[ ${BASE} = "debian" ]]; then
    docker tag nathanchance/cbl:${BASE}-${TAG} nathanchance/cbl:latest
    docker push nathanchance/cbl:latest
fi
