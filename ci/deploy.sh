#!/bin/bash

set -e

# $IMAGE and $TAG must be defined in jenkins

FAMILY=hello-world
REGION=us-west-1
CLUSTER=app
SERVICE=app

# docker run --rm anigeo/awscli \
#    ecs register-task-definition \
#    --family $FAMILY \
#    --region $REGION \
#    --container-definitions "[{\"name\":\"hello-world\",\"image\":\"${IMAGE}:${TAG}\",\"cpu\":0,\"memory\":200,\"essential\":true,\"portMappings\": [{\"containerPort\": 8080,\"hostPort\": 80 }]}]" | grep "revision" | cut -d ':' -f 2 | cut -c2- > revision.txt

# docker run --rm anigeo/awscli  \
#    ecs update-service \
#    --cluster $CLUSTER 
#    --service $APP \
#    --region $REGION \
#    --task-definition "${FAMILY}:$(cat revision.txt)"

# Original Jenkins Job

echo "Creating task-definition for tag: ${TAG}"
docker run --rm anigeo/awscli      \
   ecs register-task-definition    \
   --family $FAMILY                \
   --region $REGION                \
   --container-definitions "[{\"name\":\"hello-world\",\"image\":\"${IMAGE}:${TAG}\",\"cpu\":0,\"memory\":200,\"essential\":true,\"portMappings\": [{\"containerPort\": 8080,\"hostPort\": 80 }]}]" | grep "revision" | cut -d ':' -f 2 | cut -c2- > revision.txt
   
echo "Updating service with task-definition: $(cat revision.txt)"
docker run --rm anigeo/awscli \
   ecs update-service --cluster $CLUSTER --service $SERVICE --region $REGION --task-definition "hello-world:$(cat revision.txt)"
