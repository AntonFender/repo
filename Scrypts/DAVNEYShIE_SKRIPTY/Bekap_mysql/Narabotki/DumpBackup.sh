#!/bin/bash

DB_BACKUP="/linuxcash/backup/mysql/`date +%Y-%m-%d`"
HN=`hostname` | awk -F. '{print $1}'
 
# Create the backup directory
mkdir -p $DB_BACKUP
 
# Remove backups older than 10 days
find /linuxcash/backup/mysql/ -maxdepth 1 -type d -mtime +3 -exec rm -rf {} \;
 
# Backup each database on the system
for db in $(mysql -e "show databases;" -uroot -proot -s  --skip-column-names|grep -viE '(staging|performance_schema|information_schema)');
    do
    /usr/bin/mysqldump -uroot -proot  --events --opt --single-transaction  $db | /bin/gzip -c > "$DB_BACKUP/mysqldump-$HN-$db-$(date +%Y-%m-%d).sql.gz";
done