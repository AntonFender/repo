#! /bin/bash
#

mysql -u root -p root <<EOF | sed -e 's/   /,/g' | tee list.txt
use documentsAll
select cashcode,name,minprice,sumb,ttime from goodsitem WHERE ttime >= DATE_SUB(CURRENT_DATE, INTERVAL 3 DAY) AND sumb LIKE '215.00';
EOF
