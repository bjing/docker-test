#!/bin/bash

set -e

CLUSTER=app
SERVICE=app
REGION=us-west-1
URL=http://app-ecs-elb-659670922.us-west-1.elb.amazonaws.com/

echo -n "Waiting for service to stabilize..."
docker run --rm anigeo/awscli ecs wait services-stable --cluster $CLUSTER --services $SERVICE --region $REGION
echo "   stable"

set +e
echo "Trying to reach ${URL} 60 times with a 10 second wait between each attempt"
COUNTER=60
while [ $COUNTER -gt 0 ]
do
	curl -o /dev/null -s $URL
	if [ $? == 0 ]
	then
		echo "Site was reached successfully!"
		exit
	fi
	COUNTER=$(($COUNTER-1))
	echo -n "."
	sleep 10
done

echo "Failed to reach ${URL} after 10 minutes."
exit 1