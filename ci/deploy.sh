#!/bin/bash

# set -e

# # $IMAGE and $TAG must be defined in jenkins

# FAMILY=hello-world
# REGION=us-west-1
# CLUSTER=app
# SERVICE=app

# echo "Generating task-definition.json from template file"
# HOST_PORT=80
# CONTAINER_PORT=8080
# CONTAINER_NAME="hello-world"
# IMAGE_URL=$IMAGE
# IMAGE_TAG=$TAG
# MEMORY=200

cat ci/task-definition.json.template
TEMPLATE=$(cat ci/task-definition.json.template)
echo $TEMPLATE


# GENERATED=${TEMPLATE//HOST_PORT/$HOST_PORT}
# GENERATED=${GENERATED//CONTAINER_PORT/$CONTAINER_PORT}
# GENERATED=${GENERATED//CONTAINER_NAME/$CONTAINER_NAME}
# GENERATED=${GENERATED//IMAGE_URL/$IMAGE_URL}
# GENERATED=${GENERATED//IMAGE_TAG/$IMAGE_TAG}
# GENERATED=${GENERATED//MEMORY/$MEMORY}

# echo "Creating task-definition for tag: ${TAG}"
# docker run --rm anigeo/awscli      \
#    ecs register-task-definition    \
#    --family $FAMILY                \
#    --region $REGION                \
#    --container-definitions $GENERATED | grep "revision" | cut -d ':' -f 2 | cut -c2- > revision.txt
   
# echo "Updating service with task-definition: $(cat revision.txt)"
# docker run --rm anigeo/awscli \
#    ecs update-service --cluster $CLUSTER --service $SERVICE --region $REGION --task-definition "${FAMILY}:$(cat revision.txt)"
