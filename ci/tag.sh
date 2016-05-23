#!/bin/bash

PREVIOUS_TAG=$(git describe --abbrev=0 --tags)

PREVIOUS_TAG_DATE=$(echo $PREVIOUS_TAG | cut -d. -f1,2,3)
PREVIOUS_TAG_NUMBER=$(echo $PREVIOUS_TAG | cut -d. -f4)
CURRENT_DATE=$(date +%Y.%m.%d)

if [ $PREVIOUS_TAG_DATE = $CURRENT_DATE ]; then
  CURRENT_TAG_DATE=$PREVIOUS_TAG_DATE
  CURRENT_TAG_NUMBER=$(($PREVIOUS_TAG_NUMBER + 1))
else
  CURRENT_TAG_DATE=$CURRENT_DATE
  CURRENT_TAG_NUMBER="1"
fi

TAG="${CURRENT_TAG_DATE}.${CURRENT_TAG_NUMBER}"

if [ -e ci/vars.sh ]; then
  VAR_FILE="ci/vars.sh"
else
  VAR_FILE="vars.sh"
fi

echo "TAG=${TAG}" >> $VAR_FILE
echo "Build tag generated is ${TAG}"
