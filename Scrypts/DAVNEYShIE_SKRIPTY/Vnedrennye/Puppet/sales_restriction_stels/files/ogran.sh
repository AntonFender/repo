#! /bin/bash
#

LOGFILEPATH="/root/ogran_prodaj.log"
Minute="*/30"
InstallPath="/root"

#Первый варант
#mysql <<EOF | sed -e 's/   /,/g' | tee list.txt
#use dictionaries
#select name,minprice from tmc WHERE minprice in(43.00,107.50) AND ((name LIKE '%38%%' OR name LIKE '%40%%') AND (name LIKE '%0,1%' OR name LIKE '%0,25%')) ORDER BY minprice DESC
#EOF
#Второй вариант
mysql -D dictionaries -e "select name,minprice from tmc WHERE minprice in(43.00,107.50) AND ((name LIKE '%Водка%' OR name LIKE '%водка%') AND (name LIKE '%0,1%' OR name LIKE '%0,25%')) ORDER BY minprice DESC" > list.txt


#Примечание:
#Секунды расчитываются с даты 00:00:00 1970-01-01
#т.е колличество секунд прошудших от 00:00:00 1970-01-01 до текущей даты.

#Задаем переменные
#
#date1="2019-01-01 00:01:00"
#date2="`date +%s`"
#check=$(tail -n 50 /root/list.txt|grep -w 4600855118934 | wc -l)
#
#Вывод сообщения в консоль
#
#	echo "Проверка даты"
#	echo "Текущая Дата и Время - "`date +'%d-%m-%Y %H:%M:%S'`" Дата и Время ограничения - "$date1""
#	echo "Текущая Дата и Время в секундах -" "$date2" "Дата и Время срабатывания ограничения -" `date -d "$date1" +%s`
#	
#Запись сообщений в лог файл
#
#			echo "Проверка даты" >> $LOGFILEPATH
#			echo " Текущая Дата и Время - "`date +'%d-%m-%Y %H:%M:%S'`"  Дата и Время ограничения - "$date1"" >> $LOGFILEPATH
#			echo "Текущая Дата и Время в секундах -" "$date2" "Дата и Время срабатывания ограничения -" `date -d "$date1" +%s` >> $LOGFILEPATH



#Задаем условия проверки ограничения по продажам если не выгрузился справочник
#Задаем переменные

PortAgent=$(echo "$(tail -n 50 /opt/utm/agent/conf/agent.properties|grep "utm.port=8082" | wc -l)")
PortTransport=$(echo "$(tail -n 50 /opt/utm/transport/conf/transport.properties|grep "web.server.port=8082" | wc -l)")
check=$(tail -n 50 /root/list.txt|grep -w 107.50 | wc -l)
check2=$(tail -n 50 /root/list.txt|grep -w 43.00 | wc -l)

	if [[ ($check2 -eq 0 && $check -eq 0) && ($PortTransport -eq 1 && $PortAgent -eq 1) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` " - Справочники не выгрузились! МРЦ не встала!" >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "Не найдена позиция по 107.50 рублей check = "$check" и по 43.00 рублей chech2 = "$check2"" >> $LOGFILEPATH		
echo `date +'%d.%m.%Y %H:%M:%S'` " - Меняем порт УТМ на неверный" >> $LOGFILEPATH
		
		sed -i 's/utm.port=8082/utm.port=8080/g' /opt/utm/agent/conf/agent.properties
		sed -i 's/web.server.port=8082/web.server.port=8080/g' /opt/utm/transport/conf/transport.properties
		
echo `date +'%d.%m.%Y %H:%M:%S'` " - Перезапуск Supervisor" >> $LOGFILEPATH
		sudo service supervisor restart
	fi
	
	
	if [[ ($check2 -ge 1 || $check -ge 1) && ($PortTransport -eq 0 && $PortAgent -eq 0) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` "Справочники выгружены, МРЦ стоит!" >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "Найдена позиция по 107.50 рублей check = "$check" и по 43.00 рублей chech2 = "$check2"" >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "- Правим на нормальные порты УТМ">> $LOGFILEPATH
	
		sed -i 's/utm.port=8080/utm.port=8082/g' /opt/utm/agent/conf/agent.properties
		sed -i 's/web.server.port=8080/web.server.port=8082/g' /opt/utm/transport/conf/transport.properties

echo `date +'%d.%m.%Y %H:%M:%S'` "- Перезапускаем УТМ">> $LOGFILEPATH
	sudo service supervisor restart
	fi
	
	if [[ ($check2 -eq 0 && $check -eq 0) && ($PortTransport -eq 0 && $PortAgent -eq 0) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` " - Справочники не выгружены, порты уже поменяны на 8080." >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "check = "$check"  chech2 = "$check2"" >> $LOGFILEPATH
	fi
	
	if [[ ($check2 -ge 1 || $check -ge 1) && ($PortTransport -eq 1 && $PortAgent -eq 1) ]]; then
	
echo `date +'%d.%m.%Y %H:%M:%S'` " - Справочники выгружены, порты уже поменяны на 8082." >> $LOGFILEPATH
echo `date +'%d.%m.%Y %H:%M:%S'` "check = "$check"  chech2 = "$check2"" >> $LOGFILEPATH
	fi


#echo $Minute $Hour \* \* \* root $InstallPath\/ogran.sh $InstallPath >> /etc/crontab
crontab -l | grep -v ogran > /tmp/crontab.tmp
echo $Minute \* \* \* \* $InstallPath\/ogran.sh $InstallPath >> /tmp/crontab.tmp
crontab < /tmp/crontab.tmp
rm -f /tmp/crontab.tmp

exit 0

sleep 2
