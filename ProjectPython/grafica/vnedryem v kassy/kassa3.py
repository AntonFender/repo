#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fileencoding=utf-8

# Form implementation generated from reading ui file 'kassa3.ui'
#
# Created by: PyQt4 UI code generator 4.11.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName(_fromUtf8("MainWindow"))
        MainWindow.resize(1038, 506)
##Устанавливаем для ПИПО вывод экрана по центру
        desktop = QtGui.QApplication.desktop()
        x = (desktop.width() - MainWindow.width()) // 2
        y = (desktop.height() - MainWindow.height()) // 2
        MainWindow.move(x, y)
##Конец обработки!
        MainWindow.setAutoFillBackground(False)
        MainWindow.setStyleSheet(_fromUtf8("background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:0, stop:0.261364 rgba(255, 228, 210, 255), stop:1 rgba(255, 255, 255, 255));"))
        self.centralwidget = QtGui.QWidget(MainWindow)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.pushButton = QtGui.QPushButton(self.centralwidget)
        self.pushButton.setGeometry(QtCore.QRect(360, 380, 661, 91))
        font = QtGui.QFont()
        font.setPointSize(28)
        self.pushButton.setFont(font)
        self.pushButton.setContextMenuPolicy(QtCore.Qt.DefaultContextMenu)
        self.pushButton.setStyleSheet(_fromUtf8("background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:0, stop:0 rgba(200, 200, 200, 255), stop:1 rgba(255, 255, 255, 255));"))
        self.pushButton.setCheckable(False)
        self.pushButton.setObjectName(_fromUtf8("pushButton"))
        self.label = QtGui.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(20, 130, 401, 91))
        font = QtGui.QFont()
        font.setFamily(_fromUtf8("Caladea"))
        font.setPointSize(18)
        font.setBold(False)
        font.setItalic(True)
        font.setWeight(50)
        self.label.setFont(font)
        self.label.setAutoFillBackground(False)
        self.label.setScaledContents(False)
        self.label.setObjectName(_fromUtf8("label"))
        self.NameKassir = QtGui.QLineEdit(self.centralwidget)
        self.NameKassir.setGeometry(QtCore.QRect(430, 130, 591, 91))
        font = QtGui.QFont()
        font.setPointSize(20)
        font.setBold(True)
        font.setWeight(75)
        self.NameKassir.setFont(font)
        self.NameKassir.setStyleSheet(_fromUtf8("background-color: rgb(255, 255, 255);"))
        self.NameKassir.setObjectName(_fromUtf8("NameKassir"))
        self.label_3 = QtGui.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(20, 250, 401, 91))
        font = QtGui.QFont()
        font.setFamily(_fromUtf8("Caladea"))
        font.setPointSize(18)
        font.setBold(False)
        font.setItalic(True)
        font.setWeight(50)
        self.label_3.setFont(font)
        self.label_3.setScaledContents(False)
        self.label_3.setObjectName(_fromUtf8("label_3"))
        self.InnKassir = QtGui.QLineEdit(self.centralwidget)
        self.InnKassir.setGeometry(QtCore.QRect(430, 250, 591, 91))
        font = QtGui.QFont()
        font.setPointSize(20)
        font.setBold(True)
        font.setWeight(75)
        self.InnKassir.setFont(font)
        self.InnKassir.setStyleSheet(_fromUtf8("background-color: rgb(255, 255, 255);"))
        self.InnKassir.setObjectName(_fromUtf8("InnKassir"))
        self.label_2 = QtGui.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(20, 20, 1001, 91))
        font = QtGui.QFont()
        font.setFamily(_fromUtf8("Caladea"))
        font.setPointSize(18)
        font.setBold(False)
        font.setItalic(True)
        font.setWeight(50)
        self.label_2.setFont(font)
        self.label_2.setFocusPolicy(QtCore.Qt.NoFocus)
        self.label_2.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.label_2.setAutoFillBackground(False)
        self.label_2.setFrameShape(QtGui.QFrame.NoFrame)
        self.label_2.setFrameShadow(QtGui.QFrame.Plain)
        self.label_2.setTextFormat(QtCore.Qt.AutoText)
        self.label_2.setScaledContents(False)
        self.label_2.setWordWrap(False)
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.pushButton_2 = QtGui.QPushButton(self.centralwidget)
        self.pushButton_2.setGeometry(QtCore.QRect(10, 380, 321, 91))
        font = QtGui.QFont()
        font.setPointSize(28)
        self.pushButton_2.setFont(font)
        self.pushButton_2.setContextMenuPolicy(QtCore.Qt.DefaultContextMenu)
        self.pushButton_2.setStyleSheet(_fromUtf8("background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:0, stop:0 rgba(200, 200, 200, 255), stop:1 rgba(255, 255, 255, 255));"))
        self.pushButton_2.setCheckable(False)
        self.pushButton_2.setObjectName(_fromUtf8("pushButton_2"))
        MainWindow.setCentralWidget(self.centralwidget)
        self.statusbar = QtGui.QStatusBar(MainWindow)
        self.statusbar.setObjectName(_fromUtf8("statusbar"))
        MainWindow.setStatusBar(self.statusbar)

        #self.pushButton.setStyleSheet("""
            #QPushButton:hover { background-color: red }
            #QPushButton:!hover { background-color: white }
           # QPushButton:active { background-color: white }
            #QPushButton:pressed { background-color: rgb(0, 255, 0); }
        #""")
        #self.pushButton.focusInEvent(exit(quit()))
        #self.pushButton_2.setStyleSheet("""
            #QPushButton:hover { background-color: red }
            #QPushButton:!hover { background-color: white }
            #QPushButton:active { background-color: white }
            #QPushButton:pressed { background-color: rgb(0, 255, 0); }
        #""")

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(_translate("MainWindow", "Создать нового кассира", None))
        self.pushButton.setText(_translate("MainWindow", "Создать", None))
        self.label.setText(_translate("MainWindow", "Имя кассира :", None))
        self.label_3.setText(_translate("MainWindow", "ИНН кассира (Не обязательно) :", None))
        self.label_2.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\">Добавить нового кассира</p></body></html>", None))
        self.pushButton_2.setText(_translate("MainWindow", "Выход", None))

