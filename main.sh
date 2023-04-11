#!/bin/bash

source ./utils/vpc.sh

create_vpc
if [ -z "$VPC_ID" ]; then
    echo "Won't create the rest of resources as VPC ID is empty" && return 1
else
create_subnet
create_igw

fi

# add error handling after each function call