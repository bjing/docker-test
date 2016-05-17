#!/bin/bash

set -e

source ci/vars.sh

docker build -t app .
docker run --rm app npm test