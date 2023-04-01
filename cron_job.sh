#!/bin/bash

ssh -i $key ubuntu@$IP '
    echo "* * * * * date > /var/www/html/index.nginx-debian.html" > cron.tmp
    echo "* * * * * sleep 30; date > /var/www/html/index.nginx-debian.html" >> cron.tmp
    crontab ~/cron.tmp
    rm ~/cron.tmp
'

# TODO: send contents of echo as a file