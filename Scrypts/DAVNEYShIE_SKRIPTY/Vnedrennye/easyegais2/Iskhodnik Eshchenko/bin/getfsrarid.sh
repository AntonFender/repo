#!/bin/bash

##Service Definitions

MainPageFile=./cache/MainPage

#####################

log ()
{
    ./bin/logger.o "$logfile" `date +%F=%H-%M-%S` "getfsrarid.sh: ${1}"
    if [[ $Log2Console -eq 1 ]]
    then
	echo `date +%F=%H-%M-%S` "getfsrarid.sh: ${1}"
    fi
}


##Main()

#Checking prequisites
if [[ $# -ne 5 ]]
then
    echo "too few parameters for getfsrarid. exit"
    exit 2
fi

logfile="$1"
FSRARIDFile="$2"
UTM_IP_Address=$3
UTM_Port=$4
Log2Console=$5

#Get FSRAR_ID
log "Запрос ФСРАР ИД."
rm -f $MainPageFile
curl -X GET http://$UTM_IP_Address:$UTM_Port > $MainPageFile
FSRAR_ID=""
if [[ -f $MainPageFile ]]
then
    FSRAR_ID=`./bin/fsrarid.o`
    rm -f $MainPageFile
else
    echo "Cannot fetch main page of UTM"
    log "Не удалось получить сведения об УТМ."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
fi

if [[ -z $FSRAR_ID ]]
then
    echo "Main page does not contain info about FSRAR_ID"
    log "Главная страница УТМ не содержит данных о ФСРАР ИД."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
else
    log "В УТМ обнаружен ключ: ${FSRAR_ID}"
    echo $FSRAR_ID > $FSRARIDFile
fi

exit 0
