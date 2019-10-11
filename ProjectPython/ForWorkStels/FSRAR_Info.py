import os
import sys
import io
import codecs
import locale
import subprocess
from subprocess import *
import re


FSRAR = input("Введите последние 6 цифр FSRAR кассы: ")
roadCS = "ssh root@192.168.0.15"
roadPuppet = "ssh root@192.168.0.12"

def CreateCert():

##Подключение к SSH:
    
    os.chdir("C:\\OpenSSH")

##Команды для запросов по SSH:
    
    Command1 = "cat /etc/openvpn/ipp.txt | grep" + " " + FSRAR
    Qwerty1 = roadCS + " "  + "\"" + Command1 + "\""
    Command2 = "ls /opt/certificate | grep" + " " + FSRAR
    Qwerty2 = roadCS + " "  + "\"" + Command2 + "\""
    Command3 = "find \/ -iname" + " \'" + "*" + FSRAR + "*" + "\'"
    Qwerty3 = roadPuppet + " "  + "\"" + Command3 + "\""

##Формирование и вывод IP на экран:
    
##    print("Выполняю комманду определения IP: " + Qwerty1 + "\n")
    res1 = Popen(Qwerty1, shell=True, stdout=PIPE)
    out1 = str(res1.communicate()[0].decode("CP866"))
    result = (str(re.findall(r'[0-9]+(?:\.[0-9]+){3}', out1)))
    print ("\nIP адрес кассы:\n\n " + result + "\n")

##Проверка на наличие сертификата в директории:
    
##    print("Проверка на наличие сертификата в директории: " + Qwerty2 + "\n")
    res2 = Popen(Qwerty2, shell=True, stdout=PIPE)
    out2 = str(res2.communicate()[0].decode("CP866"))
    print ("Наличие сертификатов(на КС) в директории /opt/certificate/:\n\n " + out2)

##Проверка на наличие сертификата ssl на PUPPET:

    res3 = Popen(Qwerty3, shell=True, stdout=PIPE)
    out3 = str(res3.communicate()[0].decode("CP866"))
    print ("Наличие сертификатов на puppet(ДОЛЖНО БЫТЬ 11):\n\n ")
##    for line in out3.split():
##        print (line)
    for i, line in enumerate(out3.split()):
##        for i, item in enumerate(line):
        print(i + 1,")  " + line)
            
    


##Выход из консоли:
    input('\nНажмите Enter для выхода\n')
    


CreateCert()
 
















