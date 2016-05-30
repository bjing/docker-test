#!/usr/bin/env bash

# Infrastructure
IMAGE_URL="950554271411.dkr.ecr.us-west-2.amazonaws.com/sample-ci-cd"
FAMILY=hello-world
REGION=us-west-2
CLUSTER=sample-ci-cd
SERVICE=app
APP_URL=sample-ci-cd-ecs-elb-1304418701.us-west-2.elb.amazonaws.com

# App specific
HOST_PORT=80
CONTAINER_PORT=8080
CONTAINER_NAME=app
IMAGE_TAG=$TAG
MEMORY=200
