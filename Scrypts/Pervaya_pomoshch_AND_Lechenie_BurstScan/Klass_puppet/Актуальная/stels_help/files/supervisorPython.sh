#! /bin/bash


LOGFILEPATH="/home/utm_port.log"
Minute="*/10"
InstallPath="/root/"


echo `date +'%d.%m.%Y %H:%M:%S'` "- start" >> $LOGFILEPATH
PortAgent=$(echo "$(tail -n 50 /opt/utm/agent/conf/agent.properties|grep "utm.port=8080" | wc -l)")
PortTransport=$(echo "$(tail -n 50 /opt/utm/transport/conf/transport.properties|grep "web.server.port=8080" | wc -l)")
routezabbix=$(echo "$(netstat -rn |grep 192.168.0.9 | wc -l)")

if [[ $routezabbix = 0 ]]; then

	sudo route add -host 192.168.0.9 gw 10.9.0.1
		echo `date +'%d.%m.%Y %H:%M:%S'` "- create route to zabbix (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH
else
		echo `date +'%d.%m.%Y %H:%M:%S'` "- route OK (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH
fi


if [[ $PortAgent = 1 || $PortTransport = 1 ]]; then

		echo `date +'%d.%m.%Y %H:%M:%S'` "- Port_change (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH

	sed -i 's/utm.port=8080/utm.port=8082/g' /opt/utm/agent/conf/agent.properties
    sed -i 's/web.server.port=8080/web.server.port=8082/g' /opt/utm/transport/conf/transport.properties
	sudo service supervisor restart
else
		echo `date +'%d.%m.%Y %H:%M:%S'` "- port OK (PortAgent="$PortAgent" ; PortTransport = "$PortTransport")" >> $LOGFILEPATH
fi


if [[ -n `cat /etc/crontab | grep "supervisor"` ]]
then
   cat /etc/crontab | grep "utmport"
   read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
   exit 2
fi


#echo $Minute $Hour \* \* \* root $InstallPath\/easyegais2.sh $InstallPath >> /etc/crontab
crontab -l | grep -v supervisor > /tmp/crontab.tmp
echo $Minute \* \* \* \* $InstallPath\/supervisor.sh $InstallPath >> /tmp/crontab.tmp
crontab < /tmp/crontab.tmp
rm -f /tmp/crontab.tmp

exit 0