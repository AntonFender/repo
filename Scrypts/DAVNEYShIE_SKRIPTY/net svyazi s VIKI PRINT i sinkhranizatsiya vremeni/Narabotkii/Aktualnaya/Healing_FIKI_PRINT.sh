#!/bin/bash

InstallPath="/home/fix"
Minutes="1"
LOGFILEPATH="/home/fix/FR_VIKI_Print.log"
ProverkaNaFR=$(lsusb | grep STMicroelectronics | wc -l)
StatFrViki=$(sudo tail -n 30 /opt/comproxy/logs/comProxy.log|grep -w 'Error open port: /dev/ttyACM0' | wc -l)

if [ $ProverkaNaFR -ge 1 ];then
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Касса работает через ВИКИ ПРИНТ" >> $LOGFILEPATH
if [ $StatFrViki -ge 1 ] ; then
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Error open port: /dev/ttyACM0 (Счетчик ошибок = "$StatFrViki")" >> $LOGFILEPATH
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Производим отключение модуля cdc_acm в lsmod" >> $LOGFILEPATH
	
		sudo service comproxy stop
		sudo rmmod cdc-acm
		sudo modprobe cdc_acm 
		
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Перезапускаем service comproxy" >> $LOGFILEPATH
		sudo service comproxy start

else
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Вики Принт работает без ошибок (Счетчик ошибок = "$StatFrViki")" >> $LOGFILEPATH
fi

else
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Касса работает через ШТРИХ-ОНЛАЙН" >> $LOGFILEPATH
fi

#Организация CRONTAB. Устанавливает автозапуск скрипта на кассе.
if [ $ProverkaNaFR -ge 1 ];then

sudo crontab -l | grep -v Healing_FIKI_PRINT > /tmp/crontab.tmp
echo \*\/$Minutes \* \* \* \* $InstallPath\/Healing_FIKI_PRINT.sh \> \/dev\/null 2\>\&1 >> /tmp/crontab.tmp
sudo crontab < /tmp/crontab.tmp
sudo rm -f /tmp/crontab.tmp

fi

sleep 1
