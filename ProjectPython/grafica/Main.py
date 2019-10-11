# -*- coding: utf-8 -*-

import sys
import time

from PyQt4 import QtCore, QtGui
from PyQt4.QtCore import SIGNAL
from PyQt4.QtGui import QApplication, QMainWindow, QFont

from hello import Ui_MainWindow



class MainWindow(QMainWindow, Ui_MainWindow):
	def __init__(self, parent=None, *args, **kwargs):
		QMainWindow.__init__(self)
		self.setupUi(self)
		

def main():
	app = QApplication(sys.argv)
	main = MainWindow()
	main.show()
	sys.exit(app.exec_())
	
main()


