#! /bin/bash


TokenNull=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w '0 but token only has 0 slots' | wc -l)
TokenOther=$(tail /opt/utm/updater/l/update.log|grep -w 'Не найден сертификат' |wc -l)
TokenCert=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'RSA сертификаты не найдены' |wc -l)

TokenPKI=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'PKI хранилище не содержит подходящего сертификата' |wc -l)
TokenRem=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'Token has been removed' |wc -l)
TokenDriver=$(tail -n 50 /opt/utm/updater/l/update.log|grep -w 'Ключ не найден или не успели загрузиться все драйвера' |wc -l)

if [ $TokenNull -gt 0 ] ; then
	echo "Ключ(ЕГАИС) не вставлен"

elif [ $TokenOther -gt 0 ] ; then
	echo "Не найден сертификат"
	
elif [ $TokenCert -gt 0 ] ;then
	echo "RSA сертификаты не найдены"
	
elif [ $TokenPKI -gt 0 ] ;then	
	echo "PKI хранилище не содержит подходящего сертификата"
	
elif [ $TokenRem -gt 0 ] ;then
	echo "Рутокен отвалился!"
	
elif [ $TokenDriver -gt 0 ] ;then
	echo "Не загрузились драйвера на ключ!"

elif [ ! -f /opt/utm/updater/l/update.log ];then
	echo "ЕГАИС отсутствует на кассе"	
		
else
	echo "Ключ ЕГАИС работает"
fi





