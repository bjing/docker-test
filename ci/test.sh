#!/bin/bash

set -e

[[ -f ci/vars.sh ]] && source ci/vars.sh || source vars.sh

docker build -t app:${TAG} .
docker run --rm app:${TAG} npm test