#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fileencoding=utf-8

# Form implementation generated from reading ui file 'KassaWindow.ui'
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

class Ui_KassirWindow(object):
    def setupUi(self, KassirWindow):
        KassirWindow.setObjectName(_fromUtf8("KassirWindow"))
        KassirWindow.resize(800, 303)
        KassirWindow.setStyleSheet(_fromUtf8("background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:0, stop:0.261364 rgba(255, 228, 210, 255), stop:1 rgba(255, 255, 255, 255));"))
        self.centralwidget = QtGui.QWidget(KassirWindow)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.label = QtGui.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(120, 50, 691, 91))
        ##Устанавливаем для ПИПО вывод экрана по центру
        desktop = QtGui.QApplication.desktop()
        x = (desktop.width() - KassirWindow.width()) // 2
        y = (desktop.height() - KassirWindow.height()) // 2
        KassirWindow.move(x, y)
        ##Конец обработки!
        font = QtGui.QFont()
        font.setPointSize(26)
        self.label.setFont(font)
        self.label.setObjectName(_fromUtf8("label"))
        self.pushButtonClose = QtGui.QPushButton(self.centralwidget)
        self.pushButtonClose.setGeometry(QtCore.QRect(280, 190, 221, 71))
        font = QtGui.QFont()
        font.setPointSize(28)
        self.pushButtonClose.setFont(font)
        self.pushButtonClose.setObjectName(_fromUtf8("pushButtonClose"))
        self.label_run = QtGui.QLabel(self.centralwidget)
        self.label_run.setGeometry(QtCore.QRect(190, 120, 411, 51))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.label_run.setFont(font)
        self.label_run.setObjectName(_fromUtf8("label_run"))
        KassirWindow.setCentralWidget(self.centralwidget)
        self.statusbar = QtGui.QStatusBar(KassirWindow)
        self.statusbar.setObjectName(_fromUtf8("statusbar"))
        KassirWindow.setStatusBar(self.statusbar)

        self.retranslateUi(KassirWindow)
        QtCore.QMetaObject.connectSlotsByName(KassirWindow)

    def retranslateUi(self, KassirWindow):
        KassirWindow.setWindowTitle(_translate("KassirWindow", "Информационное окно", None))
        self.label.setText(_translate("KassirWindow", "<html><head/><body><p align=\"center\">Ошибка 1</p></body></html>", None))
        self.pushButtonClose.setText(_translate("KassirWindow", "Закрыть", None))
        self.label_run.setText(_translate("KassirWindow", "<html><head/><body><p align=\"center\">Ошибка 2</p></body></html>", None))

