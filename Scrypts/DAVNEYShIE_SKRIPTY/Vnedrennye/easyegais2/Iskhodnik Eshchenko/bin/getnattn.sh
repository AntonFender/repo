#!/bin/bash

##Service Definitions

QueryNATTNFile=./cache/QueryNATTN.xml
QueryNATTNReply=./cache/nattn.reply
optoutFile=./cache/optout
ReplyNATTNFile=./cache/ReplyNATTN.xml
SleepTimeout=30
TTNListFileDeferred=./cache/ttns_deferred.list

#####################

log ()
{
    ./bin/logger.o $logfile `date +%F=%H-%M-%S` "getnattn.sh: ${1}"
    if [[ $Log2Console -eq 1 ]]
    then
	echo `date +%F=%H-%M-%S` "getnattn.sh: ${1}"
    fi
}

make_querynattn ()
{
    #Forming QueryNATTN request file
    rm -f $QueryNATTNFile
    touch $QueryNATTNFile

    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $QueryNATTNFile
    echo "<ns:Documents Version=\"1.0\"" >> $QueryNATTNFile
    echo "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" >> $QueryNATTNFile
    echo "xmlns:ns=\"http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01\"" >> $QueryNATTNFile
    echo "xmlns:qp=\"http://fsrar.ru/WEGAIS/QueryParameters\">" >> $QueryNATTNFile
    echo "<ns:Owner>" >> $QueryNATTNFile
    echo \<ns:FSRAR_ID\>$FSRAR_ID\<\/ns:FSRAR_ID\> >> $QueryNATTNFile
    echo "</ns:Owner>" >> $QueryNATTNFile
    echo "<ns:Document>" >> $QueryNATTNFile
    echo "<ns:QueryNATTN>" >> $QueryNATTNFile
    echo "<qp:Parameters>" >> $QueryNATTNFile
    echo "<qp:Parameter>" >> $QueryNATTNFile
    echo "<qp:Name>КОД</qp:Name>" >> $QueryNATTNFile
    echo \<qp:Value\>$FSRAR_ID\<\/qp:Value\> >> $QueryNATTNFile
    echo "</qp:Parameter>" >> $QueryNATTNFile
    echo "</qp:Parameters>" >> $QueryNATTNFile
    echo "</ns:QueryNATTN>" >> $QueryNATTNFile
    echo "</ns:Document>" >> $QueryNATTNFile
    echo "</ns:Documents>" >> $QueryNATTNFile

    #Put query into the UTM
    rm -f $QueryNATTNReply
    curl -F "xml_file=@$QueryNATTNFile" http://$UTM_IP_Address:$UTM_Port/opt/in/QueryNATTN > $QueryNATTNReply
}


##Main()

if [[ $# -ne 8 ]]
then
    echo "too few parameters for getnattn. exit"
    exit 2
fi

logfile=$1
FSRARIDFile=$2
UTM_IP_Address=$3
UTM_Port=$4
TTNListFile=$5
TTNQuickListFile=$6
FSRAR_ID=`head -1 "${FSRARIDFile}"`
replytimeout=$7
let "replytimeout *= 2"
Log2Console=$8

log "Формирование и отправка документа QueryNATTN."
make_querynattn

#Parse response from UTM
NATTN_UUID=""
if [[ -f $QueryNATTNReply ]]
then
    NATTN_UUID=`./bin/parsenattnresponse.o $QueryNATTNReply`
else
    echo "UTM returned nothing in response" > /dev/null
    log "Ошибка при отправке запроса QueryNATTN."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
fi

if [[ -z $NATTN_UUID ]]
then
    echo "No ID was returned" > /dev/null
    log "В ответе УТМ не обнаружен идентификатор сессии документа QueryNATTN."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
else
    echo $NATTN_UUID > /dev/null
    echo $NATTN_UUID > $QueryNATTNReply
    log "Идентификатор сессии документа QueryNATTN: ${NATTN_UUID}"
fi

#log "Выполняется попытка получить ответ на документ QueryNATTN"
maxattempts=$replytimeout
for (( it=1; it<$maxattempts; it++ ))
do
    sleep $SleepTimeout
    log "[${it}] Выполняется попытка получить ответ на документ QueryNATTN."
    rm -f $optoutFile
    curl -X GET http://$UTM_IP_Address:$UTM_Port/opt/out > $optoutFile
    strurl=`cat ${optoutFile} | grep $NATTN_UUID`
    if [[ -n $strurl ]]
    then
	strurl=`./bin/getlink.o "${strurl}"`
    else
	echo error > /dev/null
	log "Документ с искомым идентификатором ReplyNATTN не найден во входящих. Повторная проверка через ${SleepTimeout} секунд."
	continue
    fi

    rm -f $ReplyNATTNFile
    if [[ -z $strurl ]]
    then
	echo error > /dev/null
	log "Документ найден, но не содержит ссылки на файл."
    else
	echo $strurl > /dev/null
	curl -X GET "$strurl" > $ReplyNATTNFile
	curl -X DELETE "$strurl"
	break
    fi
done

if [[ $it -eq $maxattempts ]]
then
    log "Документ ответа не поступил в УТМ за разумное время."
    log "Завершение работы с ошибкой."
    exit 2
fi

if [[ -f $ReplyNATTNFile ]]
then
    echo good > /dev/null
    log "Получен файл ReplyNATTN."
else
    log "Файл ReplyNATTN не получен из УТМ."
    log "Завершение работы с ошибкой."
    exit 2
fi

ConclusionRejected=`cat $ReplyNATTNFile | grep Conclusion | grep Rejected`
if [[ -n $ConclusionRejected ]]
then
    textComment=`cat $ReplyNATTNFile | grep Comments`
    textLog=`./bin/getcomment.o "${textComment}"`
    log "${textLog}"
    rm -f $TTNListFile
    touch $TTNListFile
    exit 1
fi

#Parsing reply file to extract information about ttns
rm -f $TTNListFile
./bin/extractnattns.o `date +%F -d "3 days ago"`
if [[ -f $TTNListFile ]]
then
    echo good > /dev/null
else
    echo error > /dev/null
    log "Ошибка обработки списка неподтвержденных накладных - список не сформирован."
    log "Завершение работы с ошибкой."
    exit 2
fi

#Logging ttns
while read LINE
do
    if [[ -z $LINE ]]
    then
        continue
    fi
    echo $LINE > /dev/null
    wbregid=`echo $LINE | awk '{print $1}'`
    ttnnumber=`echo $LINE | awk '{print $2}'`
    ttndate=`echo $LINE | awk '{print $3}'`
    shipper=`echo $LINE | awk '{print $4}'`
    log "Найдена неподтвержденная накладная, будет подтверждена без обработки акцизных марок:"
    log "    Идентификатор: ${wbregid}"
    log "    Номер: ${ttnnumber}"
    log "    Дата отгрузки: ${ttndate}"
    log "    Поставщик: ${shipper}"
done < $TTNQuickListFile

while read LINE
do
    if [[ -z $LINE ]]
    then
        continue
    fi
    echo $LINE > /dev/null
    wbregid=`echo $LINE | awk '{print $1}'`
    ttnnumber=`echo $LINE | awk '{print $2}'`
    ttndate=`echo $LINE | awk '{print $3}'`
    shipper=`echo $LINE | awk '{print $4}'`
    log "Найдена неподтвержденная накладная:"
    log "    Идентификатор: ${wbregid}"
    log "    Номер: ${ttnnumber}"
    log "    Дата отгрузки: ${ttndate}"
    log "    Поставщик: ${shipper}"
done < $TTNListFile

while read LINE
do
    if [[ -z $LINE ]]
    then
        continue
    fi
    echo $LINE > /dev/null
    wbregid=`echo $LINE | awk '{print $1}'`
    ttnnumber=`echo $LINE | awk '{print $2}'`
    ttndate=`echo $LINE | awk '{print $3}'`
    shipper=`echo $LINE | awk '{print $4}'`
    log "Найдена неподтвержденная накладная, НЕ БУДЕТ подтверждена:"
    log "    Идентификатор: ${wbregid}"
    log "    Номер: ${ttnnumber}"
    log "    Дата отгрузки: ${ttndate}"
    log "    Поставщик: ${shipper}"
done < $TTNListFileDeferred

exit 0
