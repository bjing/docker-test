#!/bin/bash

set -e

source ci/vars.sh

docker build -t app:${TAG} .
docker run --rm app:${TAG} npm test