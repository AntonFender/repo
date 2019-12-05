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
from kassa2 import Ui_MainWindow

#Для работы с РУССКИМ МАТЬ ЕГО ЯЗЫКОМ ДЛЯ UBUNTU:

reload(sys)
sys.setdefaultencoding('utf8')


class MainWindow(QMainWindow, Ui_MainWindow):
	def __init__(self, parent=None, *args, **kwargs):

		QMainWindow.__init__(self)
		self.setupUi(self)
		self.TextEdit21()
		self.connect(self.pushButton, SIGNAL('clicked()'), self.ButtonKnopka)
		self.connect(self.pushButton_2, SIGNAL('clicked()'), self.ButtonKnopka_2)


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


##Метод, который вызывается нажатием на кнопку СОЗДАТЬ:

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

#Считывание Порядка заведения code,login, password в таблице Mol

	#Ориентироваться по количеству строк в столбце code
		#SQL_id = "SELECT code FROM mol"
		#cursor.execute(SQL_id)
		#KolichestvoStrok = cursor.rowcount
		#print (KolichestvoStrok)

	#Через регулярки

		SQL_id_mol = "SELECT max(code) AS max_code FROM mol"
		cursor.execute(SQL_id_mol)
		data = cursor.fetchall()
		DataRe = int(re.search(r'\d+', str(data)).group(0)) + 1

##Переменные для roleuser

		rolecode = 3
		rule = 1

		SQL_id_roleuser = "SELECT max(id) AS max_code FROM roleuser"
		cursor.execute(SQL_id_roleuser)
		DataRoleuser = cursor.fetchall()
		DataReRoleuser = int(re.search(r'\d+', str(DataRoleuser)).group(0)) + 1


		if Name_Kassir:

#Запись в mysql:

	##Запись в таблицу mol

			SQL_Writen_mol= "INSERT INTO `dictionaries`.`mol`(`code`, `login`, `name`, `password`, `locked`, `inn`) VALUES (" + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(Name_Kassir) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", 0, " + "\'" + str(Inn_Kassir) + "\'" + ")"
			print(SQL_Writen_mol)
			cursor.execute(SQL_Writen_mol)

##Запись в таблицу roleuser

			SQL_Writen_roleuser = "INSERT INTO `dictionaries`.`roleuser`(`id`, `usercode`, `rolecode`, `rule`) VALUES (" + "\'" + str(DataReRoleuser) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(rolecode) + "\'" +", " + "\'" + str(rule) + "\'" + ")"
			print(SQL_Writen_roleuser)
			cursor.execute(SQL_Writen_roleuser)

##Завершение обработки:

			self.destroy()
		else:

			Name_Kassir_Er = "ВЫ НЕ ВВЕЛИ ИМЯ КАССИРА!"
			self.NameKassir.setPlaceholderText(Name_Kassir_Er.decode('utf8'))


##Метод, который вызывается нажатием на кнопку ВЫХОД:

	def ButtonKnopka_2(self):

		self.destroy()


def main():

	app = QtGui.QApplication(sys.argv)
	main = MainWindow()
	main.show()
	sys.exit(app.exec_())
	
main()


