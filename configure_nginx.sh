#!/bin/bash

ssh -i ~/Downloads/shtajiryan.pem ubuntu@$IP 'sudo cp /var/www/html/index.nginx-debian.html /var/www/html/index.nginx-debian.html.bak'
ssh -i ~/Downloads/shtajiryan.pem ubuntu@$IP 'sudo chown -R $USER:$USER /var/www/html'
ssh -i ~/Downloads/shtajiryan.pem ubuntu@$IP 'sudo chmod -R 755 /var/www/html'