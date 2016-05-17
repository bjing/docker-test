#!/bin/bash

set -e

[[ -f ci/vars.sh ]] && source ci/vars.sh || source vars.sh

echo -n "Waiting for service to stabilize..."
docker run --rm "$@" anigeo/awscli ecs wait services-stable --cluster $CLUSTER --services $SERVICE --region $REGION
echo "...stable"

set +e
echo "Trying to reach ${APP_URL} 60 times with a 10 second wait between each attempt"
COUNTER=60
while [ $COUNTER -gt 0 ]
do
	curl -o /dev/null -s $APP_URL
	if [ $? == 0 ]
	then
		echo "Site was reached successfully!"
		exit 0
	fi
	COUNTER=$(($COUNTER-1))
	echo -n "."
	sleep 10
done

echo "Failed to reach ${APP_URL} after 10 minutes."
exit 1