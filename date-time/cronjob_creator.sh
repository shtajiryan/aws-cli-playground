#!/bin/bash

echo "* * * * * date > /var/www/date-time/index.html" > /home/ubuntu/date-time/cron.tmp
echo "* * * * * sleep 30; date > /var/www/date-time/index.html" >> /home/ubuntu/date-time/cron.tmp

crontab /home/ubuntu/date-time/cron.tmp
rm /home/ubuntu/date-time/cron.tmp
