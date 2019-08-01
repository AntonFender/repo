#!/usr/bin/python
# -*- coding: utf-8 -*-
 
import os
import sys
from tkinter import Tk, Canvas, Frame, BOTH, W
from tkinter import *
from PIL import *

class Windows(Frame):

#Метод вызова методов класса: 
    def __init__(self, parent):
        Frame.__init__(self, parent)   
         
        self.parent = parent        
        self.initUI()         
        self.center()  
        self.Button()

#Метод формирования информации о технической поддержке:       
    def initUI(self):
        self.parent.title('Помощь!')
        self.pack(fill=BOTH, expand=1)

##        self.columnconfigure(1, weight=1)
##        self.columnconfigure(3, pad=7)
##        self.rowconfigure(3, weight=1)
##        self.rowconfigure(5, pad=7)

        frame1 = Frame(self)
        frame1.pack(fill=X)
        
        lbl1 = Label(frame1, text="Данное окно появилось, так как возникла проблема с кассой!\n Нажмите на кнопку: \"ИСПРАВИТЬ ВСЕ\"", width=100)
        lbl1.pack()

        frame2 = Frame(self)
        frame2.pack(fill=X)

        lb12 = Label(frame2, text="Номера технической поддержки:\n Антон:8(905)-976-94-53 \n Максим:8(905)-976-10-53 \n Антон:8(903)-922-10-12 \n Общий номер: 274-46-96 ", width=60)
        lb12.pack()
        
#Метод центрирования формы
    def center(self):
        w=400
        h=300
        sw = self.parent.winfo_screenwidth()
        sh = self.parent.winfo_screenheight()
        x = (sw - w)/2
        y = (sh - h)/2
        self.parent.geometry('%dx%d+%d+%d' % (w, h, x, y))
        self.parent.resizable(False,False)
        
#Метод кнопки DeleteCheck:
    def test(self):
        os.system('rm /linuxcash/cash/data/tmp/check.img')
        print("ОЧКО")
        self.off()
        
#Метод кнопки WriteButton
        
        
#Метод выхода из окна
    def off(self):
        self.parent.destroy()
        
#Метод Формирования кнопок    
    def Button(self):
        
        frame = Frame(self, relief=RAISED, borderwidth=5, background="green")
        frame.pack(fill=BOTH, expand=True)
        
##        self.pack(fill=BOTH, expand=True)
        
##Удалить зависший чек:        
        DeleteCheck = Button(frame, text="Удалить зависший чек",  command=self.test)
        DeleteCheck.pack(pady=5) #Координаты кнопки
##Переустановка UTM и перезапуск supervisor.sh:        
        OkButton = Button(frame, text="Реанимация ЕГАИС",  command=self.off)
        OkButton.pack(pady=5) #Координаты кнопки
##Проверить интернет соединение:
        OkButton = Button(frame, text="Проверка интернет соединения",  command=self.off)
        OkButton.pack(pady=5) #Координаты кнопки
        

        
        
    


def main():
    root = Tk()
    app = Windows(root)
    root.mainloop()  
 
#if __name__ == '__main__':
main()
