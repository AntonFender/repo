#!/bin/bash

if [ -s /root/egaisFlag ] ; then
        echo "This package has been installed"
        exit
    else
        echo "install a new package of utm"
        aptitude -y purge artix45-egais
        aptitude -y purge u-trans
        rm -rf /opt/utm
        /usr/bin/dpkg --force-confnew -i /root/idprotectclient_637.03-0_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/jcgostclient_1.5.3_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/libccid_1.4.15-1_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/pcscd_1.8.10-1ubuntu1_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/python-meld3_0.6.10-1_i386.deb
        /usr/bin/dpkg --force-confnew -i /root/supervisor_3.0b2-1ubuntu0.1_all.deb
        /usr/bin/dpkg --force-confnew -i /root/u-trans-3_0_8.deb
        rm /root/egaisFlag
fi
