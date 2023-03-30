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


elif [ $1 = 'vpc' ]; then

SG_ID=\
$(aws ec2 describe-security-groups \
	--filters "Name=tag:DeleteMe,Values=Yes" \
	--query 'SecurityGroups[*].GroupId' \
	--output text)

aws ec2 delete-security-group \
	--group-id $SG_ID

echo "$SG_ID deleted"

SUBNET_ID=\
$(aws ec2 describe-subnets \
	--filters "Name=tag:DeleteMe,Values=Yes" \
	--query 'Subnets[*].SubnetId' \
	--output text)

aws ec2 delete-subnet \
	--subnet-id $SUBNET_ID

echo "$SUBNET_ID deleted"

RT_ID=\
$(aws ec2 describe-route-tables \
	--filters "Name=tag:DeleteMe,Values=Yes" \
	--query 'RouteTables[*].{RouteTableId:RouteTableId}' \
	--output text)

aws ec2 delete-route-table \
	--route-table-id $RT_ID

echo "$RT_ID deleted"

IG_ID=\
$(aws ec2 describe-internet-gateways \
	--filters "Name=tag:DeleteMe,Values=Yes" \
	--query 'InternetGateways[*].{InternetGatewayId:InternetGatewayId}' \
	--output text)

VPC_ID=\
$(aws ec2 describe-vpcs \
	--filters "Name=tag:DeleteMe,Values=Yes" \
	--query "Vpcs[*].VpcId" \
	--output text)

aws ec2 detach-internet-gateway \
	--internet-gateway-id $IG_ID \
	--vpc-id $VPC_ID

echo "$IG_ID detached from $VPC_ID"

aws ec2 delete-internet-gateway \
	--internet-gateway-id $IG_ID

echo "$IG_ID deleted"

aws ec2 delete-vpc \
	--vpc-id $VPC_ID

echo "$VPC_ID deleted"

fi