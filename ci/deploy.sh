#!/bin/bash

# $IMAGE and $TAG must be defined in jenkins

# FAMILY=hello-world
# REGION=us-west-1
# CLUSTER=app
# SERVICE=app

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

docker run --rm anigeo/awscli      \
   ecs register-task-definition    \
   --family hello-world            \
   --region us-west-1              \
   --container-definitions "[{\"name\":\"hello-world\",\"image\":\"${IMAGE}:${TAG}\",\"cpu\":0,\"memory\":200,\"essential\":true,\"portMappings\": [{\"containerPort\": 8080,\"hostPort\": 80 }]}]" | grep "revision" | cut -d ':' -f 2 | cut -c2- > revision.txt
   
   
docker run --rm anigeo/awscli \
   ecs update-service --cluster app --service app --region us-west-1 --task-definition "hello-world:$(cat revision.txt)"
