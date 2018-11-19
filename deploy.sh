#!/bin/bash
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push nathanchance/cbl:${BASE}-${TAG}
docker tag nathanchance/cbl:${BASE}-${TAG} nathanchance/cbl:${BASE}
[[ ${BASE} = "debian" ]] && docker tag nathanchance/cbl:${BASE}-${TAG} nathanchance/cbl:latest
