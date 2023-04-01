#!/bin/bash

# ssh -i ~/Downloads/shtajiryan.pem ubuntu@$IP 'echo "* * * * * date > /var/www/html/index.nginx-debian.html" > cron.tmp'
# ssh -i ~/Downloads/shtajiryan.pem ubuntu@$IP 'echo "* * * * * sleep 30; date > /var/www/html/index.nginx-debian.html" >> cron.tmp'
# ssh -i ~/Downloads/shtajiryan.pem ubuntu@$IP 'crontab ~/cron.tmp'
# ssh -i ~/Downloads/shtajiryan.pem ubuntu@$IP 'rm ~/cron.tmp'


ssh -i $key ubuntu@$IP '
    echo "* * * * * date > /var/www/html/index.nginx-debian.html" > cron.tmp
    echo "* * * * * sleep 30; date > /var/www/html/index.nginx-debian.html" >> cron.tmp
    crontab ~/cron.tmp
    rm ~/cron.tmp
'

# TODO: send contents of echo as a file