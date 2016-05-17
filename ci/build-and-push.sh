#!/bin/bash

set -e

[[ -f ci/vars.sh ]] && source ci/vars.sh || source vars.sh

# Login to ECR without printing sensitive info to the console in jenkins
set +x
eval $(docker run --rm "$@" anigeo/awscli ecr get-login --region us-east-1)
set -x

[[ ! -f Dockerfile ]] && cd ..

docker build -t ${IMAGE_URL}:${TAG} .
docker push ${IMAGE_URL}:${TAG}
