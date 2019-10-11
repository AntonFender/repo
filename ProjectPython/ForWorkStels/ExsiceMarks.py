# -*- coding: utf-8 -*-
# coding: utf8

import os
import re
import pymysql
import paramiko
import pandas as pd
import pandas
from paramiko import SSHClient
from sshtunnel import SSHTunnelForwarder
from os.path import expanduser


roadCS = "ssh root@192.168.0.15"


FSRAR_ID = input("Введите FSRAR_ID( Пример: 020000111222) кассы: ")

##Подключение к mysql
def ssh_Mysql(FSRAR_ID):

    sql_hostname = 'cashsrv'
    sql_username = 'root'
    sql_password = 'root'
    sql_main_database = 'documentsAll'
    sql_port = 3306
    sql_ip = 'cashsrv'
    sql_host='127.0.0.1'

    ssh_host = 'cashsrv'
    ssh_user = 'root'
    ssh_port = 22
    ssh_password1='Ma4u-Pik4u'



    with SSHTunnelForwarder(
            (ssh_host, ssh_port),
            ssh_username = sql_username,
            ssh_password = ssh_password1,
        
            remote_bind_address = (sql_host, sql_port)) as tunnel:
        conn = pymysql.connect(host=sql_host, user=sql_username,
                passwd=sql_password, db=sql_main_database,
                port=tunnel.local_bind_port)
    
##        query1 = '''SET @row_number = 0;SELECT (@row_number:=@row_number + 1) AS num, cashcode, excisemark, alcocode from goodsitem WHERE cashcode LIKE "''' + FSRAR_ID + '''1''' + '''" INTO OUTFILE "/var/lib/mysql-files/''' + FSRAR_ID + '''.csv" FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' LINES TERMINATED BY "\\r\\n";'''
        try:
            query1 = '''SELECT @i:=@i+1 num, cashcode, excisemark, alcocode from goodsitem, (SELECT @i:=0) X WHERE cashcode LIKE "''' + FSRAR_ID + '''1''' + '''" INTO OUTFILE "/var/lib/mysql-files/''' + FSRAR_ID + '''.csv" FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' LINES TERMINATED BY "\\r\\n";'''
            print ("Формирую список марок")
            data1 = pd.read_sql_query(query1, conn)
            
        except:
            print ("Список сформирован!")
            conn.close()

def CopyFile ():
    
    os.chdir("C:\\OpenSSH")

    CopyWithPath = "mv /var/lib/mysql-files/"
    CopyToPath = "/opt/testDir/marki/"

    CopyMark = CopyWithPath + FSRAR_ID + ".csv" + " " + CopyToPath

    СommandCopyMark = roadCS + " \"" + CopyMark + "\""

    os.system(СommandCopyMark)

    

##Формирования списка марок
ssh_Mysql(FSRAR_ID)
##Копирование списка в доступную директорию
CopyFile ()
input('\nНажмите Enter для выхода\n')

##Выход из консоли:

