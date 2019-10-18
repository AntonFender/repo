#!/bin/bash


LOGFILEPATH="/var/log/StatusKassa.log"
Minute="*/29"
InstallPath="/root"
count="4"
ip="8.8.8.8"

#echo `date +'%d.%m.%Y %H:%M:%S'` "- start" >> $LOGFILEPATH
PortAgent=$(echo "$(tail -n 50 /opt/utm/agent/conf/agent.properties|grep "utm.port=8080" | wc -l)")
PortTransport=$(echo "$(tail -n 50 /opt/utm/transport/conf/transport.properties|grep "web.server.port=8080" | wc -l)")
routezabbix=$(echo "$(netstat -rn |grep 192.168.0.9 | wc -l)")
result=$(ping -c ${count} ${ip} 2<&1| grep -icE 'unknown|expired|unreachable|time out ')
getfsrar=$(echo "$(curl -X GET http://localhost:8082 | grep -oPi "(?=RSA )[FSRAR^]+.FSRAR.+")")

TokenNull=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w '0 but token only has 0 slots' | wc -l)
TokenOther=$(tail /opt/utm/updater/l/update.log|grep -w 'Не найден сертификат' |wc -l)
TokenCert=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'RSA сертификаты не найдены' |wc -l)

TokenPKI=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'PKI хранилище не содержит подходящего сертификата' |wc -l)
TokenRem=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'Token has been removed' |wc -l)
TokenDriver=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'Ключ не найден или не успели загрузиться все драйвера' |wc -l)

SizeVarLogs=$(du -h /var/log | tail -n 1)

VarLogSyslog=$(egrep -wc 'cannot reset|cannot disable|Failed adding USB device|Error communicating|Maybe the USB cable is bad|device not accepting address|Device not responding to setup address' /var/log/syslog)
#infoping=$(ping -c ${count} ${ip} 2<&1)

######################____ПРОВЕРКА СЕТИ____#################

doping ()
{

if [ $result -eq 0 ]; then
		echo `date +'%d.%m.%Y %H:%M:%S'` " - Интернет есть! - " $result >> $LOGFILEPATH
	else
		echo `date +'%d.%m.%Y %H:%M:%S'` " - Интернет отсутствует! - "$result >> $LOGFILEPATH
fi
}


######################____ПРОВЕРКА НА НАЛИЧИЕ МОДЕМА____#################

FindModem()
{
if [[ ! -n `lsusb | grep "19d2:1405"` ]]; then
		echo `date +'%d.%m.%Y %H:%M:%S'` " - Модем не найден!" >> $LOGFILEPATH
	else
		echo `date +'%d.%m.%Y %H:%M:%S'` " - Модем подключен к кассе!" >> $LOGFILEPATH
fi
}


######################____Доступность УТМ посредством запроса FSRAR____#################
WorkUTM()
{
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Запрос FSRAR(Если получен - УТМ запущен) - " $getfsrar >> $LOGFILEPATH
		sed -i 's#<\/div></div>#.#g' ${LOGFILEPATH}

if [ $TokenNull -gt 0 ] ; then
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Ошибка рутокен: 0 but token only has 0 slots" >> $LOGFILEPATH

elif [ $TokenOther -gt 0 ] ; then
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Ошибка рутокен: Не найден сертификат" >> $LOGFILEPATH
	
elif [ $TokenCert -gt 0 ] ;then
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Ошибка рутокен: RSA сертификаты не найдены" >> $LOGFILEPATH
	
elif [ $TokenPKI -gt 0 ] ;then	
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Ошибка рутокен: PKI хранилище не содержит подходящего сертификата" >> $LOGFILEPATH
	
elif [ $TokenRem -gt 0 ] ;then
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Ошибка рутокен: Token has been removed!" >> $LOGFILEPATH
	
elif [ $TokenDriver -gt 0 ] ;then
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Ошибка рутокен: Ключ не найден или не успели загрузиться все драйвера" >> $LOGFILEPATH

elif [ ! -f /opt/utm/updater/l/update.log ];then
	echo `date +'%d.%m.%Y %H:%M:%S'` " - ЕГАИС отсутствует на кассе"	>> $LOGFILEPATH
		
else
	echo `date +'%d.%m.%Y %H:%M:%S'` " - Ошибка рутокен: Ключ ЕГАИС работает" >> $LOGFILEPATH
fi
}

######################____ДОПОЛНИТЕЛЬНЫЕ_ЛОГИ____#################

OtherLogs()
{
echo `date +'%d.%m.%Y %H:%M:%S'` " - Размер директории с логами - "$SizeVarLogs >> $LOGFILEPATH
if [ $VarLogSyslog -gt 0 ]; then
		echo `date +'%d.%m.%Y %H:%M:%S'` " - Скорей всего отваливаются USB порты - " $VarLogSyslog >> $LOGFILEPATH
	else
		echo `date +'%d.%m.%Y %H:%M:%S'` " - USB порты в порядке! - " $VarLogSyslog >> $LOGFILEPATH
fi
}

#Конфигурирование чеков в ШТРИХ и ВИКИ ПРИНТ
SettingVikiAndShtrih()
{

#Замена типа оплаты на ВИКИ ПРИНТ
if [ -f /opt/FirstHelpAndScan/frViki.ini ]; then
	if [ -n "$(diff  /opt/FirstHelpAndScan/frViki.ini /linuxcash/cash/conf/ncash.ini.d/fr.ini)" ]; then
		if [[ -n `lsusb | grep "0483:5740"` ]]; then 
			cat /opt/FirstHelpAndScan/frViki.ini > /linuxcash/cash/conf/ncash.ini.d/fr.ini
		fi
	fi
fi

#Замена типа оплаты на ШТРИХ
if [ -f /opt/FirstHelpAndScan/frShtrih.ini ]; then
	if [ -n "$(diff  /opt/FirstHelpAndScan/frShtrih.ini /linuxcash/cash/conf/ncash.ini.d/fr.ini)" ]; then
		if [[ -n `lsusb | grep "18d1:4ee4"` ]]; then 
			cat /opt/FirstHelpAndScan/frShtrih.ini > /linuxcash/cash/conf/ncash.ini.d/fr.ini
		fi
	fi
fi
}

doping
FindModem
WorkUTM
OtherLogs
SettingVikiAndShtrih

######################____РОТАЦИЯ_АДРЕСОВ_ДЛЯ_ZABBIX____#################

if [[ $routezabbix = 0 ]]; then

	sudo route add -host 192.168.0.9 gw 10.9.0.1
#echo `date +'%d.%m.%Y %H:%M:%S'` "- create route to zabbix (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH
#else
#echo `date +'%d.%m.%Y %H:%M:%S'` "- route OK (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH
fi


######################____ЗАМЕНА_ПОРТОВ_UTM_НА_8082____#################

if [[ $PortAgent = 1 || $PortTransport = 1 ]]; then

#echo `date +'%d.%m.%Y %H:%M:%S'` "- Port_change (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH

	sed -i 's/utm.port=8080/utm.port=8082/g' /opt/utm/agent/conf/agent.properties
    sed -i 's/web.server.port=8080/web.server.port=8082/g' /opt/utm/transport/conf/transport.properties
	sudo service supervisor restart
#else
#echo `date +'%d.%m.%Y %H:%M:%S'` "- port OK (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH
fi



######################____ИНИЦИАЛИЗАЦИЯ_CRONTAB____#################

#if [[ -n `cat /etc/crontab | grep "supervisor"` ]]
#then
#   cat /etc/crontab | grep "supervisor"
#   read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
#   exit 2
#fi


#echo $Minute $Hour \* \* \* root $InstallPath\/easyegais2.sh $InstallPath >> /etc/crontab
sudo crontab -l | grep -v supervisor > /opt/crontab.tmp
sudo echo \*/29 \* \* \* \* /root/supervisor.sh >> /opt/crontab.tmp
sudo crontab < /opt/crontab.tmp
rm -f /opt/crontab.tmp

exit 0