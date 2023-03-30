#!/bin/bash


if [ $# = 0 ]; then
	echo "No arguments provided"


elif [ $1 = 'instance' ]; then

INSTANCE_ID=\
$(aws ec2 describe-instances \
	--filters "Name=instance-state-name,Values=running" "Name=tag:DeleteMe,Values=Yes" \
	--query 'Reservations[*].Instances[*].[InstanceId]' \
	--output text)

aws ec2 stop-instances \
	--instance-id $INSTANCE_ID \
	--output text > /dev/null

echo "$INSTANCE_ID stopped"

aws ec2 terminate-instances \
	--instance-id $INSTANCE_ID \
	--output text > /dev/null

echo "$INSTANCE_ID terminated"

fi