import os
import sys
import subprocess
import io
import codecs
import locale


name_cert = input("Введите имя сертификата: ")
roadCS = "ssh root@192.168.0.15"
NameCertCRT = name_cert + ".crt"
NameCertCSR = name_cert + ".csr"
NameCertKEY = name_cert + ".key"

def CreateCert():
    
    os.chdir("C:\\OpenSSH")
    
    pathCS = "/opt/certificate/"
    scrypt = "gencert.sh"
    allpath = roadCS + " "  + "\"" + pathCS  + scrypt + " " + name_cert + "\""
    puase = "&& pause"
    findceert = "ls -l"
    proverka = roadCS + " "  + "\"" + findceert + " " + pathCS
    print("Смена директории на: " + os.getcwd())
    print("Путь обращения к скрипту с параметром: " + allpath)
    os.system(allpath)
    
##    print("Наличие файла в пути: " + proverka)
##    os.system(proverka)

def CopyOnFtp():
    
    os.chdir("C:\\OpenSSH")
    
    CopyWithPath = "cp /opt/certificate/"
    CopyToPath = "/srv/ftp/certificate_sima/"
    CopyCRT = CopyWithPath + NameCertCRT + " " + CopyToPath
    CopyCSR = CopyWithPath + NameCertCSR + " " + CopyToPath
    CopyKEY = CopyWithPath + NameCertKEY + " " + CopyToPath

    СommandCopyCRT = roadCS + " \"" + CopyCRT + "\""
    СommandCopyCSR = roadCS + " \"" + CopyCSR + "\""
    СommandCopyKEY = roadCS + " \"" + CopyKEY + "\""
    print("Копирую сертификаты: " + "\n" + СommandCopyCRT + " \n" + СommandCopyCSR + " \n" + СommandCopyKEY)

    os.system(СommandCopyCRT)
    os.system(СommandCopyCSR)
    os.system(СommandCopyKEY)

def downloadcert():
    
    os.chdir("C:\certificate_sima")
    
    pathftp = "wget.exe ftp://ftpuser:GbplfnsqGfhjkm@192.168.0.15/ftp/certificate_sima/"
    DownloadCertCRT = pathftp + NameCertCRT
    DownloadCertCSR = pathftp + NameCertCSR
    DownloadCertKey = pathftp + NameCertKEY
    print("Скачиваю сертификаты: " + "\n" + DownloadCertCRT +  "\n" + DownloadCertCSR +  "\n" + DownloadCertKey)    
    os.system(DownloadCertCRT)
    os.system(DownloadCertCSR)
    os.system(DownloadCertKey)

##copy ip_list2.csv C:\OSPanel\KassOnline
##xcopy C:\OSPanel\KassOnline \\WSUS\Users\Kass_otdel\monitoring /Y

CreateCert()

CopyOnFtp()

downloadcert()
 
















