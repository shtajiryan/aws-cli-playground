#!/bin/bash

source ./utils/vpc.sh
source ./utils/instance.sh

case ${1} in

create)

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
    echo "Won't create the rest of resources as Route Table ID is empty" && exit

else
    echo "All VPC resources created!"

create_sg
fi

if [ -z "$SG_ID" ]; then
    echo "Won't create an instance as Security Group ID is empty" && exit
else

KEY_PAIR=shtajiryan

create_instance
fi

if [ -z "$INSTANCE_ID" ]; then
    echo "Instance not created" && exit
else
    echo "Instance with IP address $PUBLIC_IP created!"
fi

;;
delete)

delete_instance
delete_sg

;;
esac