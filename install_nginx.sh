#!/bin/bash

ssh -i $key ubuntu@$IP 'sudo apt install nginx -y'