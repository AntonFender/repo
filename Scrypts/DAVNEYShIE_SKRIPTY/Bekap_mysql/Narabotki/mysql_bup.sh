#!/bin/bash

suffix=$(date +%F)
dbs=$(sudo mysql -uroot -proot --defaults-extra-file=/etc/mysql/my.cnf --batch --skip-column-names -e "SHOW DATABASES;" | grep -E -v "(information|performance)_schema")
tmp=$(mktemp -d)
outDir="/var/backup/mysql"
out="$outDir/$suffix.tar.bz2"

if [ ! -d "$outDir" ];then
  mkdir -p "$outDir"
fi

for db in $dbs; do
  mysqldump --defaults-extra-file=/etc/mysql/my.cnf --databases "$db" > "$tmp/$db.sql"
done

cd $tmp
tar -jcf "$out" * > "/dev/null"
cd "/tmp/"
sudo rm -rf "$tmp"
