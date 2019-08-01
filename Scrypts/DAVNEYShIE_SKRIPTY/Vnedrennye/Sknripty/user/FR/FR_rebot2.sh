#!/bin/bash

LOGFILEPATH="/home/user/ADMIN/CRON/FR_reboot.log"
sudo modprobe -r rndis_host
sudo modprobe cdc_ether
sudo modprobe dm9601
sudo modprobe usbnet
sudo modprobe rndis_host
sudo /linuxcash/cash/bin/frinit -gp on

#вот это дерьмо в local.rc. скрипт размести в папке home.
#вроде все.
#все понятно?