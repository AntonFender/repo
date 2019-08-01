#!/bin/bash

InstallPath="/home/fix"
Minutes="1"
LOGFILEPATH="/home/fix/FR_VIKI_Print.log"
ProverkaNaFR=$(lsusb | grep STMicroelectronics | wc -l)
StatFrViki=$(tail -n 30 /opt/comproxy/logs/comProxy.log|grep -w 'Error open port: /dev/ttyACM0' | wc -l)

if [ $ProverkaNaFR -ge 1 ];then
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Касса работает через ВИКИ ПРИНТ" >> $LOGFILEPATH
if [ $StatFrViki -ge 1 ] ; then
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Error open port: /dev/ttyACM0 (Счетчик ошибок = "$StatFrViki")" >> $LOGFILEPATH
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Производим отключение модуля cdc_acm в lsmod" >> $LOGFILEPATH
	
		service comproxy stop
		rmmod cdc-acm
		modprobe cdc_acm 
		
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Перезапускаем service comproxy" >> $LOGFILEPATH
		service comproxy start

else
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Вики Принт работает без ошибок (Счетчик ошибок = "$StatFrViki")" >> $LOGFILEPATH
fi

else
			echo `date +'%d.%m.%Y %H:%M:%S'` "- Касса работает через ШТРИХ-ОНЛАЙН" >> $LOGFILEPATH
fi

#Организация CRONTAB. Устанавливает автозапуск скрипта на кассе.
if [ $ProverkaNaFR -ge 1 ];then

crontab -l | grep -v Healing_FIKI_PRINT > /tmp/crontab.tmp
echo \*\/$Minutes \* \* \* \* $InstallPath\/Healing_FIKI_PRINT.sh \> \/dev\/null 2\>\&1 >> /tmp/crontab.tmp
crontab < /tmp/crontab.tmp
rm -f /tmp/crontab.tmp

fi

sleep 1

#Установка даты и времени через гугл сервис

#pinghost = $(echo "$(ping -c 3 8.8.8.8 | grep -e "bytes from" | wc -l)")

if [ ping -c 3 8.8.8.8 | grep -e "bytes from" | wc -l -ge 3 ]; then
echo "Установка даты и времени"
date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
echo "Дата и время установлено"
fi












