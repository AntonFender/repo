#!/bin/bash

if [ -f /root/FlagCurl ] ; then
        echo "This package has been installed"
        exit
    else
	touch FlagCurl
        echo "install a new package of curl"
        aptitude -y purge curl
        aptitude -y purge libcurl3
		aptitude -y purge librtmp0
        /usr/bin/dpkg --force-confnew -i /root/curl_7.35.0-1ubuntu2.7_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/libcurl3_7.35.0-1ubuntu2.7_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/librtmp0_2.4+20121230.gitdf6c518-1_i386.deb
fi
