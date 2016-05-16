#!/bin/bash

set -e

IMAGE_URL=950554271411.dkr.ecr.us-east-1.amazonaws.com/hello-world-node

# Login to ECR without printing sensitive info to the console in jenkins
set +x
eval $(docker run --rm anigeo/awscli ecr get-login --region us-east-1)
set -x

# re-enable output so we can see what build/push are doing
docker build -t ${IMAGE_URL}:${TAG} .
docker push ${IMAGE_URL}:${TAG}

# Original Jenkins Job
# set +x
# sudo $(sudo docker run --rm anigeo/awscli ecr get-login --region us-east-1)
# set -x
# sudo docker build -t 950554271411.dkr.ecr.us-east-1.amazonaws.com/hello-world-node:${TAG} .
# sudo docker push 950554271411.dkr.ecr.us-east-1.amazonaws.com/hello-world-node:${TAG}
