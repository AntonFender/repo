#! /bin/bash
#
LOGFILEPATH="/home/user/ADMIN/CRON/restarter.log"

echo `date +'%d.%m.%Y %H:%M:%S'` "- start" >> $LOGFILEPATH

SumLines=$(echo "$(sudo netstat -tulpn|grep ::8192 && netstat -tulpn|grep ::8082 && netstat -tulpn|grep ::8193)" | wc -l)
if [ $SumLines = 3 ] ; then
	echo `date +'d.%m.%Y %H:%M:%S'` "- ok UTM" >> $LOGFILEPATH
else
	echo `date +'%d.%m.%Y %H:%M:%S'` "- UTM is not running, run UTM... (SumLines = "$SumLines")" >> $LOGFILEPATH
	sudo /etc/init.d/monitoring restart &>/dev/null	
	sudo /etc/init.d/updater restart &>/dev/null
	sudo /etc/init.d/utm restart &>/dev/null
	if [ $? -ne 0 ] ; then
		echo `date +'%d.%m.%Y %H:%M:%S'` "- error run UTM (SumLines = "$SumLines")" >> $LOGFILEP
	else 
		echo `date +'%d.%m.%Y %H:%M:%S'` "- UTM launched successfully (SumLines = "$SumLines")" >> $LOGFILEPATH
	fi		
fi

Err=$(tail -n 50 /opt/utm/transport/l/transport_info.log|grep -w Ошибка | wc -l)
if [ $Err -eq 0 ] ; then
	echo `date +'d.%m.%Y %H:%M:%S'` "- Ошибок нет" >> $LOGFILEPATH
else
echo `date +'%d.%m.%Y %H:%M:%S'` "- UTM is not running, run UTM... (Err = "$Err")" >> $LOGFILEPATH
	sudo /etc/init.d/monitoring restart &>/dev/null	
	sudo /etc/init.d/updater restart &>/dev/null
	sudo /etc/init.d/utm restart &>/dev/null
	if [ $? -ne 0 ] ; then
		echo `date +'%d.%m.%Y %H:%M:%S'` "- error run UTM (Err = "$Err")" >> $LOGFILEPATH
	else 
		echo `date +'%d.%m.%Y %H:%M:%S'` "- UTM launched successfully (Err = "$Err")" >> $LOGFILEPATH
	fi		
fi

TokenNull=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w '0 but token only has 0 slots' | wc -l)
if [ $TokenNull -eq 0 ] ; then
	echo `date +'d.%m.%Y %H:%M:%S'` "- Токен вставлен" >> $LOGFILEPATH
else
echo `date +'%d.%m.%Y %H:%M:%S'` "- Токен не вставлен, run UTM... (TokenNull = "$TokenNull")" >> $LOGFILEPATH
	sudo /etc/init.d/monitoring restart &>/dev/null	
	sudo /etc/init.d/updater restart &>/dev/null
	sudo /etc/init.d/utm restart &>/dev/null
	if [ $? -ne 0 ] ; then
		echo `date +'%d.%m.%Y %H:%M:%S'` "- error run UTM (TokenNull = "$TokenNull")" >> $LOGFILEPATH
	else 
		echo `date +'%d.%m.%Y %H:%M:%S'` "- UTM launched successfully (TokenNull = "$TokenNull")" >> $LOGFILEPATH
	fi		
fi

TokenOther=$(tail /opt/utm/updater/l/update.log|grep -w 'Не найден сертификат' |wc -l)
if [ $TokenOther -eq 0 ] ; then
	echo `date +'d.%m.%Y %H:%M:%S'` "- Сертификат в порядке" >> $LOGFILEPATH
else
echo `date +'%d.%m.%Y %H:%M:%S'` "- Не найден сертификат, run UTM... (TokenOther = "$TokenOther")" >> $LOGFILEPATH
	sudo /etc/init.d/monitoring restart &>/dev/null	
	sudo /etc/init.d/updater restart &>/dev/null
	sudo /etc/init.d/utm restart &>/dev/null
	if [ $? -ne 0 ] ; then
		echo `date +'%d.%m.%Y %H:%M:%S'` "- error run UTM (TokenOther = "$TokenOther")" >> $LOGFILEPATH
	else 
		echo `date +'%d.%m.%Y %H:%M:%S'` "- UTM launched successfully (TokenOther = "$TokenOther")" >> $LOGFILEPATH
	fi		
fi

sleep 300
done
