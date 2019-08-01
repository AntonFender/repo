#! /bin/bash
#

#Переменные для FTP-соединения
FTPServer="10.9.0.1"
FTPUser="ftpuser"
FTPPassword="GbplfnsqGfhjkm"
FTPPath="/ftp/salerestrict/"
FTPPaths="/ftp/kassinfo/"

#Глобальные переменные
LOGFILEPATH=/root/`hostname`\-MRC.log
LOGFILEPAT=/root/`hostname`\-UTM.log
Minutes="00"
Hours="14"
InstallPath="/root"
LOGFILEPATHONKASSA=$(echo "$(ls /root/ | grep "`hostname`\-MRC")")
LOGFILEPATHONKASS=$(echo "$(ls /root/ | grep "`hostname`\-UTM")")

#Запрос справочников с Mysql
sleep 1
	
sudo mysql -u root -D dictionaries -e "select name,minprice from tmc WHERE minprice in(43.00,107.50) AND ((name LIKE '%Водка%' OR name LIKE '%водка%') AND (name LIKE '%0,1%' OR name LIKE '%0,25%')) ORDER BY minprice DESC" > /root/list.txt

sleep 2


Lisence=$(echo "$(curl -X GET http://localhost:8082 | grep -oP "(?=Лицензия )[^<^]+")")
Certif=$(echo "$(curl -X GET http://localhost:8082 | grep -oPi "(?=Сертификат )[^<^]+.+")")


#Локальные переменные
PortAgent=$(echo "$(tail -n 50 /opt/utm/agent/conf/agent.properties|grep "utm.port=8082" | wc -l)")
PortTransport=$(echo "$(tail -n 50 /opt/utm/transport/conf/transport.properties|grep "web.server.port=8082" | wc -l)")
PortViki=$(echo "$(tail -n 50 /linuxcash/cash/conf/drivers/hw::Serial_*.xml | grep "ttyS91" | wc -l)")
PortShtrih=$(echo "$(tail -n 50 /linuxcash/cash/conf/drivers/hw::GenericTcp_*.xml | grep "192.168.137.111" | wc -l)")
VikiFile=$(echo "$(ls /linuxcash/cash/conf/drivers/hw::Serial_*.xml | wc -l)")
ShtrihFile=$(echo "$(ls /linuxcash/cash/conf/drivers/hw::GenericTcp_*.xml | wc -l)")

#Удаление ранее созданного LOG-файла MRC
if ( ls -d /root/`hostname`\-MRC*.log ); then
	rm `hostname`\-MRC*.log
fi

#Удаление ранее созданного LOG-файла UTM
if ( ls -d /root/`hostname`\-UTM*.log ); then
	rm /root/`hostname`\-UTM*.log
fi


#Переменные для определения справочника
check=$(tail -n 100 /root/list.txt|grep -w 107.50 | wc -l)
check2=$(tail -n 100 /root/list.txt|grep -w 43.00 | wc -l)

#Перезапускаем autofs

service autofs restart

#ФУНКЦИЯ Подключения к FTP salerestrict . Удаление ранего созданного лог файла и отправка нового.
send_log ()
{
    #Добавить к имени файла результат работы (первый параметр функции)
    filename=`basename $LOGFILEPATH .log`
	mv $LOGFILEPATH /root/${filename}\=${1}.log
    LOGFILEPATH=/root/${filename}\=${1}.log
    #Удаление журнала на FTP-сервер
	echo `date +'d.%m.%Y %H:%M:%S'` "- Запуск проверки удаления файлов на FTP" >> $LOGFILEPATH
	statusftpfile=$(ls /linuxcash/net/server/MRC_LOG/ | grep "${LOGFILEPATHONKASSA}" | wc -l )
		if [ $statusftpfile -eq 1 ]; then
echo `date +'d.%m.%Y %H:%M:%S'` "- Файл найден на сервере FTP!" >> $LOGFILEPATH
rm -f /linuxcash/net/server/MRC_LOG/${LOGFILEPATHONKASSA}
echo `date +'d.%m.%Y %H:%M:%S'` "- Старый файл с FTP-сервера удален!" >> $LOGFILEPATH
		else
echo `date +'d.%m.%Y %H:%M:%S'` "- Файл на FTP-сервере не найден!" >> $LOGFILEPATH
		fi
	
	#Отправка журнала на FTP-сервер
echo `date +'d.%m.%Y %H:%M:%S'` "- Файл на FTP-сервер Загружен!" >> $LOGFILEPATH
    cp "$LOGFILEPATH" /linuxcash/net/server/MRC_LOG

}

#ФУНКЦИЯ Подключения к FTP kassinfo. Удаление ранего созданного лог файла и отправка нового.
send_log_utm ()
{
    #Добавить к имени файла результат работы (первый параметр функции)
    filenames=`basename $LOGFILEPAT .log`
	mv $LOGFILEPAT /root/${filenames}\=${1}.log
    LOGFILEPAT=/root/${filenames}\=${1}.log
    #Удаление журнала на FTP-сервер
	echo `date +'d.%m.%Y %H:%M:%S'` "- Запуск проверки удаления файлов на FTP" >> $LOGFILEPAT
	statusftpfiles=$(ls /linuxcash/net/server/UTM_LOG/ | grep "${LOGFILEPATHONKASS}" | wc -l )
		if [ $statusftpfiles -eq 1 ]; then
echo `date +'d.%m.%Y %H:%M:%S'` "- Файл найден на сервере FTP!" >> $LOGFILEPAT
	rm -f /linuxcash/net/server/UTM_LOG/${LOGFILEPATHONKASS}
echo `date +'d.%m.%Y %H:%M:%S'` "- Старый файл с FTP-сервера удален!" >> $LOGFILEPAT
		else
echo `date +'d.%m.%Y %H:%M:%S'` "- Файл на FTP-сервере не найден!" >> $LOGFILEPAT
		fi

#Запись этой информации в ЛОГ-файл
echo `date +'d.%m.%Y %H:%M:%S'` "- "$Lisence" " >> $LOGFILEPAT
echo `date +'d.%m.%Y %H:%M:%S'` "- "$Certif" " >> $LOGFILEPAT
sed -i 's/<\/div><div class="col-md-8 col-sm-8 col-lg-8">/-/;s/<\/div><\/div>/-/;s/+0700/-/;s/<\/div><div class="col-md-8 col-sm-8 col-lg-8">/-/;s/<\/div><\/div>/-/;s/+0700/-/g' ${LOGFILEPAT}
		
	#Отправка журнала на FTP-сервер
echo `date +'d.%m.%Y %H:%M:%S'` "- Файл на FTP-сервер Загружен!" >> $LOGFILEPAT
    cp "$LOGFILEPAT" /linuxcash/net/server/UTM_LOG

}
#ТЕЛО СКРИПТА

#Первое условие. Если справочники не выгрузились, то вырубаем УТМ и ФР.
	if [[ ($check2 -eq 0 && $check -eq 0) && (($PortTransport -eq 1 && $PortAgent -eq 1) || (( $VikiFile -eq 1 && $PortViki -eq 1 ) || ( $ShtrihFile -eq 1  && $PortShtrih -eq 1 ))) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` " - Справочники не выгрузились! МРЦ не встала!" >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "Не найдена позиция по 107.50 рублей check = "$check" и по 43.00 рублей chech2 = "$check2"" >> $LOGFILEPATH		
echo `date +'%d.%m.%Y %H:%M:%S'` " - Меняем порт УТМ на неверный" >> $LOGFILEPATH
		
		sed -i 's/utm.port=8082/utm.port=8080/g' /opt/utm/agent/conf/agent.properties
		sed -i 's/web.server.port=8082/web.server.port=8080/g' /opt/utm/transport/conf/transport.properties
		
if [ -f /linuxcash/cash/conf/drivers/hw::Serial_*.xml ]; then  sed -i 's/ttyS91/ttyS92/g' /linuxcash/cash/conf/drivers/hw::Serial_*.xml
		echo `date +'%d.%m.%Y %H:%M:%S'` "Меняем символическую ссылку на неверную для ВИКИ ПРИНТ" >> $LOGFILEPATH
		echo `date +'%d.%m.%Y %H:%M:%S'` "Перезапускаем кассувую программу" >> $LOGFILEPATH
			sudo pkill artix-gui
fi
if [ -f /linuxcash/cash/conf/drivers/hw::GenericTcp_*.xml ]; then sed -i 's/192.168.137.111/192.168.138.111/g' /linuxcash/cash/conf/drivers/hw::GenericTcp_*.xml
		echo `date +'%d.%m.%Y %H:%M:%S'` "Меняем IP на неверный для ШТРИХ-М" >> $LOGFILEPATH
			echo `date +'%d.%m.%Y %H:%M:%S'` "Перезапускаем кассувую программу" >> $LOGFILEPATH
			sudo pkill artix-gui
fi

#Запускаем передачу лог файла на FTP
sleep 1
	send_log "ERROR"		
echo `date +'%d.%m.%Y %H:%M:%S'` " - Перезапуск Supervisor" >> $LOGFILEPATH
		sudo service supervisor restart
	fi
	
#Второе условие. Если справочники выгрузились, то востанавливаем работу УТМ и ФР.
	if [[ ($check2 -ge 1 || $check -ge 1) && (($PortTransport -eq 0 && $PortAgent -eq 0) || (( $VikiFile -eq 1 && $PortViki -eq 0 ) || ( $ShtrihFile -eq 1 && $PortShtrih -eq 0 ))) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` "Справочники выгружены, МРЦ стоит!" >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "Найдена позиция по 107.50 рублей check = "$check" и по 43.00 рублей chech2 = "$check2"" >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "- Правим на нормальные порты УТМ" >> $LOGFILEPATH
	
		sed -i 's/utm.port=8080/utm.port=8082/g' /opt/utm/agent/conf/agent.properties
		sed -i 's/web.server.port=8080/web.server.port=8082/g' /opt/utm/transport/conf/transport.properties
		
if [ -f /linuxcash/cash/conf/drivers/hw::Serial_*.xml ]; then  sed -i 's/ttyS92/ttyS91/g' /linuxcash/cash/conf/drivers/hw::Serial_*.xml
		echo `date +'%d.%m.%Y %H:%M:%S'` "Меняем символическую ссылку на вернe. для ВИКИ ПРИНТ" >> $LOGFILEPATH
		echo `date +'%d.%m.%Y %H:%M:%S'` "Перезапускаем кассувую программу" >> $LOGFILEPATH
			sudo pkill artix-gui
fi
if [ -f /linuxcash/cash/conf/drivers/hw::GenericTcp_*.xml ]; then sed -i 's/192.168.138.111/192.168.137.111/g' /linuxcash/cash/conf/drivers/hw::GenericTcp_*.xml
		echo `date +'%d.%m.%Y %H:%M:%S'` "Меняем IP на верный для ШТРИХ-М" >> $LOGFILEPATH
		echo `date +'%d.%m.%Y %H:%M:%S'` "Перезапускаем кассувую программу" >> $LOGFILEPATH
			sudo pkill artix-gui
fi

#Запускаем передачу лог файла на FTP
sleep 1
	send_log "OK"		
		echo `date +'%d.%m.%Y %H:%M:%S'` "- Перезапускаем УТМ">> $LOGFILEPATH
	sudo service supervisor restart
	fi

#Третье условие. Если справочники не выгрузились, но уже были применены ограничения по продажам(просто информативный лог)	
	if [[ ($check2 -eq 0 && $check -eq 0) && (($PortTransport -eq 0 && $PortAgent -eq 0) && (( $VikiFile -eq 1 && $PortViki -eq 0 ) || ( $ShtrihFile -eq 1 && $PortShtrih -eq 0 ))) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` "Справочники не выгружены, порты уже поменяны на 8080." >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "Не найдена позиция по 107.50 рублей check = "$check" и по 43.00 рублей chech2 = "$check2"" >> $LOGFILEPATH

#Запускаем передачу лог файла на FTP
sleep 1
send_log "ERROR"
	fi
	
#Четвертое условие. Если справочники выгружены, то ничего не делать(просто информативный лог)		
	if [[ ($check2 -ge 1 || $check -ge 1) && (($PortTransport -eq 1 && $PortAgent -eq 1) && (( $VikiFile -eq 1 && $PortViki -eq 1 ) || ( $ShtrihFile -eq 1 && $PortShtrih -eq 1 ))) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` " - Справочники выгружены, порты уже поменяны на 8082." >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "Найдена позиция по 107.50 рублей check = "$check" и по 43.00 рублей chech2 = "$check2"" >> $LOGFILEPATH

#Запускаем передачу лог файла на FTP
sleep 1
send_log "OK"
	fi

#ПРОВЕРКА УТМ

#Проверяем порты УТМ
SumLines=$(echo "$(sudo netstat -tulpn|grep ::8192 && netstat -tulpn|grep ::8082 && netstat -tulpn|grep ::8193)" | wc -l)
Err=$(tail -n 50 /opt/utm/transport/l/transport_info.log|grep -w Ошибка | wc -l)
TokenNull=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w '0 but token only has 0 slots' | wc -l)
TokenOther=$(tail /opt/utm/updater/l/update.log|grep -w 'Не найден сертификат' |wc -l)
	
	if [ $SumLines = 3 ] ; then
echo `date +'d.%m.%Y %H:%M:%S'` "- ПОРТЫ АКТИВНЫ. УТМ РАБОТАЕТ. " >> $LOGFILEPAT
Log=OK_PORT
echo ""$LOGFILEPAT""
echo ""$filename""
		if [ $Err -eq 0 ] ; then
echo `date +'d.%m.%Y %H:%M:%S'` "- Ошибок в transport_info не нашлось!" >> $LOGFILEPAT
Log=OK_transport_info
			if [ $TokenNull -eq 0 ] ; then
echo `date +'d.%m.%Y %H:%M:%S'` "- Ключ определяется, драйвера работают" >> $LOGFILEPAT
Log=OK_Token	
				if [ $TokenOther -eq 0 ] ; then
echo `date +'d.%m.%Y %H:%M:%S'` "- Сертификат в порядке" >> $LOGFILEPAT
Log=OK
	else
echo `date +'%d.%m.%Y %H:%M:%S'` " УТМ НЕ РАБОТАЕТ ИЛИ РАБОТАЕТ НЕ КОРРЕКТНО! (SumLines = "$SumLines")" >> $LOGFILEPAT
Log=ERROR
				fi
	else
echo `date +'%d.%m.%Y %H:%M:%S'` " УТМ НЕ РАБОТАЕТ ИЛИ РАБОТАЕТ НЕ КОРРЕКТНО! (SumLines = "$SumLines")" >> $LOGFILEPAT
Log=ERROR
			fi
	else
echo `date +'%d.%m.%Y %H:%M:%S'` " УТМ НЕ РАБОТАЕТ ИЛИ РАБОТАЕТ НЕ КОРРЕКТНО! (SumLines = "$SumLines")" >> $LOGFILEPAT
Log=ERROR
		fi
	else
echo `date +'%d.%m.%Y %H:%M:%S'` " УТМ НЕ РАБОТАЕТ ИЛИ РАБОТАЕТ НЕ КОРРЕКТНО! (SumLines = "$SumLines")" >> $LOGFILEPAT
Log=ERROR
	fi
	
send_log_utm $Log


#if [[ -n `cat /etc/crontab | grep "mrcutmstatus"` ]]
#then
#   cat /etc/crontab | grep "mrcutmstatus"
#   read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
#   exit 2
#fi

#Организация CRONTAB. Устанавливает автозапуск скрипта на кассе.
sudo crontab -l | grep -v mrcutmstatus > /tmp/crontab.tmp
echo $Minutes $Hours \* \* \* $InstallPath\/mrcutmstatus.sh $InstallPath >> /tmp/crontab.tmp
sudo crontab < /tmp/crontab.tmp
sudo rm -f /tmp/crontab.tmp


exit 0

sleep 2
