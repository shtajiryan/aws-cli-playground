#!/bin/bash

IP=$1
key=$2

ssh-keyscan $IP >> ~/.ssh/known_hosts

scp -i $key -r ./date-time ubuntu@$IP:~/

ssh -i $key ubuntu@$IP '
    sudo ~/date-time/install_nginx.sh
    sudo ~/date-time/configure_nginx.sh
    sudo ~/date-time/cronjob_creator.sh
'
