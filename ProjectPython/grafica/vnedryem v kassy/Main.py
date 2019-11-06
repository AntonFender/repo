#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fileencoding=utf-8

import sys
import re
import os
import pymysql

from PyQt4 import QtCore, QtGui
from PyQt4.QtCore import SIGNAL
from PyQt4.QtGui import QApplication, QMainWindow, QFont

from kassa3 import Ui_MainWindow
from KassaWindow import Ui_KassirWindow


#Для работы с РУССКИМ МАТЬ ЕГО ЯЗЫКОМ ДЛЯ UBUNTU:

reload(sys)
sys.setdefaultencoding('utf8')

##Сменить язык ввода на РУССКИЙ ЯЗЫК!

os.system('sudo DISPLAY=:0 XAUTHORITY=/home/autologon/.Xauthority sudo -u autologon setxkbmap -layout ru')

class Kassir(QMainWindow, Ui_KassirWindow):
	def __init__(self, parent = None, reg = None,  *args, **kwargs):

		QMainWindow.__init__(self)
		self.setupUi(self)
		self.pushButtonClose.clicked.connect(self.close)


class MainWindow(QMainWindow, Ui_MainWindow):
	def __init__(self, parent=None, *args, **kwargs):

		QMainWindow.__init__(self)
		self.setupUi(self)
		self.TextEdit21()
		self.connect(self.pushButton, SIGNAL('clicked()'), self.ButtonKnopka)
		self.connect(self.pushButton_2, SIGNAL('clicked()'), self.ButtonKnopka_2)

##Вывод информации о том.  что надо вводить в поле ввода lineEdit:

	def TextEdit21(self):

		Name_Kassir1 = "Введите имя кассира (Иванов И.И.)"
		Inn_Kassir1 = "Введите ИНН кассира (Не обязательно)"

##Для Ubuntu

		self.NameKassir.setPlaceholderText(Name_Kassir1.decode('utf8'))
		self.InnKassir.setPlaceholderText(Inn_Kassir1.decode('utf8'))


##Метод, который вызывается нажатием на кнопку СОЗДАТЬ:

	def ButtonKnopka(self):

##Считываем ФИО пользователя с lineEdit:

		Name_Kassir = self.NameKassir.text()
		#print(Name_Kassir)

##Считываем ИНН пользователя с lineEdit:

		Inn_Kassir = self.InnKassir.text()
		#print(Inn_Kassir)


#Подключаемся к MYSQL

		conn = pymysql.connect(host='127.0.0.1', port=3306,
		user='root', passwd='', db='dictionaries')
		cursor = conn.cursor(pymysql.cursors.DictCursor)

#Считывание Порядка заведения code,login, password в таблице Mol

#Через регулярки

		#SQL_id_mol = "SELECT max(code) AS max_code FROM mol"
		SQL_id_mol = "SELECT code FROM mol WHERE code ORDER BY CAST(mol.code as signed) DESC LIMIT 1"  ##Потому что поле в mysql строковое
		cursor.execute(SQL_id_mol)
		data = cursor.fetchall()
		DataRe = int(re.search(r'\d+', str(data)).group(0)) + 1

##Правильная запись inn в таблицу mol:

		if Inn_Kassir:
			Inn_Kassir_Re = "\'" + str(Inn_Kassir) + "\'"
			#print(Inn_Kassir_Re)
		else:
			Inn_Kassir_Re = 'NULL'
			#print(Inn_Kassir_Re)

##Переменные для roleuser

		rolecode = 3
		rule = 1

		SQL_id_roleuser = "SELECT max(id) AS max_code FROM roleuser"
		cursor.execute(SQL_id_roleuser)
		DataRoleuser = cursor.fetchall()
		DataReRoleuser = int(re.search(r'\d+', str(DataRoleuser)).group(0)) + 1


#ЗАПИСЬ В MYSQL---------------------------------------------------------------------------------------------
##Запись в таблицу mol

		if Name_Kassir:
			SQL_Writen_mol= "INSERT INTO `dictionaries`.`mol`(`code`, `login`, `name`, `password`, `locked`, `inn`) VALUES (" + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(Name_Kassir) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", 0, " + Inn_Kassir_Re + ")"
			print(SQL_Writen_mol)
			cursor.execute(SQL_Writen_mol)

##Запись в таблицу roleuser

			SQL_Writen_roleuser = "INSERT INTO `dictionaries`.`roleuser`(`id`, `usercode`, `rolecode`, `rule`) VALUES (" + "\'" + str(DataReRoleuser) + "\'" + ", " + "\'" + str(DataRe) + "\'" + ", " + "\'" + str(rolecode) + "\'" +", " + "\'" + str(rule) + "\'" + ")"
			print(SQL_Writen_roleuser)
			cursor.execute(SQL_Writen_roleuser)

##Завершение обработки:
			os.system('sudo DISPLAY=:0 XAUTHORITY=/home/autologon/.Xauthority sudo -u autologon setxkbmap -layout us')
			self.InfoCreateKassir(DataRe, Name_Kassir)
			self.close()
			#sys.exit()
			#self.destroy()

		else:

			Name_Kassir_Er = "ВЫ НЕ ВВЕЛИ ИМЯ КАССИРА!"
			self.NameKassir.setPlaceholderText(Name_Kassir_Er.decode('utf8'))

##-------------------------------------------------------------------------------------------------------------



##Вызов Окна о том, что кассир заведен.
	def InfoCreateKassir(self, passWords, kas):

		self.infoCreate = Kassir()
		passWord = "Пароль Кассира: " + str(passWords)
		self.infoCreate.label_run.setText(passWord.decode('utf8'))
		KassirView = "Кассир  " + str(kas) + " Заведен!"
		self.infoCreate.label.setText(KassirView.decode('utf8'))
		self.infoCreate.show()


##Метод, который вызывается нажатием на кнопку ВЫХОД:
	def ButtonKnopka_2(self):

		os.system('sudo DISPLAY=:0 XAUTHORITY=/home/autologon/.Xauthority sudo -u autologon setxkbmap -layout us')
		self.close()


def main():

	app = QtGui.QApplication(sys.argv)
	main = MainWindow()
	main.show()
	sys.exit(app.exec_())
	
main()