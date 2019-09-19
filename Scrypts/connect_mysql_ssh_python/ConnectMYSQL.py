# -*- coding: utf-8 -*-
# coding: utf8

import pymysql
import paramiko
import pandas as pd
from paramiko import SSHClient
from sshtunnel import SSHTunnelForwarder
from os.path import expanduser

##home = expanduser('~')
##mypkey = paramiko.RSAKey.from_private_key_file(home + pkeyfilepath)
# if you want to use ssh password use - ssh_password='your ssh password', bellow

ID_kassa = input("Введите ID_cash кассы: ")
##Commanda1 = select SUM(sumSale) from workshift WHERE cashId LIKE "%_cash_0200006018791_7a253207%" AND (time_beg >= '2019-01-19' AND time_beg <= '2019-07-19');

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
    
    query = '''select SUM(sumSale) from workshift WHERE cashId LIKE "%''' + ID_kassa + '''%" AND (time_beg >= '2019-01-19' AND time_beg <= '2019-07-19');'''
    print (query)
    data = pd.read_sql_query(query, conn)
    
    print (data)
    conn.close()

##Выход из консоли:
input('\nНажмите Enter для выхода\n')
