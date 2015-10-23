#!/bin/bash
#****************************************************************#
# ScriptName: syncmysql.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-10-23 09:41
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-10-23 09:41
# Function: 
#***************************************************************#
#!/bin/bash
mailpath="/home/goujia/.mysql"
mysqlpath="/root/mysql/"
names=`date +%Y%m%d%M%S`
mkdir $mysqlpath/$names

function sshmysqlges(){
   echo "backup $1........................."

   ssh goujia@mail "mysqldump -uxxx -pxxxx -h rdsbzf6z2emzeyj.mysql.rds.aliyuncs.com $1 > $mailpath/$1_$names.sql"
   echo "download $1 to local.............."
   scp goujia@mail:"$mailpath/$1_$names.sql" $mysqlpath/$names
   echo "restore $1 to local $2............"
   mysql -uroot $2 < $mysqlpath/$names/$1_$names.sql
}

sshmysqlges $1 $2
