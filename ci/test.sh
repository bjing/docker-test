#!/usr/bin/env bash

set -e

cd $(dirname $0)
source vars.sh

docker build -t app:${TAG} .
docker run --rm app:${TAG} npm test
