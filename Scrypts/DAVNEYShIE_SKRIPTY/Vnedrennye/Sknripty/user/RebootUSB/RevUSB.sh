#!/bin/sh
sh -c "echo 0 > /sys/bus/usb/devices/1-2/authorized"  
sleep 5  
sh -c "echo 1 > /sys/bus/usb/devices/1-2/authorized" 

sh -c "echo 0 > /sys/bus/usb/devices/1-0:1.0/authorized"  
sleep 5  
sh -c "echo 1 > /sys/bus/usb/devices/1-0:1.0/authorized" 

sh -c "echo 0 > /sys/bus/usb/devices/1-2.1/authorized"  
sleep 5  
sh -c "echo 1 > /sys/bus/usb/devices/1-2.1/authorized" 

sh -c "echo 0 > /sys/bus/usb/devices/2-0:1.0/authorized"  
sleep 5  
sh -c "echo 1 > /sys/bus/usb/devices/2-0:1.0/authorized"