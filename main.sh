#!/bin/bash

IP=$1

ssh-keyscan $IP >> ~/.ssh/known_hosts

source install_nginx.sh
source configure_nginx.sh
source cron_job.sh

# TODO: switch using source to individually sending args to scripts
# TODO: implement passing location of private key as an argument