#!/bin/bash

DB_BACKUP="/opt/Backup/VarLibMysql/$(date +%Y-%m-%d)"

 
# Create the backup directory
mkdir -p $DB_BACKUP
 
# Remove backups older than 3 days
find /opt/Backup/VarLibMysql/ -maxdepth 1 -type d -mtime +3 -exec rm -rf {} \;

tar -czvf $DB_BACKUP/CopyVarLibMysql-$(date +%Y-%m-%d).tar.gz /var/lib/mysql
#zip -r -9 $DB_BACKUP/archive.zip /linuxcash/cash/data/mysql
