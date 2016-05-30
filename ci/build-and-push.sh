#!/usr/bin/env bash

set -e

cd $(dirname $0)
source vars.sh

# Pre pulling awscli image to avoid printing pulling messaging when it is run for the first time.
docker pull anigeo/awscli

# Login to ECR without printing sensitive info to the console in jenkins
set +x
eval $(docker run --rm "$@" anigeo/awscli ecr get-login --region $REGION)
set -x

[[ ! -f Dockerfile ]] && cd ..

docker build -t ${IMAGE_URL}:${TAG} .
docker push ${IMAGE_URL}:${TAG}
