#!/bin/bash

sudo apt update
sudo apt install nginx -y && echo "nginx installed!" || exit 1
