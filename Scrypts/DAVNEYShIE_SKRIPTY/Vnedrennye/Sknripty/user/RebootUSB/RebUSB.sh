#! /bin/bash

LOGFILEPATH="/home/user/USBport.log"

echo `date +'%d.%m.%Y %H:%M:%S'` "- start" >> $LOGFILEPATH

SumLines=$(echo "$(lsusb |grep 19d2:1405 && lsusb |grep 18d1:4ee4 && lsusb |grep 0403:6001 && lsusb |grep 24dc:0101 && lsusb |grep 0a89:0030 && lsusb |grep 0c2e:0ca1)" | wc -l)
if [ $SumLines = 4 ] ; then
	echo `date +'d.%m.%Y %H:%M:%S'` "- ok USB" >> $LOGFILEPATH
else
	
	echo `date +'%d.%m.%Y %H:%M:%S'` "- USB is not working, reboot USB... (SumLines = "$SumLines")" >> $LOGFILEPATH
	sh -c "echo 0 > /sys/bus/usb/devices/1-2/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-2/authorized" 
	
	if [ $? -ne 0 ] ; then
		echo `date +'%d.%m.%Y %H:%M:%S'` "- error reboot USB (SumLines = "$SumLines")" >> $LOGFILEP
	else 
		echo `date +'%d.%m.%Y %H:%M:%S'` "- USB launched successfully (SumLines = "$SumLines")" >> $LOGFILEPATH
	fi		
fi

sleep 300
done
