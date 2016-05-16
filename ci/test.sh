#!/bin/bash

set -e

docker build -t app .
docker run --rm app npm test