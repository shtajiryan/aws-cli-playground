#!/bin/bash

ssh -i $key ubuntu@$IP '
    sudo cp /var/www/html/index.nginx-debian.html /var/www/html/index.nginx-debian.html.bak
    sudo chown -R $USER:$USER /var/www/html
    sudo chmod -R 755 /var/www/html
'