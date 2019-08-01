#!/bin/bash

#v1_23
##Global definitions

logfile=./log/`hostname -s`\=`date +%F=%H-%M-%S`.log
FSRARIDFile=./cache/FSRARID
TTNListFile=./cache/ttns.list
TTNQuickListFile=./cache/ttns_quick.list
RestsListFile=./cache/rests.list

#Флаги отладки (выставить в 0 для нормального режима работы)
DoPauseBeforeAcceptTTN=0
DoPauseBeforeWriteOffBeer=0
Log2Console=0

####################

log ()
{
    ./bin/logger.o "$logfile" `date +%F=%H-%M-%S` "${1}"
    if [[ $Log2Console -eq 1 ]]
    then
        echo `date +%F=%H-%M-%S` "${1}"
    fi
}

send_log ()
{
    #Добавить к имени файла результат работы (первый параметр функции)
    filename=`basename $logfile .log`
    mv $logfile ./log/${filename}\=${1}.log
    logfile=./log/${filename}\=${1}.log
    #Отправка журнала на FTP-сервер
    curl --upload-file "$logfile" "ftp://$FTPUser:$FTPPassword@$FTPServer$FTPPath"
}

#MAIN

#Имя пути, где располагается программа, должно быть передано первым параметром
if [[ $# -eq 0 ]]
then
    echo "no arguments supplied" > /dev/null
    exit 2
fi

#Переходим в каталог программы и далее используем относительные пути
currdir=$1
cd $currdir

##Глобальные объявления

source ./vars

#######################

#Завели лог

touch $logfile
log "Адрес УТМ: ${UTM_IP_Address}"
log "Порт УТМ: ${UTM_Port}"
LogMark="OK"

#Проверка требований
#Проверка наличия соединения с сетью интернет
ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2> /dev/null && internet_result=1 || internet_result=0
if [[ internet_result -eq 0 ]]
then
    echo "Internet is down"
    log "Нет доступа к Интернету."
    log "Завершение работы с ошибкой."
    send_log "ERROR"
    exit 2
else
    echo "Internet is reachable" > /dev/null
fi

#Проверка доступности выбранного УТМ на порт веб-интерфейса
timeout 5 bash -c "</dev/tcp/${UTM_IP_Address}/${UTM_Port}" && port_open=1 || port_open=0
if [[ port_open -eq 1 ]]
then
    echo "Utm is accessible" > /dev/null
else
    echo "Utm is down"
    log "Нет доступа к выбранному УТМ по адресу ${UTM_IP_Address}:${UTM_Port}."
    log "Завершение работы с ошибкой."
    send_log "ERROR"
    exit 2
fi

#Проверка наличия приложения curl
if [[ -f /usr/bin/curl ]]
then
    echo "Curl is present" > /dev/null
else
    echo "Curl is absent"
    log "Для работы требуется установленное приложение curl."
    log "Завершение работы с ошибкой."
    send_log "ERROR"
    exit 2
fi

#Получим ФСРАР ИД.
rm -f $FSRARIDFile
./bin/getfsrarid.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port $Log2Console
if [[ $? -eq 2 ]]
then
    log "Не удалось получить ФСРАР ИД."
    log "Завершение работы с ошибкой."
    send_log "ERROR"
    exit 2
fi

#Обработка запроса на непринятые накладные
rm -f $TTNListFile
rm -f $TTNQuickListFile
./bin/getnattn.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port "${TTNListFile}" "${TTNQuickListFile}" $ReplyTimeout $Log2Console
resultcode=$?
if [[ $resultcode -eq 2 ]]
then
    log "Не удалось получить список непринятых накладных."
    log "Завершение работы с ошибкой."
    send_log "ERROR"
    exit 2
fi
if [[ $resultcode -eq 1 ]]
then
    log "Не удалось запросить список непринятых накладных (см. журнал выше)."
    log "Продолжение работы."
    LogMark="WARNING"
fi

#В режиме отладки (ручного запуска) есть шанс включить паузу и просмотреть и отредактировать список ТТН для подтверждения
if [[ $DoPauseBeforeAcceptTTN -eq 1 ]]
then
    read -rsp $'Press any key to continue...\n' -n1 key
fi

#Подтверждение накладных
./bin/acceptttn.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port "${TTNListFile}" "${TTNQuickListFile}" $ReplyTimeout $Log2Console $QuickAcceptTTNs

#Чтение остатков немаркированного алкоголя
rm -f $RestsListFile
./bin/getrests.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port "${RestsListFile}" $ReplyTimeout $Log2Console $LogBeer "${BeerProductVCode}"
resultcode=$?
if [[ $resultcode -eq 2 ]]
then
    log "Не удалось получить сведения об остатках."
    log "Завершение работы с ошибкой."
    send_log "ERROR"
    exit 2
fi
if [[ $resultcode -eq 1 ]]
then
    log "Не удалось запросить сведения об остатках (см. журнал выше)."
    log "Продолжение работы."
    LogMark="WARNING"
fi

#В режиме отладки (ручного запуска) есть шанс включить паузу и просмотреть и отредактировать список остатков для спасания
if [[ $DoPauseBeforeWriteOffBeer -eq 1 ]]
then
    read -rsp $'Press any key to continue...\n' -n1 key
fi

#Списание
./bin/writeoffbeer.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port "${RestsListFile}" $ReplyTimeout $Log2Console
resultcode=$?
if [[ $resultcode -eq 2 ]]
then
    log "Произошла ошибка при выполнении операции отправки акта списания."
    log "Завершение работы с ошибкой."
    send_log "ERROR"
    exit 2
fi
if [[ $resultcode -eq 1 ]]
then
    log "На акт списания не получен документ о проведении (см. журнал работы выше)."
    LogMark="WARNING"
    #log "Продолжение работы."
fi

log "Все действия выполнены. Завершение работы."
send_log $LogMark

exit 0
