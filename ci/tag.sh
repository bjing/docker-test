#!/bin/bash

##
# Current branch and tag info
##
BRANCH=$(git branch | grep "*")
PREVIOUS_TAG=$(git describe --abbrev=0 --tags)
echo -e "Current branch:\n ${BRANCH}"
echo "Previous build tag is ${PREVIOUS_TAG}"

##
# Figure out current tag
##
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

# Create tag and push it to remote origin
echo "Push generated tag to remote"
git tag -a ${TAG} -m "Creating build tag ${TAG}"
CREATE_TAG_SUCCESS=$?
git push origin ${TAG}
PUSH_TAG_SUCCESS=$?

##
# Write tag into vars file
##
if [ $CREATE_TAG_SUCCESS -eq 0 ] && [ $PUSH_TAG_SUCCESS -eq 0 ]; then
  if [ -e ci/vars.sh ]; then
    VAR_FILE="ci/vars.sh"
  else
    VAR_FILE="vars.sh"
  fi
  echo "Build tag ${TAG} created successfully, writing it in ${VAR_FILE}"
  echo "TAG=${TAG}" >> $VAR_FILE
  echo "Build tag generated is ${TAG}"
else
  echo "Error creating and pusing new tag ${TAG}, bailing"
  exit 1
fi
