#!/bin/bash

##Service Definitions

optoutFile=./cache/optoutWO
SleepTimeout=30
ActWriteOffFile_v3=./cache/ActWriteOff_v3.xml
ActWriteOffReply=./cache/writeoff.reply
ticketsFile=./cache/ticketsWO
ReplyActWriteOffFile=./cache/ticketWO

#####################

log ()
{
    ./bin/logger.o $logfile `date +%F=%H-%M-%S` "writeoffbeer.sh: ${1}"
    if [[ $Log2Console -eq 1 ]]
    then
        echo `date +%F=%H-%M-%S` "writeoffbeer.sh: ${1}"
    fi
}

make_writeoff_v3 ()
{
    #Forming ActWriteOff request file
    rm -f $ActWriteOffFile_v3
    touch $ActWriteOffFile_v3

    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $ActWriteOffFile_v3
    echo "<ns:Documents xmlns:awr=\"http://fsrar.ru/WEGAIS/ActWriteOff_v3\"" >> $ActWriteOffFile_v3
    echo "xmlns:ce=\"http://fsrar.ru/WEGAIS/CommonV3\"" >> $ActWriteOffFile_v3
    echo "xmlns:ns=\"http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01\"" >> $ActWriteOffFile_v3
    echo "xmlns:oref=\"http://fsrar.ru/WEGAIS/ClientRef_v2\"" >> $ActWriteOffFile_v3
    echo "xmlns:pref=\"http://fsrar.ru/WEGAIS/ProductRef_v2\"" >> $ActWriteOffFile_v3
    echo "xmlns:unqualified_element=\"http://fsrar.ru/WEGAIS/CommonEnum\"" >> $ActWriteOffFile_v3
    echo "xmlns:xs=\"http://www.w3.org/2001/XMLSchema\"" >> $ActWriteOffFile_v3
    echo "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" >> $ActWriteOffFile_v3
    echo "<ns:Owner>" >> $ActWriteOffFile_v3
    echo \<ns:FSRAR_ID\>$FSRAR_ID\<\/ns:FSRAR_ID\> >> $ActWriteOffFile_v3
    echo "</ns:Owner>" >> $ActWriteOffFile_v3
    echo "<ns:Document>" >> $ActWriteOffFile_v3
    echo "<ns:ActWriteOff_v3>" >> $ActWriteOffFile_v3
    echo \<awr:Identity\>`date +%y%m%d-%H%M`\<\/awr:Identity\> >> $ActWriteOffFile_v3
    echo "<awr:Header>" >> $ActWriteOffFile_v3
    echo \<awr:ActNumber\>`date +%y%m%d-%H%M`-001\<\/awr:ActNumber\> >> $ActWriteOffFile_v3
    echo \<awr:ActDate\>`date +%F`\<\/awr:ActDate\> >> $ActWriteOffFile_v3
    echo "<awr:TypeWriteOff>Реализация</awr:TypeWriteOff>" >> $ActWriteOffFile_v3
    echo "</awr:Header>" >> $ActWriteOffFile_v3
    echo "<awr:Content>" >> $ActWriteOffFile_v3

    it=1
    while read LINE
    do
	if [[ -z $LINE ]]
	then
	    continue
	fi
	
	quantity=`echo $LINE | awk '{print $1}'`
	informbregid=`echo $LINE | awk '{print $3}'`
	echo "<awr:Position>" >> $ActWriteOffFile_v3
	echo \<awr:Identity\>$it\<\/awr:Identity\> >> $ActWriteOffFile_v3
	echo \<awr:Quantity\>$quantity\<\/awr:Quantity\> >> $ActWriteOffFile_v3
	echo "<awr:InformF1F2>" >> $ActWriteOffFile_v3
	echo "<awr:InformF2>" >> $ActWriteOffFile_v3
	echo \<pref:F2RegId\>$informbregid\<\/pref:F2RegId\> >> $ActWriteOffFile_v3
	echo "</awr:InformF2>" >> $ActWriteOffFile_v3
	echo "</awr:InformF1F2>" >> $ActWriteOffFile_v3
	echo "</awr:Position>" >> $ActWriteOffFile_v3
	let "it += 1"
    done < $RestsListFile

    echo "</awr:Content>" >> $ActWriteOffFile_v3
    echo "</ns:ActWriteOff_v3>" >> $ActWriteOffFile_v3
    echo "</ns:Document>" >> $ActWriteOffFile_v3
    echo "</ns:Documents>" >> $ActWriteOffFile_v3

    if [[ $it -eq 1 ]]
    then
	return 1
    fi

    #Put query into the UTM
    rm -f $ActWriteOffReply
    curl -F "xml_file=@$ActWriteOffFile_v3" http://$UTM_IP_Address:$UTM_Port/opt/in/ActWriteOff_v3 > $ActWriteOffReply
}


##Main()

if [[ $# -ne 7 ]]
then
    echo "too few parameters for writeoffbeer. exit"
    exit 2
fi

logfile=$1
FSRARIDFile=$2
UTM_IP_Address=$3
UTM_Port=$4
RestsListFile=$5
FSRAR_ID=`head -1 "${FSRARIDFile}"`
replytimeout=$6
let "replytimeout *= 2"
Log2Console=$7

log "Формирование и отправка документа ActWriteOff_v3."
make_writeoff_v3
if [[ $? -eq 1 ]]
then
    log "Нет подходящих позиций для списания."
    exit 0
fi

#Parse response from UTM
AWO_UUID=""
if [[ -f $ActWriteOffReply ]]
then
    AWO_UUID=`./bin/parsenattnresponse.o $ActWriteOffReply`
else
    echo "UTM returned nothing in response" > /dev/null
    log "Ошибка при отправке акта ActWriteOff_v3."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
fi

if [[ -z $AWO_UUID ]]
then
    echo "No ID was returned" > /dev/null
    log "В ответе УТМ не обнаружен идентификатор сессии документа ActWriteOff_v3."
    log "Возможная причина: УТМ недоступен, либо работает некорректно."
    log "Завершение работы с ошибкой."
    exit 2
else
    echo $AWO_UUID > /dev/null
    echo $AWO_UUID > $ActWriteOffReply
    log "Идентификатор сессии документа ActWriteOff_v3: ${AWO_UUID}"
fi

isErrorWO=0
ticketActAccepted=0
ticketWOAccepted=0
#log "Выполняется попытка получить ответ на документ ActWriteOff"
maxattempts=$replytimeout
for (( it=1; it<$maxattempts; it++ ))
do
    sleep $SleepTimeout
    log "[${it}] Выполняется попытка получить ответ на документ ActWriteOff."
    rm -f $optoutFile
    curl -X GET http://$UTM_IP_Address:$UTM_Port/opt/out > $optoutFile
    strurl=`cat ${optoutFile} | grep $AWO_UUID`
    if [[ -n $strurl ]]
    then
        cat ${optoutFile} | grep $AWO_UUID > $ticketsFile
    else
        echo error > /dev/null
        log "Документ с искомым идентификатором ActWriteOff не найден во входящих. Повторная проверка через ${SleepTimeout} секунд."
        continue
    fi

    rm -f $ReplyActWriteOffFile.*
    it2=1
    while read LINE1
    do
        strurl=`./bin/getlink.o "${LINE1}"`
        if [[ -z $strurl ]]
        then
            echo error > /dev/null
            log "Документ найден, но не содержит ссылки на файл."
        else
            curl -X GET "$strurl" > $ReplyActWriteOffFile.$it2.xml
            resultAct=`cat $ReplyActWriteOffFile.$it2.xml | grep Comments`
            resultWO=`cat $ReplyActWriteOffFile.$it2.xml | grep OperationComment`
	    resultError=`cat $ReplyActWriteOffFile.$it2.xml | grep Conclusion | grep Rejected`
            if [[ -n $resultAct ]]
            then
                text2=`./bin/getcomment.o "$resultAct"`
                log "${text2}"
                ticketActAccepted=1
            fi
            if [[ -n $resultWO ]]
            then
                text2=`./bin/getcomment.o "$resultWO"`
                log "${text2}"
                ticketWOAccepted=1
            fi
	    if [[ -n $resultError ]]
            then
                isErrorWO=1
                ticketWOAccepted=1
                break;
            fi
        fi
        let "it2 += 1"
    done < $ticketsFile

    if [[ ticketActAccepted -eq 1 ]]
    then
        if [[ ticketWOAccepted -eq 1 ]]
        then
            #cleanup
            while read LINE1
            do
                strurl=`./bin/getlink.o "${LINE1}"`
                if [[ -n $strurl ]]
                then
                    curl -X DELETE "$strurl"
                fi
            done < $ticketsFile
            #and leave
            break
        fi
    fi
done

if [[ $it -eq $maxattempts ]]
then
    log "Один из документов ответа не поступил в УТМ за разумное время."
    log "Списание может быть не осуществлено полностью."
    isErrorWO=1
fi

exit $isErrorWO
