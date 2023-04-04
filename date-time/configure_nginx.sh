#!/bin/bash

mkdir -p /var/www/date-time
date > /var/www/date-time/index.html
rm /etc/nginx/sites-enabled/default || echo "default file is already removed"
cp /home/ubuntu/date-time/res/date-time.conf /etc/nginx/sites-enabled/
systemctl reload nginx.service
