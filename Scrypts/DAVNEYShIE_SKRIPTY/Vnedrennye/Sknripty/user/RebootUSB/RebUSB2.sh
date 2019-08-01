#! /bin/bash

LOGFILEPATH="/home/user/USBport.log"

echo `date +'%d.%m.%Y %H:%M:%S'` "- start" >> $LOGFILEPATH

Modem=$(lsusb | grep 19d2:1405 | wc -l)
if [ $Modem = 1 ] ; then
	echo `date +'%d.%m.%Y %H:%M:%S'` "- ok Modem" >> $LOGFILEPATH
else
		echo `date +'%d.%m.%Y %H:%M:%S'` "- Модем не подключен "$Modem"" >> $LOGFILEPATH
	sh -c "echo 0 > /sys/bus/usb/devices/1-2/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-2/authorized"
	sh -c "echo 0 > /sys/bus/usb/devices/1-4/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-4/authorized"
	fi

FR=$(lsusb | grep 18d1:4ee4 | wc -l)
if [ $FR = 1 ] ; then
	echo `date +'%d.%m.%Y %H:%M:%S'` "- ok FR" >> $LOGFILEPATH
else
	echo `date +'%d.%m.%Y %H:%M:%S'` "- ФР не подключен "$FR"" >> $LOGFILEPATH
	sh -c "echo 0 > /sys/bus/usb/devices/1-2/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-2/authorized"
	sh -c "echo 0 > /sys/bus/usb/devices/1-4/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-4/authorized"
	fi

Scaner=$( (lsusb | grep 0403:6001 || lsusb | grep 0c2e:0ca1) | wc -l)
if [ $Scaner = 1 ] ; then
	echo `date +'%d.%m.%Y %H:%M:%S'` "- ok Scaner" >> $LOGFILEPATH
else
	echo `date +'%d.%m.%Y %H:%M:%S'` "- Сканер не подключен "$Scaner"" >> $LOGFILEPATH
	sh -c "echo 0 > /sys/bus/usb/devices/1-2/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-2/authorized"
		sh -c "echo 0 > /sys/bus/usb/devices/1-4/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-4/authorized"
	fi
	
Key=$( (lsusb | grep 24dc:0101 || lsusb | grep 0a89:0030) | wc -l)
if [ $Key = 1 ] ; then
	echo `date +'%d.%m.%Y %H:%M:%S'` "- ok Key" >> $LOGFILEPATH
else
	echo `date +'%d.%m.%Y %H:%M:%S'` "- Ключ не подключен "$Key"" >> $LOGFILEPATH
	sh -c "echo 0 > /sys/bus/usb/devices/1-2/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-2/authorized"
		sh -c "echo 0 > /sys/bus/usb/devices/1-4/authorized"  
	sleep 5  
	sh -c "echo 1 > /sys/bus/usb/devices/1-4/authorized"
	fi	

sleep 300
done