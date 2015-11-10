#!/bin/bash
mailpath="/home/goujia/.mysql"
mysqlpath="/root/mysql/"
names=`date +%Y%m%d%M%S`
mkdir $mysqlpath/$names

function sshmysqlges(){
   echo "backup $1........................."
   ssh goujia@mail "mysqldump -ugoujia -pgoujia0512 -h rdsbzf6z2emzeyj.mysql.rds.aliyuncs.com $1 > $mailpath/$1_$names.sql"
   decide $?
   echo "download $1 to local.............."
   scp goujia@mail:"$mailpath/$1_$names.sql" $mysqlpath/$names
   decide $?
   echo "restore $1 to local $2............"
   mysql -uroot $2 < $mysqlpath/$names/$1_$names.sql
   decide $?
}

function decide(){
   if [ X$1 == X0 ]
   then
     echo "successful......................."
   else
     echo "The last command execute failure!"
     exit 1;
   fi
}

sshmysqlges $1 $2
