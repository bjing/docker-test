#!/usr/bin/env bash

set -e

cd $(dirname $0)
source vars.sh

echo "Generating task-definition.json from template file"
eval "cat > /tmp/task-definition.json <<EOF
$(<task-definition.json.template)
EOF
"

echo "Creating task-definition for tag: ${TAG}"
DATA_CONTAINER_NAME="data-${TAG}"
docker create --name $DATA_CONTAINER_NAME -v /root alpine:3.3 /bin/sh
docker cp /tmp/task-definition.json $DATA_CONTAINER_NAME:/root/task-definition.json
REVISION=$(docker run --volumes-from $DATA_CONTAINER_NAME --rm "$@" anigeo/awscli \
   ecs register-task-definition    \
   --family $FAMILY                \
   --region $REGION                \
   --cli-input-json file:///root/task-definition.json \
   | docker run -i --rm mwendler/jq -r .taskDefinition.revision -)

docker stop $DATA_CONTAINER_NAME
docker rm -f -v $DATA_CONTAINER_NAME
rm /tmp/task-definition.json

echo "Updating service with task-definition: ${REVISION}"
docker run --rm "$@" anigeo/awscli \
   ecs update-service --cluster $CLUSTER --service $SERVICE --region $REGION --task-definition "${FAMILY}:${REVISION}"
