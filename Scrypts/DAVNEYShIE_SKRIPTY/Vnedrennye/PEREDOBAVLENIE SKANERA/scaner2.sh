#! /bin/bash

LOGFILEPATH="/home/scaner_port.log"
Minute="*/1"
InstallPath="/root"

#echo `date +'%d.%m.%Y %H:%M:%S'` "- start" >> $LOGFILEPATH
#function cronscan {
#if [[ -n `cat /etc/crontab | grep "scaner"` ]]; then
#   cat /etc/crontab | grep "scaner"
#   read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
#   exit 2
#fi


#echo $Minute $Hour \* \* \* root $InstallPath\/easyegais2.sh $InstallPath >> /$
#crontab -l | grep -v scaner > /tmp/crontab.tmp
#echo $Minute \* \* \* \* $InstallPath\/scaner.sh $InstallPath >> /tmp/crontab.t$
#crontab < /tmp/crontab.tmp
#}

#echo "start3" >> $LOGFILEPATH

#echo $Minute $Hour \* \* \* root $InstallPath\/ogran.sh $InstallPath >> /etc/crontab
crontab -l | grep -v scaner2 > /tmp/crontab.tmp
echo $Minute \* \* \* \* $InstallPath\/scaner2.sh $InstallPath >> /tmp/crontab.tmp
crontab < /tmp/crontab.tmp
rm -f /tmp/crontab.tmp


		if grep "0403" /sys/bus/usb/drivers/usb/1-4.3.1/idVendor; then

	if grep "1-4.3.1:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
			
			echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
				exit 2;
		fi

echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH

		if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
	rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
		fi
		
		if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
	rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
		fi
		
		if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
	rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
		fi
		
		if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
	rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
		fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/
sed -i 's/<value>1-4.2.3:1.0/<value>1-4.3.1:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
#echo "start 4">> $LOGFILEPATH
		fi



		if grep "0403" /sys/bus/usb/drivers/usb/1-4.3.2/idVendor; then

if grep "1-4.3.2:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH


#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.3.2:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.3.3/idVendor; then

if grep "1-4.3.3:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH

#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.3.3:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.3.4/idVendor; then

if grep "1-4.3.4:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH



#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.3.4:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi


if grep "0403" /sys/bus/usb/drivers/usb/1-4.2.1/idVendor; then

if grep "1-4.2.1:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH

#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/


sed -i 's/<value>1-4.2.3:1.0/<value>1-4.2.1:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.2.2/idVendor; then

if grep "1-4.2.2:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH



#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.2.2:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.2.3/idVendor; then

if grep "1-4.2.3:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH


#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.2.3:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.2.4/idVendor; then

if grep "1-4.2.4:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi

echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH


#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.2.4:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi


if grep "0403" /sys/bus/usb/drivers/usb/1-2/idVendor; then

if grep "1-2:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH


#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-2:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.3/idVendor; then

if grep "1-4.3:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi

echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH


#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.3:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.2/idVendor; then

if grep "1-4.2:1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH

#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/


sed -i 's/<value>1-4.2.3:1.0/<value>1-4.2:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml
fi

if grep "0403" /sys/bus/usb/drivers/usb/1-4.1/idVendor; then

if grep "1-4.1.0" /linuxcash/cash/conf/drivers/hw::UsbSerial_*; then
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера совпадают, завершение работы" >> $LOGFILEPATH
#cronscan
exit 2;
fi
echo `date +'%d.%m.%Y %H:%M:%S'` "порты сканера не совпадают, переустановка драйвера" >> $LOGFILEPATH


#echo "start 4">> $LOGFILEPATH

if find /linuxcash/cash/conf/drivers -name "hw::UsbSerialFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerialFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::UsbSerial_*"; then
rm /linuxcash/cash/conf/drivers/hw::UsbSerial_*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScannerFactory*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScannerFactory*
fi
if find /linuxcash/cash/conf/drivers -name "hw::DatalogicScanner_*"; then
rm /linuxcash/cash/conf/drivers/hw::DatalogicScanner_*
fi

cp /root/hw::DatalogicScannerFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::DatalogicScanner_1.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerialFactory.xml /linuxcash/cash/conf/drivers/
cp /root/hw::UsbSerial_1.xml /linuxcash/cash/conf/drivers/

sed -i 's/<value>1-4.2.3:1.0/<value>1-4.1:1.0/g' /linuxcash/cash/conf/drivers/hw::UsbSerial_1.xml

fi

if [[ ! -n `lsusb | grep "0403:6001"` ]]  
then
echo "Scaner otsytstvuet!" >> $LOGFILEPATH
exit 2;
fi

pkill artix-gui
#cronscan
