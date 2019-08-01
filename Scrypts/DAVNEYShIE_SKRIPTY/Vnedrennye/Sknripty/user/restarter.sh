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
		echo `date +'%d.%m.%Y %H:%M:%S'` "- error run UTM (SumLines = "$SumLines")" >> $LOGFILEPATH
	else 
		echo `date +'%d.%m.%Y %H:%M:%S'` "- UTM launched successfully (SumLines = "$SumLines")" >> $LOGFILEPATH
	fi		
fi
sleep 300
done
