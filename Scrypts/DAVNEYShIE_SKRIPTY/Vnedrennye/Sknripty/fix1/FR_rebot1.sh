#!/bin/bash

LOGFILEPATH="/home/user/ADMIN/CRON/FR_reboot.log"
SumLines=$(echo "$(sudo netstat -r|grep 192.168.137.0 && netstat -ie|grep 192.168.137.1)" | wc -l)
if [ $SumLines = 2 ] ; then
	echo `date +'d.%m.%Y %H:%M:%S'` "- FR_okey" >> $LOGFILEPATH
else
	echo `date +'%d.%m.%Y %H:%M:%S'` "- FR not found (SumLines = "$SumLines")" >> $LOGFILEPATH
sudo modprobe -r rndis_host
sudo modprobe cdc_ether
sudo modprobe dm9601
sudo modprobe usbnet
sudo modprobe rndis_host
sudo /linuxcash/cash/bin/frinit -gp on
	if [ $? -ne 0 ] ; then
		echo `date +'%d.%m.%Y %H:%M:%S'` "- FR_error (SumLines = "$SumLines")" >> $LOGFILEP
	else 
		echo `date +'%d.%m.%Y %H:%M:%S'` "- FR_successfully (SumLines = "$SumLines")" >> $LOGFILEPATH
	fi		
fi
#а стоп. вот это дерьмо в крон надо. кидай в папку home. с кроном справишься. 