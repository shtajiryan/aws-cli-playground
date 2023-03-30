VPC_ID=\
$(aws ec2 create-vpc \
	--cidr-block 10.0.0.0/16 \
	--query 'Vpc.{VpcId:VpcId}' \
	--output text)

aws ec2 create-tags \
	--resources $VPC_ID \
	--tags Key=DeleteMe,Value=Yes

echo "$VPC_ID created and tagged"

SUBNET_ID=\
$(aws ec2 create-subnet \
	--vpc-id $VPC_ID \
	--cidr-block 10.0.1.0/24 \
	--availability-zone us-east-1a \
	--query 'Subnet.{SubnetId:SubnetId}' \
	--output text)

echo "$SUBNET_ID created"

aws ec2 modify-subnet-attribute \
	--subnet-id $SUBNET_ID \
	--map-public-ip-on-launch

echo "Auto-assign public IP for $SUBNET_ID enabled"

IG_ID=\
$(aws ec2 create-internet-gateway \
	--query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
	--output text)

echo "$IG_ID created"

aws ec2 attach-internet-gateway \
	--vpc-id $VPC_ID \
	--internet-gateway-id $IG_ID \

echo "$IG_ID attached to $VPC_ID"

RT_ID=\
$(aws ec2 create-route-table \
	--vpc-id $VPC_ID \
	--query 'RouteTable.{RouteTableId:RouteTableId}' \
	--output text)

echo "$RT_ID created"

aws ec2 associate-route-table \
	--route-table-id $RT_ID \
	--subnet-id $SUBNET_ID \
	--output text > /dev/null

echo "routing table associated"

aws ec2 create-route \
	--route-table-id $RT_ID \
	--destination-cidr-block 0.0.0.0/0 \
	--gateway-id $IG_ID \
	--output text > /dev/null

echo "route created"

SG_ID=\
$(aws ec2 create-security-group \
	--group-name acatest \
	--description "aca test security group" \
	--vpc-id $VPC_ID \
	--query 'GroupId' \
	--output text)

echo "$SG_ID created"

aws ec2 authorize-security-group-ingress \
	--group-id $SG_ID \
	--protocol tcp \
	--port 22 \
	--cidr 0.0.0.0/0 \
	--output text > /dev/null

aws ec2 authorize-security-group-ingress \
	--group-id $SG_ID \
	--protocol tcp \
	--port 80 \
	--cidr 0.0.0.0/0 \
	--output text > /dev/null

echo "SSH allowed for $SG_ID"
echo "Port 80 opened for all on $SG_ID"

KEY_PAIR=shtajiryan #change to your own key-pair name

INSTANCE_ID=\
$(aws ec2 run-instances \
	--image-id ami-007855ac798b5175e \
	--instance-type t2.micro \
	--key-name $KEY_PAIR \
	--monitoring "Enabled=false" \
	--security-group-ids $SG_ID \
	--subnet-id $SUBNET_ID \
	--private-ip-address 10.0.1.10 \
	--query 'Instances[0].InstanceId' \
	--output text)

echo "$INSTANCE_ID created"

# aws ec2 describe-instances \
# --instance-ids $INSTANCE_ID \
# --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
# --output text

PUBLIC_IP=\
$(aws ec2 describe-instances \
	--instance-ids $INSTANCE_ID \
	--query 'Reservations[*].Instances[*].[PublicIpAddress]' \
	--output text)

echo "IP is $PUBLIC_IP"

# Add tags
# Add arguments before running