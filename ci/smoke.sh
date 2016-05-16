#!/bin/bash

set -e

CLUSTER=app
SERVICE=app
REGION=us-west-1
URL=http://app-ecs-elb-659670922.us-west-1.elb.amazonaws.com/

docker run anigeo/awscli ecs wait services-stable --cluster $CLUSTER --services $SERVICE --region $REGION

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

echo "Failed to reach app after 10minutes."
exit 1