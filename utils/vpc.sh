#!/bin/bash

create_vpc ()
{
    VPC_ID=$(aws ec2 create-vpc \
        --cidr-block 10.0.0.0/16 \
        --query 'Vpc.{VpcId:VpcId}' \
        --output text)

    if [ -z "$VPC_ID" ]; then
        echo "VPC ID is empty, exiting..." && return 1
    else
        aws ec2 create-tags \
            --resources $VPC_ID \
            --tags Key=DeleteMe,Value=Yes

        echo "$VPC_ID created and tagged"
    fi
}

create_subnet ()
{
    SUBNET_ID=$(aws ec2 create-subnet \
	    --vpc-id $VPC_ID \
        --cidr-block 10.0.1.0/24 \
        --availability-zone us-east-1a \
        --query 'Subnet.{SubnetId:SubnetId}' \
        --output text)

    if [ -z "$SUBNET_ID" ]; then
        echo "Subnet ID is empty, exiting..." && return 1
    else
        aws ec2 create-tags \
            --resources $SUBNET_ID \
            --tags Key=DeleteMe,Value=Yes

        echo "$SUBNET_ID created and tagged"

        aws ec2 modify-subnet-attribute \
	        --subnet-id $SUBNET_ID \
	        --map-public-ip-on-launch

        echo "Auto-assign public IP for $SUBNET_ID enabled"
    fi
}

create_igw ()
{
    IGW_ID=$(aws ec2 create-internet-gateway \
        --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
        --output text)

    if [ -z "$IGW_ID" ]; then
        echo "Internet Gateway ID is empty, exiting..." && return 1
    else
        aws ec2 create-tags \
            --resources $IGW_ID \
            --tags Key=DeleteMe,Value=Yes

        echo "$IGW_ID created and tagged"

        aws ec2 attach-internet-gateway \
	        --vpc-id $VPC_ID \
	        --internet-gateway-id $IGW_ID

        echo "$IGW_ID attached to $VPC_ID"
    fi
}

create_rt ()
{
    RT_ID=$(aws ec2 create-route-table \
	    --vpc-id $VPC_ID \
	    --query 'RouteTable.{RouteTableId:RouteTableId}' \
	    --output text)

    if [ -z "$RT_ID" ]; then
        echo "Route table ID is empty, exiting..." && return 1
    else
        aws ec2 create-tags \
	        --resources $RT_ID \
	        --tags Key=DeleteMe,Value=Yes
    
        echo "$RT_ID created and tagged"

        aws ec2 associate-route-table \
            --route-table-id $RT_ID \
            --subnet-id $SUBNET_ID \
            --output text >> /dev/null

        echo "routing table associated"

        aws ec2 create-route \
	        --route-table-id $RT_ID \
	        --destination-cidr-block 0.0.0.0/0 \
	        --gateway-id $IGW_ID \
	        --output text >> /dev/null

        echo "route created"
    fi
}
