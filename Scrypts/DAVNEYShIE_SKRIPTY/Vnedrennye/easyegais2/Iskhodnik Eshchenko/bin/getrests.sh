#!/bin/bash

##Service Definitions

QueryRestsFile=./cache/QueryRests.xml
QueryRestsReply=./cache/rests.reply
optoutFile=./cache/optout
ReplyRestsFile=./cache/ReplyRests.xml
SleepTimeout=30

#####################

log ()
{
    ./bin/logger.o $logfile `date +%F=%H-%M-%S` "getrests.sh: ${1}"
    if [[ $Log2Console -eq 1 ]]
    then
	echo `date +%F=%H-%M-%S` "getrests.sh: ${1}"
    fi
}

make_queryrests ()
{
    #Forming Queryrests request file
    rm -f $QueryRestsFile
    touch $QueryRestsFile

    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $QueryRestsFile
    echo "<ns:Documents Version=\"1.0\"" >> $QueryRestsFile
    echo "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" >> $QueryRestsFile
    echo "xmlns:ns=\"http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01\"" >> $QueryRestsFile
    echo "xmlns:qp=\"http://fsrar.ru/WEGAIS/QueryParameters\">" >> $QueryRestsFile
    echo "<ns:Owner>" >> $QueryRestsFile
    echo "<ns:FSRAR_ID>${FSRAR_ID}</ns:FSRAR_ID>" >> $QueryRestsFile
    echo "</ns:Owner>" >> $QueryRestsFile
    echo "<ns:Document>" >> $QueryRestsFile
    echo "<ns:QueryRests></ns:QueryRests>" >> $QueryRestsFile
    echo "</ns:Document>" >> $QueryRestsFile
    echo "</ns:Documents>" >> $QueryRestsFile

    #Put query into the UTM
    rm -f $QueryRestsReply
    curl -F "xml_file=@$QueryRestsFile" http://$UTM_IP_Address:$UTM_Port/opt/in/QueryRests > $QueryRestsReply
}


##Main()

if [[ $# -ne 9 ]]
then
    echo "too few parameters for getrests. exit"
    exit 2
fi

logfile=$1
FSRARIDFile=$2
UTM_IP_Address=$3
UTM_Port=$4
FSRAR_ID=`head -1 "${FSRARIDFile}"`
RestsListFile=$5
replytimeout=$6
let "replytimeout *= 2"
Log2Console=$7
LogBeer=$8
BeerProductVCode=$9

log "Формирование и отправка документа QueryRests."
make_queryrests

#Parse response from UTM
Rests_UUID=""
if [[ -f $QueryRestsReply ]]
then
    Rests_UUID=`./bin/parsenattnresponse.o $QueryRestsReply`
else
    echo "UTM returned nothing in response" > /dev/null
    log "Ошибка при отправке запроса QueryRests."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
fi

if [[ -z $Rests_UUID ]]
then
    echo "No ID was returned" > /dev/null
    log "В ответе УТМ не обнаружен идентификатор сессии документа QueryRests."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
else
    echo $Rests_UUID > /dev/null
    echo $Rests_UUID > $QueryRestsReply
    log "Идентификатор сессии документа QueryRests: ${Rests_UUID}"
fi

#log "Выполняется попытка получить ответ на документ QueryRests"
maxattempts=$replytimeout
for (( it=1; it<$maxattempts; it++ ))
do
    sleep $SleepTimeout
    log "[${it}] Выполняется попытка получить ответ на документ QueryRests."
    rm -f $optoutFile
    curl -X GET http://$UTM_IP_Address:$UTM_Port/opt/out > $optoutFile
    strurl=`cat ${optoutFile} | grep $Rests_UUID`
    if [[ -n $strurl ]]
    then
	strurl=`./bin/getlink.o "${strurl}"`
    else
	echo error > /dev/null
	log "Документ с искомым идентификатором ReplyRests не найден во входящих. Повторная проверка через ${SleepTimeout} секунд."
	continue
    fi

    rm -f $ReplyRestsFile
    if [[ -z $strurl ]]
    then
	echo error > /dev/null
	log "Документ найден, но не содержит ссылки на файл."
    else
	echo $strurl > /dev/null
	curl -X GET "$strurl" > $ReplyRestsFile
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

if [[ -f $ReplyRestsFile ]]
then
    echo good > /dev/null
    log "Получен файл ReplyRests."
else
    log "Файл ReplyRests не получен из УТМ."
    log "Завершение работы с ошибкой."
    exit 2
fi

ConclusionRejected=`cat $ReplyRestsFile | grep Conclusion | grep Rejected`
if [[ -n $ConclusionRejected ]]
then
    textComment=`cat $ReplyRestsFile | grep Comments`
    textLog=`./bin/getcomment.o "${textComment}"`
    log "${textLog}"
    rm -f $RestsListFile
    touch $RestsListFile
    exit 1
fi

#Parsing reply file to extract information about rests
rm -f $RestsListFile
beerrestsintotal=`./bin/extractrests.o ${BeerProductVCode}`
if [[ -f $RestsListFile ]]
then
    echo good > /dev/null
    log "Найдено ${beerrestsintotal} позиций на остатке."
else
    echo error > /dev/null
    log "Ошибка обработки списка остатков - список не сформирован."
    log "Завершение работы с ошибкой."
    exit 2
fi

#Logging rests
if [[ $LogBeer -eq 1 ]]
then
    it=1
    while read LINE
    do
	if [[ -z $LINE ]]
        then
	    continue
        fi
	echo $LINE > /dev/null
        quantity=`echo $LINE | awk '{print $1}'`
	alccode=`echo $LINE | awk '{print $2}'`
        informbregid=`echo $LINE | awk '{print $3}'`
	log "Найден остаток №${it}:"
        log "    Количество: ${quantity}"
	log "    Алкокод: ${alccode}"
        log "    Номер справки B: ${informbregid}"
	let "it += 1"
    done < $RestsListFile
fi

exit 0
