#!/bin/bash

source ./utils/vpc.sh

create_vpc

if [ -z "$VPC_ID" ]; then
    echo "Won't create the rest of resources as VPC ID is empty" && exit

else
create_subnet
fi

if [ -z "$SUBNET_ID" ]; then
    echo "Won't create the rest of resources as Subnet ID is empty" && exit

else
create_igw
fi

if [ -z "$IGW_ID" ]; then
    echo "Won't create the rest of resources as Internet Gateway ID is empty" && exit

else
create_rt
fi
if [ -z "$RT_ID" ]; then
    echo "Won't create the rest of resources as Route table ID is empty" && exit

else
    echo "All VPC resources created!"
fi