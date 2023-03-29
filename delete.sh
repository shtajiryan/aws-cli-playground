INSTANCE_ID=\
$(aws ec2 describe-instances \
	--query 'Reservations[*].Instances[*].[InstanceId]' \
	--output text)

echo $INSTANCE_ID

aws ec2 stop-instances \
	--instance-id $INSTANCE_ID

echo "$INSTANCE_ID stopped"

aws ec2 terminate-instances \
	--instance-id $INSTANCE_ID

echo "$INSTANCE_ID terminated"