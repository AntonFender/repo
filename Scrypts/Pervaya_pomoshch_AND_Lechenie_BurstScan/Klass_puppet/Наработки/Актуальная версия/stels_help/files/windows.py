#!/usr/bin/python
# -*- coding: utf-8 -*-

import subprocess
from subprocess import *
import os
import sys
import re
from Tkinter import Tk, Canvas, Frame, BOTH, W
from Tkinter import *
import tkMessageBox
from PIL import *


class Windows(Frame):

#Метод вызова методов класса: 
    def __init__(self, parent):
        Frame.__init__(self, parent)   
         
        self.parent = parent        
        self.initUI()
        
        self.infoaboveall()
        self.center()  
        self.Button()
##        self.pp(self)
        

#Метод формирования информации о технической поддержке:       
    def initUI(self):
        self.parent.title('Помощь!')
        self.pack(fill=X)

        frame1 = Frame(self, relief=RAISED, borderwidth=5,)
        frame1.pack(fill=X)
        
        lbl1 = Label(frame1,font="Arial 20", text="Данное окно позволит своими силами проанализировать\n состояние кассы. И оказать первую помощь.", width=100)
        lbl1.pack()
        lb12 = Label(frame1,font="Arial 20", text="Номера технической поддержки:\n Антон:8(905)-976-94-53 \n Максим:8(905)-976-10-53 \n Антон:8(903)-922-10-12 \n Общий номер: 274-46-96 ", width=60)
        lb12.pack()
        
#Информационное окно:
    def infoaboveall(self):
        
        frame2 = Frame(self, relief=RAISED, borderwidth=5, background="linen")
        frame2.pack(fill=X)
        lbinfo = Label(frame2, text="Состояние кассы:\n" ,font="Arial 24", background="linen")
        lbinfo.pack(side=TOP)

#Проверяем на наличие интернет соединения:
        
        param = "time="
        res = Popen("ping -c 1 8.8.8.8", shell=True, stdout=PIPE)
        out = str(res.communicate()[0].decode("CP866"))
        print (out)
        if out.find(str(param)) == -1:
            lbnoping = Label(frame2, text="1.Интернет отсутствует! Вытащите и вставьте модем!" ,font="Arial 22", fg="red",background="linen")
            lbnoping.pack()
        else:
            lbyesping = Label(frame2, text="1.Интернет есть!",font="Arial 22", fg="green",background="linen")
            lbyesping.pack()

#Проверка на работоспособность УТМ
            
        param1 = "FSRAR-RSA"
        commandaCurl = "curl -X GET localhost:8082 | grep \"FSRAR-RSA\""
        res1 = Popen(commandaCurl, shell=True, stdout=PIPE)
        out1 = str(res1.communicate()[0].decode("CP866"))
        print (out1)
        if out1.find(str(param1)) == -1:
            lbnoUTM = Label(frame2, text="2.ЕГАИС НЕ работает! Нажмите Кнопку:Реанимация ЕГАИС" ,font="Arial 24", fg="red",background="linen")
            lbnoUTM.pack()
        else:
            lbyesUTM = Label(frame2, text="2.ЕГАИС работает! ",font="Arial 24", fg="green",background="linen")
            lbyesUTM.pack()
#Вывод информации о работоспособности Ключа
        var="Ключ ЕГАИС работает"
        if self.Rutoken() == var:
            StatRutoken = Label(frame2, text="3."+self.Rutoken() ,font="Arial 24", fg="green")
            StatRutoken.pack()
        else:
            var1=self.Rutoken()
            StatRutoken = Label(frame2, text="3."+var1 ,font="Arial 24", fg="red")
            StatRutoken.pack()

#Кнопка обновления Tkinter:

        UpdateButton = Button(frame2,font="Arial 24", text="Обновить",bd=2,  command=self.Update)
        UpdateButton.pack(side=RIGHT, pady=5) #Координаты кнопки
        
###Кнопка вызова maintainer:
##        ConfigButton = Button(frame2,font="Arial 24", text="Доп.Меню",bd=2,  command=self.Maintainer)
##        ConfigButton.pack(side=RIGHT, pady=5, padx=5) #Координаты кнопки
##            
##
###Метод вызова maintainer:
##    def Maintainer(self):
##        os.system('sudo chvt 3')
##        os.system('/linuxcash/cash/bin/devicemanager')
        
#Проверка ключа на работоспособность
    def Rutoken(self):
        Rutoken = Popen("/opt/FirstHelpAndScan/Rutoken.sh", shell=True, stdout=PIPE)
        RutokenStat = str(Rutoken.communicate()[0])
        RutokenRed = re.sub("^\s+|\n|\r|\s+$", '', RutokenStat)
        return RutokenRed
            

#Метод центрирования формы
    def center(self):
        w=1050
        h=790
        sw = self.parent.winfo_screenwidth()
        sh = self.parent.winfo_screenheight()
        x = (sw - w)/2
        y = (sh - h)/2
        self.parent.geometry('%dx%d+%d+%d' % (w, h, x, y))
        self.parent.resizable(False,False)
        
#Метод кнопки DeleteCheck:
    def DeleteCh(self):

        if os.path.exists("/linuxcash/cash/data/tmp/check.img"):
            print("Удаляем файл!")
            os.system('sudo rm -f /linuxcash/cash/data/tmp/check.img')
            os.system('sudo pkill artix-gui')
        else:
            print("Файл не существует")            

        self.off()
        
#Метод кнопки ReinstallUTM(Переустановка УТМ):
    def ReinstallUtm(self):
##
##        print (os.getcwd())
##        if os.system('sudo cat /root/egaisFlag'):
##            print(u'ФАЙЛ УДАЛЕН РАНЕЕ')
##        else:
##            print("Удаляем Файл egaisFlag ")
##            os.system('sudo rm -f /root/egaisFlag')
##            
        tkMessageBox.showinfo("Выполнение Операции","Нажмите Enter и переустановка ЕГАИС запустится. ВНИМАНИЕ!!! Подождите 6 минут и только потом пробуйте продавать!")
        self.off()
        os.system('sudo /opt/FirstHelpAndScan/installUtmPython.sh')
        os.system('sudo /opt/FirstHelpAndScan/supervisorPython.sh') 
        
#Метод кнопки VerificationTTN(Подтверждение ТТН):
    def VerificationTTN(self):
        TTN = "sudo /root/easyegais22/easyegais2.sh /root/easyegais22/"
        subprocess.Popen(TTN, shell=True, stdout=PIPE)
        tkMessageBox.showinfo("Выполнение операции","Подтверждение наклыдных запущено! Нажмите Enter и ожидайте")
        self.off()

        
#Метод выхода из окна
    def off(self):
        self.parent.destroy()
        
#Метод Формирования кнопок    
    def Button(self):
        
        frame = Frame(self, relief=RAISED, borderwidth=5, background="green")
        frame.pack(fill=X)
        
##        self.pack(fill=BOTH, expand=True)
        
##Удалить зависший чек:        
        DeleteCheck = Button(frame,font="Arial 24" ,text="Удалить зависший чек",bd=2, command=self.DeleteCh)
        DeleteCheck.pack(pady=5) #Координаты кнопки
        
##Переустановка UTM и перезапуск supervisor.sh:        
        ReinstallUTM = Button(frame,font="Arial 24", text="Реанимация ЕГАИС", bd=2, command=self.ReinstallUtm)
        ReinstallUTM.pack(pady=5) #Координаты кнопки
        
##Подтверждение накладных:        
        ReinstallUTM = Button(frame,font="Arial 24", text="Подтверждение накладных", bd=2, command=self.VerificationTTN)
        ReinstallUTM.pack(pady=5) #Координаты кнопки
        
##Проверить интернет соединение:
        ExitButton = Button(frame,font="Arial 24", text="Выход", bd=2, command=self.off)
        ExitButton.pack( pady=5 ) #Координаты кнопки



    def Update(self):

        self.off()
        main()
        



##Попытка написать автообновление виджетов
##    def pp(self) :
##        #print('Im in pp')
##        infoaboveall()
##        app.parent.after(30000, self.pp)        


def main():
    root = Tk()
    app = Windows(root)
##    app.parent.after(30000,app.pp)
    root.mainloop()  
 
#if __name__ == '__main__':
main()
