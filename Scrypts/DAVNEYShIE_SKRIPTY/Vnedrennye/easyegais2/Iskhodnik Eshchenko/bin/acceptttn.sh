#!/bin/bash

##Service Definitions

optoutFile=./cache/optout
SleepTimeout=30
WayBillActFile_v3=./cache/WayBillAct_v3.xml
WayBillActFile_v2=./cache/WayBillAct_v2.xml
WayBillActReply=./cache/accept.reply
ticketsFile=./cache/tickets
ReplyWayBillActFile=./cache/ticket

#####################

log ()
{
    ./bin/logger.o $logfile `date +%F=%H-%M-%S` "acceptttn.sh: ${1}"
    if [[ $Log2Console -eq 1 ]]
    then
	echo `date +%F=%H-%M-%S` "acceptttn.sh: ${1}"
    fi
}

##Main()

if [[ $# -ne 9 ]]
then
    echo "too few parameters for acceptttn. exit"
    exit 2
fi

logfile=$1
FSRARIDFile=$2
UTM_IP_Address=$3
UTM_Port=$4
TTNListFile=$5
TTNQuickListFile=$6
FSRAR_ID=`head -1 "${FSRARIDFile}"`
ReplyTimeout=$7
Log2Console=$8
QuickAcceptOnly=$9

isErrorTTN=0
#TTNs issued before 31-12-2018 will be accepted via quick way only
log "Запуск быстрого подтверждения накладных (2018 год и ранее)."
./bin/acceptttn_quick.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port "${TTNQuickListFile}" $ReplyTimeout $Log2Console
resultcode=$?
if [[ $resultcode -eq 2 ]]
then
    log "Произошла ошибка при выполнении операции подтверждения накладных."
    log "Завершение работы с ошибкой."
    exit 2
fi
if [[ $resultcode -eq 1 ]]
then
    log "На одну из накладных не получен документ о проведении (см. журнал работы выше)."
    log "Продолжение работы."
    isErrorTTN=1
fi

#if the flag QuickAccept set up in "1" - all other TTNs will also be accepted quickly, otherwise fully.
if [[ $QuickAcceptOnly -eq 1 ]]
then
    log "Запуск быстрого подтверждения накладных."
    ./bin/acceptttn_quick.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port "${TTNListFile}" $ReplyTimeout $Log2Console
    resultcode=$?
    if [[ $resultcode -eq 2 ]]
    then
	log "Произошла ошибка при выполнении операции подтверждения накладных."
        log "Завершение работы с ошибкой."
	exit 2
    fi
    if [[ $resultcode -eq 1 ]]
    then
	log "На одну из накладных не получен документ о проведении (см. журнал работы выше)."
        log "Продолжение работы."
	isErrorTTN=1
    fi
else
    log "Запуск подтверждения накладных с обработкой информации о марках."
    ./bin/acceptttn_full.sh "${logfile}" "${FSRARIDFile}" $UTM_IP_Address $UTM_Port "${TTNListFile}" $ReplyTimeout $Log2Console
    resultcode=$?
    if [[ $resultcode -eq 2 ]]
    then
	log "Произошла ошибка при выполнении операции подтверждения накладных."
        log "Завершение работы с ошибкой."
	exit 2
    fi
    if [[ $resultcode -eq 1 ]]
    then
	log "На одну из накладных не получен документ о проведении (см. журнал работы выше)."
        log "Продолжение работы."
	isErrorTTN=1
    fi
fi

exit $isErrorTTN
