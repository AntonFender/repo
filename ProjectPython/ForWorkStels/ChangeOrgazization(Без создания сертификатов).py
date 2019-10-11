# -*- coding: utf-8 -*-
# coding: utf8

import os
import sys
import io
import codecs
import locale
import subprocess
from subprocess import *
import re



IP = input("Введите IP кассы: ")
FSRAR_ID_NEW = input("Введите Новый FSRAR_ID____БЕЗ НУЛЯ впереди!: ")
FSRAR_ID_OLD = input("Введите Старый FSRAR_ID____БЕЗ НУЛЯ впереди!: ")
RoadKassa = "ssh -o" + " " "StrictHostKeyChecking=no" + " " +  "root@" + IP
roadCS = "ssh root@192.168.0.15"
roadPuppet = "ssh root@192.168.0.12"



##Подключение к SSH:
    
os.chdir("C:\\OpenSSH")

##Создание нового VPN сертификата на КС

def CreateCertVpnOnKS():

    Command8 = "/opt/certificate/gencert.sh" + " " + "cash-" + FSRAR_ID_NEW + "-" + FSRAR_ID_NEW + "1"
    Qwerty8 = roadCS + " "  + "\"" + Command8 + "\""    
    print("Создание нового VPN сертификата на КС: " + Qwerty8 + "\n")
    res8 = Popen(Qwerty8, shell=True, stdout=PIPE)
    out8 = str(res8.communicate()[0].decode("utf8"))
    print ("Создание нового VPN сертификата на КС:\n\n " + out8)    

    

##Удаление сертификатов на Puppet    

def DelCertPuppet():

    Command6 = "puppet cert clean" + " " + "cash-" + FSRAR_ID_OLD + "-" + FSRAR_ID_OLD + "1"
    Qwerty6 = roadPuppet + " "  + "\"" + Command6 + "\""
    print("Удаление старых сертификатов на Puppet: " + Qwerty6 + "\n")
    res6 = Popen(Qwerty6, shell=True, stdout=PIPE)
    out6 = str(res6.communicate()[0].decode("utf8"))
    print ("Удаление старых сертификатов на Puppet:\n\n " + out6)

    Command9 = "puppet cert clean" + " " + "cash-" + FSRAR_ID_NEW + "-" + FSRAR_ID_NEW + "1"
    Qwerty9 = roadPuppet + " "  + "\"" + Command9 + "\""
    print("Удаление новых(если есть) сертификатов на Puppet: " + Qwerty9 + "\n")
    res9 = Popen(Qwerty9, shell=True, stdout=PIPE)
    out9 = str(res9.communicate()[0].decode("utf8"))
    print ("Удаление новых(если есть) сертификатов на Puppet:\n\n " + out9)


##Переименовываем кассу:
def per():

    Command1 = "sed -i 's/[0-9]\{12\}/" + "0" + FSRAR_ID_NEW + "/g'" + " " + "/linuxcash/cash/data/cash.reg" + " && " + "sed -i 's/[0-9]\{11\}/" + FSRAR_ID_NEW + "/g'" + " " + "/etc/hosts" + " && " + "sed -i 's/[0-9]\{11\}/" + FSRAR_ID_NEW + "/g'" + " " + "/etc/hostname" + " && " + "sed -i 's/[0-9]\{11\}/" + FSRAR_ID_NEW + "/g'" + " " + "/etc/puppet/puppet.conf" + " && " + "service hostname restart"
    Qwerty1 = RoadKassa + " "  + "\"" + Command1 + "\""
    print("Переименовываем кассу: " + Qwerty1 + "\n")
    res1 = Popen(Qwerty1, shell=True, stdout=PIPE)
    out1 = str(res1.communicate()[0].decode("utf8"))
    print ("Переименовываем кассу:\n\n " + out1)

##Запускаем puppet agent:

def agent():

    Command3 = "sudo rm -rf /var/lib/puppet/ssl && sudo pkill artix-gui && sudo service puppet restart && sleep 20 && sudo puppet agent -t"
    Qwerty3 = RoadKassa + " "  + "\"" + Command3 + "\""
    print("Запуск puppet: " + Qwerty3 + "\n")
##    res3 = Popen(Qwerty3, shell=True, stdout=PIPE)
##    out3 = str(res3.communicate()[0].decode("utf8"))
    print ("Запуск puppet:\n\n ")
    os.system(Qwerty3)


##Удаляем старые сертификаты VPN из кассы:

def vpn():

    Command2 = "rm -f /etc/openvpn/" + "*" + FSRAR_ID_OLD + "*.*" + " " + "&&" + " " + "rm -f /var/run/openvpn/" + "*" + FSRAR_ID_OLD + "*.*"
    Qwerty2 = RoadKassa + " "  + "\"" + Command2 + "\""
    print("Удаляем старые сертификаты VPN из кассы: " + Qwerty2 + "\n")
    res2 = Popen(Qwerty2, shell=True, stdout=PIPE)
    out2 = str(res2.communicate()[0].decode("utf8"))
    print ("Удаляем старые сертификаты VPN из кассы:\n\n " + out2)


##Инициализация данных в БД:

def BD():
    
    Command4 = "mysql -uroot dictionaries < /linuxcash/cash/tools/tools_avail/initial_data/dictionaries-full.sql"
    Qwerty4 = RoadKassa + " "  + "\"" + Command4 + "\""
    print("Инициализация данных в БД: " + Qwerty4 + "\n")
    res4 = Popen(Qwerty4, shell=True, stdout=PIPE)
    out4 = str(res4.communicate()[0].decode("utf8"))
    print ("Инициализация данных в БД:\n\n " + out4)


##Вывести список IP адресов:

def ip():

    Command5 = "sudo ifconfig | grep" + " " + "\'" + "inet addr" + "\'"
    Qwerty5 = RoadKassa + " "  + "\"" + Command5 + "\""    
    print("Вывести список IP адресов: " + Qwerty5 + "\n")
    res5 = Popen(Qwerty5, shell=True, stdout=PIPE)
    out5 = str(res5.communicate()[0].decode("utf8"))
    print ("Вывести список IP адресов:\n\n " + out5)


##Удаление старого сертификата VPN на КС:

def DelCertVPN():

    Command7 = "cd /opt/certificate/" + " && " +  "svn del" + " " + "cash-" + FSRAR_ID_OLD + "-" +  FSRAR_ID_OLD + "1" + ".crt" + " " + "cash-" + FSRAR_ID_OLD + "-" +  FSRAR_ID_OLD + "1" + ".csr" + " " + "cash-" + FSRAR_ID_OLD + "-" +  FSRAR_ID_OLD + "1" + ".key" + " && " + "svn commit -m" + " " + "\'" + "del bag cert" + "\'"
    Qwerty7 = roadCS + " "  + "\"" + Command7 + "\""    
    print("Удаление старого сертификата VPN на КС: " + Qwerty7 + "\n")
    res7 = Popen(Qwerty7, shell=True, stdout=PIPE)
    out7 = str(res7.communicate()[0].decode("utf8"))
    print ("Удаление старого сертификата VPN на КС:\n\n " + out7)    

##CreateCertVpnOnKS()     ##Создаем сертификат VPN на КС
#DelCertPuppet()         ##Удаляем старый и новый сертификат Puppet
#per()                   ##Прописываем везде новый FSRAR на кассе
#agent()                 ##Запуск агента Puppet
vpn()                   ##Удалить старые сертификаты vpn
BD()                    ##Инициализация данных в БД
ip()                    ##Вывести список IP адресов
DelCertVPN()            ##Удалить старый сертификат VPN

##Выход из консоли:
input('\nНажмите Enter для выхода\n')
 
















