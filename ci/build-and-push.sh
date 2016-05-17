#!/bin/bash

set -e

source ci/vars.sh

# Login to ECR without printing sensitive info to the console in jenkins
set +x
eval $(docker run --rm anigeo/awscli ecr get-login --region us-east-1)
set -x

docker build -t ${IMAGE_URL}:${TAG} .
docker push ${IMAGE_URL}:${TAG}
