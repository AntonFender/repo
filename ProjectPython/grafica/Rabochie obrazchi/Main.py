#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fileencoding=utf-8

import sys
import time
import pymysql
import string
import re

from PyQt4 import QtCore, QtGui
from PyQt4.QtCore import SIGNAL
from PyQt4.QtGui import QApplication, QMainWindow, QFont
from kassa1 import Ui_MainWindow

#Для работы с РУССКИМ МАТЬ ЕГО ЯЗЫКОМ ДЛЯ UBUNTU:

reload(sys)
sys.setdefaultencoding('utf8')


class MainWindow(QMainWindow, Ui_MainWindow):
	def __init__(self, parent=None, *args, **kwargs):

		QMainWindow.__init__(self)
		self.setupUi(self)
		self.TextEdit21()
		self.connect(self.pushButton, SIGNAL('clicked()'), self.ButtonKnopka)


##Вывод информации что надо вводить в поле ввода:
	def TextEdit21(self):

		Name_Kassir1 = "Введите имя кассира (Иванов И.И.)"
		Inn_Kassir1 = "Введите ИНН кассира (Не обязательно)"

##Для Ubuntu
		self.NameKassir.setPlaceholderText(Name_Kassir1.decode('utf8'))
		self.InnKassir.setPlaceholderText(Inn_Kassir1.decode('utf8'))

##Для Windows
		#self.NameKassir.setPlaceholderText(Name_Kassir1)
		#self.InnKassir.setPlaceholderText(Inn_Kassir1)


##Метод, который вызывается нажатием на кнопку:

	def ButtonKnopka(self):

##Считываем ФИО пользователя:
		Name_Kassir = self.NameKassir.text()
		print(Name_Kassir)

##Считываем ИНН пользователя:
		Inn_Kassir = self.InnKassir.text()
		print(Inn_Kassir)


		#tr = "INSERT INTO `dictionaries`.`mol`(`code`, `login`, `name`, `password`, `locked`, `inn`) VALUES ('9', '9', " + "\'" + str(Name_Kassir) + "\'" + ", '9', 0, " + "\'" + str(Inn_Kassir) + "\'" + ")"
		#print(tr)

#Подключаемся к MYSQL
		conn = pymysql.connect(host='127.0.0.1', port=3306,
		user='root', passwd='', db='dictionaries')
		cursor = conn.cursor(pymysql.cursors.DictCursor)

#Считывание Порядка заведения code,login, password

	#Ориентироваться по количеству строк в столбце code
		#SQL_id = "SELECT code FROM mol"
		#cursor.execute(SQL_id)
		#KolichestvoStrok = cursor.rowcount
		#print (KolichestvoStrok)

	#Через регулярки

		SQL_id = "SELECT max(code) AS max_code FROM mol"
		cursor.execute(SQL_id)
		data = cursor.fetchall()
		DataRe = int(re.search(r'\d+', str(data)).group(0)) + 1


#Запись в mysql:

		SQL_Writen= "INSERT INTO `dictionaries`.`mol`(`code`, `login`, `name`, `password`, `locked`, `inn`) VALUES (" + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(Name_Kassir) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", 0, " + "\'" + str(Inn_Kassir) + "\'" + ")"
		print(SQL_Writen)
		cursor.execute(SQL_Writen)


##Завершение обработки:
		self.destroy()



def main():

	app = QtGui.QApplication(sys.argv)
	main = MainWindow()
	main.show()
	sys.exit(app.exec_())
	
main()


