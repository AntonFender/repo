#!/bin/bash

#####Во сколько запускать?
Hour="12"
Minute="00"
Hours="17"
Minutes="00"
#############################

InstallPath="/root/easyegais2"

if [[ -f $InstallPath ]]
then
    echo "В папке назначения уже существует файл с таким названием ${InstallPath}"
    echo "Установка не выполнена."
    read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
    exit 2
fi

if [[ -d $InstallPath ]]
then
    echo "В папке назначения уже существует каталог с таким названием ${InstallPath}"
    echo "Выполнить установку с заменой всех файлов в целевом каталоге? (1 - ДА, 2 - НЕТ):"
    read Key
    case "$Key" in
	"2" )
	    echo "Установка не выполнена."
	    read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
	    exit 2
	;;
	"1" )
	    rm -rf $InstallPath
	;;
    esac
fi

mkdir $InstallPath
cp /root/easyegais2.tar.gz $InstallPath
cd $InstallPath
tar -zxvf /root/easyegais2.tar.gz

chmod +x ./easyegais2.sh ./vars
chmod -R +x ./bin/*
rm -rf ./cache/*
rm -rf ./log/*

#if [[ -n `crontab -l | grep "easyegais2"` ]]
#then
#    echo "Копирование файлов завершено, но в системе уже присутствует регламентное задание по запуску easyegais2."
#    echo "Если это необходимо, требуется исправить параметры запуска и/или расписание запуска вручную командой `crontab -e`."
#    crontab -l | grep "easyegais2"
#    read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
#    exit 2
#fi

if [[ -n `cat /etc/crontab | grep "easyegais2"` ]]
then
    echo "Копирование файлов завершено, но в системе уже присутствует регламентное задание по запуску easyegais2."
    echo "Если это необходимо, требуется исправить параметры запуска и/или расписание запуска вручную в файле /etc/crontab."
    cat /etc/crontab | grep "easyegais2"
    read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key
    exit 2
fi

#echo $Minute $Hour \* \* \* root $InstallPath\/easyegais2.sh $InstallPath >> /etc/crontab
crontab -l | grep -v easyegais2 > /tmp/crontab.tmp
echo $Minute $Hour \* \* \* $InstallPath\/easyegais2.sh $InstallPath >> /tmp/crontab.tmp
echo $Minutes $Hours \* \* \* $InstallPath\/easyegais2.sh $InstallPath >> /tmp/crontab.tmp
crontab < /tmp/crontab.tmp
rm -f /tmp/crontab.tmp

echo "Установка завершена."
read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key

exit 0
