#!/bin/bash

## Given a tag, tells if the tag is auto-generated
function tag_matches_format {
  TAG=$1

  if [[ $TAG =~ ^[0-9]{4}(.[0-9]{1,}){3} ]]; then 
    echo 0
  else 
    echo 1
  fi
}

## Get the latest tag that conforms to the standard tag format
## ignoring all custom user-defined tags
function get_latest_auto_generated_tag {
  for i in $(seq `git tag | wc -l`); do 
    TAG=$(git tag --sort version:refname | tail -n ${i} | head -n1)
    FORMAT_MATCH=$(tag_matches_format $TAG)

    if [ $FORMAT_MATCH -eq 0 ]; then
      echo $TAG
      break
    fi
  done
}

if [ $# -gt 1 ]; then
  echo $#
  echo -e "Usage: $0\n       or optional supply a tag like: $0 \"MY_TAG\""
  exit 1
elif [ $# -eq 1 ]; then
  TAG=$1
else
  ##
  # Current branch and tag info
  ##
  BRANCH=$(git branch | grep "*")
  PREVIOUS_TAG=$(get_latest_auto_generated_tag)
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
  echo "Generated new tag: ${TAG}"
fi


git config --global user.email "brian.jing@outlook.com"
git config --global user.name "brian-jing"


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
