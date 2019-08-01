#!/bin/bash


InstallPath="/root/easyegais22"

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
cp /root/easyegais22.tar.gz $InstallPath
cd $InstallPath
tar -zxvf /root/easyegais22.tar.gz

chmod +x ./easyegais2.sh ./vars
chmod -R +x ./bin/*
rm -rf ./cache/*
rm -rf ./log/*

echo "Установка завершена."
read -rsp $'Для выхода нажмите любую клавишу...\n' -n1 key

exit 0
