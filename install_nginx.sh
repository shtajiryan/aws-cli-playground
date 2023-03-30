#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

script -> IP

date.conf.sh

does date

main.sh arg ip