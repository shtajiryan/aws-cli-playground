#!/bin/bash

key=$(cat ./key.ini)
IP=$1

ssh-keyscan $IP >> ~/.ssh/known_hosts

source install_nginx.sh
source configure_nginx.sh
source cron_job.sh

# TODO: switch using source to individually sending args to scripts