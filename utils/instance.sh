#!/bin/bash

create_sg () {

    aws ec2 create-security-group \
	    --group-name acatest \
	    --description "aca test security group" \
        --vpc-id $VPC_ID \
        --query 'GroupId' \
        --output text

    aws ec2 create-tags \
        --resources $SG_ID \
        --tags Key=DeleteMe,Value=Yes

    echo "$SG_ID created and tagged"

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

}

delete_sg () {
    
    aws ec2 describe-security-groups \
        --filters "Name=tag:DeleteMe,Values=Yes" \
        --query 'SecurityGroups[*].GroupId' \
        --output text

    aws ec2 delete-security-group \
        --group-id $SG_ID

    echo "$SG_ID deleted"

}