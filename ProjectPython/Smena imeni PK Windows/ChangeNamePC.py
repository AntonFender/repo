# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import io
import codecs
import locale


NamePC = input("Введите имя Компьютера: ")


def ChangeNamePC():
   
    CommandChangePc = "wmic computersystem where name=" + "\"" + "%computername%" + "\"" + " " + "call rename name=" + "\"" + NamePC + "\""
    CommandRestartPc = "shutdown /r /t 5"

    print(CommandChangePc + "\n")
    print(CommandRestartPc)
    os.system(CommandChangePc)
    os.system(CommandRestartPc)
    
ChangeNamePC()
 
















