#!/bin/bash

if [ -s /root/PackageFlag ] ; then
        echo "This package has been installed"
        exit
    else
	    /usr/bin/dpkg --force-confnew -i /root/libcurl3-gnutls_7.35.0-1ubuntu2.20_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/apt-transport-https_1.0.1ubuntu2.23_i386.deb
        rm /root/PackageFlag
fi
