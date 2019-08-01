#!/bin/bash

LOGFILEPATH="/home/user/ADMIN/CRON/FR_reboor.log"
sudo modprobe -r rndis_host
sudo modprobe cdc_ether
sudo modprobe dm9601
sudo modprobe usbnet
sudo modprobe rndis_host
sudo /linuxcash/cash/bin/frinit -gp on
echo `date +'%d.%m.%Y %H:%M:%S'` "KKM sucsseful reboot!:)))" >> $LOGFILEPATH