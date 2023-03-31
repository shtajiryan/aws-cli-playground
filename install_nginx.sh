#!/bin/bash

ssh -i ~/Downloads/shtajiryan.pem ubuntu@$1 'sudo apt install nginx -y'