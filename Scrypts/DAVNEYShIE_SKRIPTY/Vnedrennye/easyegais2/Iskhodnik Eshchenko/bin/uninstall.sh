#!/bin/bash

crontab -l | grep -v easyegais2 > /tmp/crontab.tmp
crontab < /tmp/crontab.tmp
rm -f /tmp/crontab.tmp
cd /
rm -rf /root/easyegais2
