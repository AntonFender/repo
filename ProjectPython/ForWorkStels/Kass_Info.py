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


IP = input("Введите последние IP кассы: ")
RoadKassa = "ssh -o" + " " "StrictHostKeyChecking=no" + " " +  "root@" + IP

def CreateCert():

##Подключение к SSH:
    
    os.chdir("C:\\OpenSSH")

##Команды для запросов по SSH:
    
    Command1 = "tail -n 50 /opt/utm/transport/l/transport_info.log"
    Qwerty1 = RoadKassa + " "  + "\"" + Command1 + "\""
    Command2 = "tail -n 50 /opt/utm/updater/l/update.log"
    Qwerty2 = RoadKassa + " "  + "\"" + Command2 + "\""
    Command3 = "ls /root/easyegais22/log/"
    Qwerty3 = RoadKassa + " "  + "\"" + Command3 + "\""
    Command4 = "ls /root/easyegais2/log/"
    Qwerty4 = RoadKassa + " "  + "\"" + Command4 + "\""

##ЛОГ ТРАНСПОРТА:
    
    print("Вывод лога транспорта: " + Qwerty1 + "\n")
    res1 = Popen(Qwerty1, shell=True, stdout=PIPE)
    out1 = str(res1.communicate()[0].decode("utf8"))
    print ("ПОСЛЕДНИЕ 50 СТРОК ЛОГА UTM TRANSPORT_INFO.LOG:\n\n " + out1)

##ЛОГ UPDATER:
    
    print("Вывод лога updater: " + Qwerty1 + "\n")
    res2 = Popen(Qwerty2, shell=True, stdout=PIPE)
    out2 = str(res2.communicate()[0].decode("utf8"))
    print ("ПОСЛЕДНИЕ 50 СТРОК ЛОГА UTM UPDATER.LOG:\n\n " + out2)

##Содержимое easyegais2:

    print("Вывод списка easyegais22: " + Qwerty3 + "\n")
    res3 = Popen(Qwerty3, shell=True, stdout=PIPE)
    out3 = str(res3.communicate()[0].decode("utf8"))
    print ("СОДЕРЖИМОЕ ПАПКИ EASYEGAIS22:\n\n " + out3)


##Содержимое easyegais22:

    print("Вывод списка easyegais2: " + Qwerty3 + "\n")
    res4 = Popen(Qwerty4, shell=True, stdout=PIPE)
    out4 = str(res4.communicate()[0].decode("utf8"))
    print ("СОДЕРЖИМОЕ ПАПКИ EASYEGAIS2:\n\n " + out4)


##Выход из консоли:
    input('\nНажмите Enter для выхода\n')
    


CreateCert()
 
















