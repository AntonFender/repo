#!/bin/bash

for i in `mysql -e 'show databases;' -unetroot -p'netroot' | grep -v "information_schema" | grep -v "backup" | grep -v "performance_schema" | grep -v Database`; 
    do 
	/usr/bin/mysqldump -unetroot -pnetroot $i  | /bin/gzip -c > /linuxcash/cash/data/mysql/backup/mysql/`date +%Y-%m-%d`-$i.gz;
    done
