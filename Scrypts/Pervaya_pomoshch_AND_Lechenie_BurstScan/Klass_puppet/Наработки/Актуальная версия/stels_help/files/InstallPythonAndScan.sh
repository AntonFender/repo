#!/bin/bash

if [ ! -d /opt/FirstHelpAndScan/driverssource ]; then
mkdir -p /opt/FirstHelpAndScan/driverssource
fi

if [ -f /opt/driverssource.tar.gz ]; then
cd /opt/FirstHelpAndScan/driverssource
mv /opt/driverssource.tar.gz /opt/FirstHelpAndScan
tar -zxvf /opt/FirstHelpAndScan/driverssource.tar.gz
fi



/usr/bin/dpkg --force-confnew -i /var/cache/apt/archives/python-tk_2.7.5-1ubuntu1_i386.deb
/usr/bin/dpkg --force-confnew -i /var/cache/apt/archives/liblcms2-2_2.5-0ubuntu4.2_i386.deb
/usr/bin/dpkg --force-confnew -i /var/cache/apt/archives/libwebp5_0.4.0-4_i386.deb
/usr/bin/dpkg --force-confnew -i /var/cache/apt/archives/libwebpmux1_0.4.0-4_i386.deb
/usr/bin/dpkg --force-confnew -i /var/cache/apt/archives/python-pil_2.3.0-1ubuntu3.4_i386.deb
/usr/bin/dpkg --force-confnew -i /var/cache/apt/archives/python-imaging_2.3.0-1ubuntu3.4_all.deb

