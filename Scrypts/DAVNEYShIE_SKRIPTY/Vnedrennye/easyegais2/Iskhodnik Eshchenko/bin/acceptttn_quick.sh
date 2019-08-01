#!/bin/bash

##Service Definitions

optoutFile=./cache/optout
SleepTimeout=30
WayBillActFile_v3=./cache/WayBillAct_v3.xml
WayBillActFile_v2=./cache/WayBillAct_v2.xml
WayBillActReply=./cache/accept.reply
ticketsFile=./cache/tickets
ReplyWayBillActFile=./cache/ticket
TTNv2ListFile=./cache/ttns_v2.list

#####################

log ()
{
    ./bin/logger.o $logfile `date +%F=%H-%M-%S` "acceptttn_quick.sh: ${1}"
    if [[ $Log2Console -eq 1 ]]
    then
	echo `date +%F=%H-%M-%S` "acceptttn_quick.sh: ${1}"
    fi
}

make_acceptttn_v3 ()
{
    #Form file with accept
    rm -f $WayBillActFile_v3
    touch $WayBillActFile_v3

    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $WayBillActFile_v3
    echo "<ns:Documents Version=\"1.0\"" >> $WayBillActFile_v3
    echo "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" >> $WayBillActFile_v3
    echo "xmlns:ns= \"http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01\"" >> $WayBillActFile_v3
    echo "xmlns:wa= \"http://fsrar.ru/WEGAIS/ActTTNSingle_v3\"" >> $WayBillActFile_v3
    echo "xmlns:ce=\"http://fsrar.ru/WEGAIS/CommonV3\"" >> $WayBillActFile_v3
    echo ">" >> $WayBillActFile_v3
    echo "<ns:Owner>" >> $WayBillActFile_v3
    echo \<ns:FSRAR_ID\>$FSRAR_ID\<\/ns:FSRAR_ID\> >> $WayBillActFile_v3
    echo "</ns:Owner>" >> $WayBillActFile_v3
    echo "<ns:Document>" >> $WayBillActFile_v3
    echo "<ns:WayBillAct_v3>" >> $WayBillActFile_v3
    echo "<wa:Header>" >> $WayBillActFile_v3
    echo "<wa:IsAccept>Accepted</wa:IsAccept>" >> $WayBillActFile_v3
    echo \<wa:ACTNUMBER\>$1\<\/wa:ACTNUMBER\> >> $WayBillActFile_v3
    echo \<wa:ActDate\>`date +%F`\<\/wa:ActDate\> >> $WayBillActFile_v3
    echo \<wa:WBRegId\>$2\<\/wa:WBRegId\> >> $WayBillActFile_v3
    echo "<wa:Note>Ok!</wa:Note>" >> $WayBillActFile_v3
    echo "</wa:Header>" >> $WayBillActFile_v3
    echo "<wa:Content>" >> $WayBillActFile_v3
    echo "</wa:Content>" >> $WayBillActFile_v3
    echo "</ns:WayBillAct_v3>" >> $WayBillActFile_v3
    echo "</ns:Document>" >> $WayBillActFile_v3
    echo "</ns:Documents>" >> $WayBillActFile_v3

    #Put query into the UTM
    rm -f $WayBillActReply
    curl -F "xml_file=@$WayBillActFile_v3" http://$UTM_IP_Address:$UTM_Port/opt/in/WayBillAct_v3 > $WayBillActReply
}

make_acceptttn_v2 ()
{
    #Form file with accept
    rm -f $WayBillActFile_v2
    touch $WayBillActFile_v2

    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $WayBillActFile_v2
    echo "<ns:Documents Version=\"1.0\"" >> $WayBillActFile_v2
    echo "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" >> $WayBillActFile_v2
    echo "xmlns:ns= \"http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01\"" >> $WayBillActFile_v2
    echo "xmlns:oref=\"http://fsrar.ru/WEGAIS/ClientRef\"" >> $WayBillActFile_v2
    echo "xmlns:pref=\"http://fsrar.ru/WEGAIS/ProductRef\"" >> $WayBillActFile_v2
    echo "xmlns:wa= \"http://fsrar.ru/WEGAIS/ActTTNSingle_v2\"" >> $WayBillActFile_v2
    echo ">" >> $WayBillActFile_v2
    echo "<ns:Owner>" >> $WayBillActFile_v2
    echo \<ns:FSRAR_ID\>$FSRAR_ID\<\/ns:FSRAR_ID\> >> $WayBillActFile_v2
    echo "</ns:Owner>" >> $WayBillActFile_v2
    echo "<ns:Document>" >> $WayBillActFile_v2
    echo "<ns:WayBillAct_v2>" >> $WayBillActFile_v2
    echo "<wa:Header>" >> $WayBillActFile_v2
    echo "<wa:IsAccept>Accepted</wa:IsAccept>" >> $WayBillActFile_v2
    echo \<wa:ACTNUMBER\>$1\<\/wa:ACTNUMBER\> >> $WayBillActFile_v2
    echo \<wa:ActDate\>`date +%F`\<\/wa:ActDate\> >> $WayBillActFile_v2
    echo \<wa:WBRegId\>$2\<\/wa:WBRegId\> >> $WayBillActFile_v2
    echo "<wa:Note>Ok!</wa:Note>" >> $WayBillActFile_v2
    echo "</wa:Header>" >> $WayBillActFile_v2
    echo "<wa:Content>" >> $WayBillActFile_v2
    echo "</wa:Content>" >> $WayBillActFile_v2
    echo "</ns:WayBillAct_v2>" >> $WayBillActFile_v2
    echo "</ns:Document>" >> $WayBillActFile_v2
    echo "</ns:Documents>" >> $WayBillActFile_v2

    #Put query into the UTM
    rm -f $WayBillActReply
    curl -F "xml_file=@$WayBillActFile_v2" http://$UTM_IP_Address:$UTM_Port/opt/in/WayBillAct_v2 > $WayBillActReply
}


##Main()

if [[ $# -ne 7 ]]
then
    echo "too few parameters for acceptttn_quick. exit"
    exit 2
fi

logfile=$1
FSRARIDFile=$2
UTM_IP_Address=$3
UTM_Port=$4
TTNListFile=$5
FSRAR_ID=`head -1 "${FSRARIDFile}"`
replytimeout=$6
let "replytimeout *= 2"
Log2Console=$7

rm -f $TTNv2ListFile
#Accept ttns (if any)
#v3
isErrorTTN=0
while read LINE
do
    if [[ -z $LINE ]]
    then
        continue
    fi
    echo $LINE > /dev/null
    wbregid=`echo $LINE | awk '{print $1}'`
    actnum="${wbregid:4:10}-1"
    log "Отправка подтверждения накладной ${wbregid}."
    make_acceptttn_v3 $actnum $wbregid
    #Parse response from UTM
    ACCEPT_UUID=""
    if [[ -f $WayBillActReply ]]
    then
        ACCEPT_UUID=`./bin/parsenattnresponse.o $WayBillActReply`
    else
        echo "UTM returned nothing in response" > /dev/null
        log "Ошибка при отправке запроса WayBillAct."
        log "Возможная причина: УТМ недоступен, либо работает некорректно."
        log "Завершение работы с ошибкой."
        exit 2
    fi

    if [[ -z $ACCEPT_UUID ]]
    then
        echo "No ID was returned" > /dev/null
        log "В ответе УТМ не обнаружен идентификатор сессии документа WayBillAct."
        log "Возможная причина: УТМ недоступен, либо работает некорректно."
        log "Завершение работы с ошибкой."
        exit 2
    else
        echo $ACCEPT_UUID > /dev/null
        echo $ACCEPT_UUID > $WayBillActReply
        log "Идентификатор сессии документа WayBillAct: ${ACCEPT_UUID}"
    fi

    ticketActAccepted=0
    ticketTTNAccepted=0
    #log "Выполняется попытка получить ответ на документ WayBillAct"
    maxattempts=$replytimeout
    for (( it=1; it<$maxattempts; it++ ))
    do
        sleep $SleepTimeout
        log "[${it}] Выполняется попытка получить ответ на документ WayBillAct."
        rm -f $optoutFile
        curl -X GET http://$UTM_IP_Address:$UTM_Port/opt/out > $optoutFile
        strurl=`cat ${optoutFile} | grep $ACCEPT_UUID`
        if [[ -n $strurl ]]
        then
            cat ${optoutFile} | grep $ACCEPT_UUID > $ticketsFile
        else
            echo error > /dev/null
            log "Документ с искомым идентификатором WayBillAct не найден во входящих. Повторная проверка через ${SleepTimeout} секунд."
            continue
        fi

        rm -f $ReplyWayBillActFile.*
        it2=1
	not_error=0
        while read LINE1
        do
            strurl=`./bin/getlink.o "${LINE1}"`
            if [[ -z $strurl ]]
            then
                echo error > /dev/null
                log "Документ найден, но не содержит ссылки на файл."
            else
                curl -X GET "$strurl" > $ReplyWayBillActFile.$it2.xml
                resultAct=`cat $ReplyWayBillActFile.$it2.xml | grep Comments`
                resultTTN=`cat $ReplyWayBillActFile.$it2.xml | grep OperationComment`
		resultError=`cat $ReplyWayBillActFile.$it2.xml | grep Conclusion | grep Rejected`
                if [[ -n $resultAct ]]
                then
                    text2=`./bin/getcomment.o "$resultAct"`
                    log "${text2}"
		    if [[ $text2 == *"формата акта разногласий не соответствует версии формата накладной"* ]]
		    then
			echo ${wbregid} >> $TTNv2ListFile
			log "Позже будет предпринята попытка подтвердить накладную ${wbregid} с версией формата v2."
			not_error=1
		    fi
                    ticketActAccepted=1
                fi
                if [[ -n $resultTTN ]]
                then
                    text2=`./bin/getcomment.o "$resultTTN"`
                    log "${text2}"
                    ticketTTNAccepted=1
                fi
		if [[ -n $resultError ]]
		then
		    if [[ $not_error -eq 0 ]]
		    then
			isErrorTTN=1
		    fi
		    #do not toggle ticketAct because Reject ticket do have Comments section in it, thus resultAct is not empty and it have been already logged reason of rejection
		    #ticketActAccepted=1
		    ticketTTNAccepted=1
		    break;
		fi
            fi
            let "it2 += 1"
        done < $ticketsFile

        if [[ ticketActAccepted -eq 1 ]]
        then
            if [[ ticketTTNAccepted -eq 1 ]]
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
        log "Накладная ${wbregid} может быть не подтверждена."
	log "Продолжаем работу."
	isErrorTTN=1
    fi
done < $TTNListFile

#v2
while read LINE
do
    if [[ -z $LINE ]]
    then
        continue
    fi
    echo $LINE > /dev/null
    wbregid=`echo $LINE | awk '{print $1}'`
    actnum="${wbregid:4:10}-1"
    log "Отправка подтверждения в версии формата v2 для накладной ${wbregid}."
    make_acceptttn_v2 $actnum $wbregid
    #Parse response from UTM
    ACCEPT_UUID=""
    if [[ -f $WayBillActReply ]]
    then
        ACCEPT_UUID=`./bin/parsenattnresponse.o $WayBillActReply`
    else
        echo "UTM returned nothing in response" > /dev/null
        log "Ошибка при отправке запроса WayBillAct."
        log "Возможная причина: УТМ недоступен, либо работает некорректно."
        log "Завершение работы с ошибкой."
        exit 2
    fi

    if [[ -z $ACCEPT_UUID ]]
    then
        echo "No ID was returned" > /dev/null
        log "В ответе УТМ не обнаружен идентификатор сессии документа WayBillAct."
        log "Возможная причина: УТМ недоступен, либо работает некорректно."
        log "Завершение работы с ошибкой."
        exit 2
    else
        echo $ACCEPT_UUID > /dev/null
        echo $ACCEPT_UUID > $WayBillActReply
        log "Идентификатор сессии документа WayBillAct: ${ACCEPT_UUID}"
    fi

    ticketActAccepted=0
    ticketTTNAccepted=0
    #log "Выполняется попытка получить ответ на документ WayBillAct"
    maxattempts=$replytimeout
    for (( it=1; it<$maxattempts; it++ ))
    do
        sleep $SleepTimeout
        log "[${it}] Выполняется попытка получить ответ на документ WayBillAct."
        rm -f $optoutFile
        curl -X GET http://$UTM_IP_Address:$UTM_Port/opt/out > $optoutFile
        strurl=`cat ${optoutFile} | grep $ACCEPT_UUID`
        if [[ -n $strurl ]]
        then
            cat ${optoutFile} | grep $ACCEPT_UUID > $ticketsFile
        else
            echo error > /dev/null
            log "Документ с искомым идентификатором WayBillAct не найден во входящих. Повторная проверка через ${SleepTimeout} секунд."
            continue
        fi

        rm -f $ReplyWayBillActFile.*
        it2=1
        while read LINE1
        do
            strurl=`./bin/getlink.o "${LINE1}"`
            if [[ -z $strurl ]]
            then
                echo error > /dev/null
                log "Документ найден, но не содержит ссылки на файл."
            else
                curl -X GET "$strurl" > $ReplyWayBillActFile.$it2.xml
                resultAct=`cat $ReplyWayBillActFile.$it2.xml | grep Comments`
                resultTTN=`cat $ReplyWayBillActFile.$it2.xml | grep OperationComment`
                resultError=`cat $ReplyWayBillActFile.$it2.xml | grep Conclusion | grep Rejected`
                if [[ -n $resultAct ]]
                then
                    text2=`./bin/getcomment.o "$resultAct"`
                    log "${text2}"
                    ticketActAccepted=1
                fi
                if [[ -n $resultTTN ]]
                then
                    text2=`./bin/getcomment.o "$resultTTN"`
                    log "${text2}"
                    ticketTTNAccepted=1
                fi
		if [[ -n $resultError ]]
		then
		    isErrorTTN=1
		    #do not toggle ticketAct because Reject ticket do have Comments section in it, thus resultAct is not empty and it have been already logged reason of rejection
		    #ticketActAccepted=1
		    ticketTTNAccepted=1
		    break;
		fi
            fi
            let "it2 += 1"
        done < $ticketsFile

        if [[ ticketActAccepted -eq 1 ]]
        then
            if [[ ticketTTNAccepted -eq 1 ]]
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
        log "Накладная ${wbregid} может быть не подтверждена."
	   log "Продолжаем работу."
	   isErrorTTN=1
    fi
done < $TTNv2ListFile

exit $isErrorTTN
