#!/bin/bash

#sudo stop virgo
#sleep 10
#sudo stop mongodb
#sleep 10
#sudo stop nes
#sleep 10
#sudo /etc/init.d/qpidd stop
#sleep 10
#sudo stop exchangers-upload
#sleep 10
#sudo stop exchangers-unload
#sleep 10



DB_BACKUP="/linuxcash/backup/mysql/`date +%Y-%m-%d`"
HN=`hostname` | awk -F. '{print $1}'
 
# Create the backup directory
mkdir -p $DB_BACKUP
 
# Remove backups older than 3 days
find /linuxcash/backup/mysql/ -maxdepth 1 -type d -mtime +2 -exec rm -rf {} \;
 
# Backup each database on the system
for db in $(mysql -e "show databases;" -uroot -proot -s  --skip-column-names|grep -viE '(staging|performance_schema|information_schema)');
    do
    /usr/bin/mysqldump -uroot -proot  --events --opt --single-transaction  $db | /bin/gzip -c > "$DB_BACKUP/mysqldump-$HN-$db-$(date +%Y-%m-%d).sql.gz";
done

#reboot