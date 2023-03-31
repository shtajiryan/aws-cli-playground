#!/bin/bash

ssh -i ~/Downloads/shtajiryan.pem ubuntu@$1 'echo "* * * * * date > /var/www/html/index.nginx-debian.html" > cron.tmp'
ssh -i ~/Downloads/shtajiryan.pem ubuntu@$1 'echo "* * * * * sleep 30; date > /var/www/html/index.nginx-debian.html" >> cron.tmp'
ssh -i ~/Downloads/shtajiryan.pem ubuntu@$1 'crontab cron.tpm'
ssh -i ~/Downloads/shtajiryan.pem ubuntu@$1 'rm cron.tpm'