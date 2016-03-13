#!/bin/bash

path="/opt/.mysqlbackup"

#vari
DATE_TIME=`date +%Y%m%d`
BACKUPFOLDER="database_backup"
YESTDAYBACKUP=`date -d '1 days ago' +%Y%m%d`
DB_HOSTNAME="10.51.28.212"
DB_USERNAME="jkgj_root"
DB_PASSWORD="xxxxx"
DATABASES_NAME=(mytijian_prod jkgj)

#backup function
backup_mysql(){
	
	/usr/bin/mysqldump -u"$DB_USERNAME" -p"$DB_PASSWORD" -h "$DB_HOSTNAME" $1>$path/"$BACKUPFOLDER"_"$DATE_TIME"/"$1"_"$DATE_TIME".sql
}

function restore_mysql(){

  /usr/bin/mysql -u"$DB_USERNAME" -h "$DB_HOSTNAME" $1 < $path/$BACKUPFOLDER"_"$DATE_TIME/$1"_"$DATE_TIME.sql
}

decide(){

	if [ $1 = 0 ] ;then
		echo "$path/$BACKUPFOLDER'_'$DATE_TIME/$2'_'$DATE_TIME.sql mysqldump ok!" | mail -s "$2 Aliyun DB BK OK! $DATE_TIME" liujunming@mytijian.com
	else
		echo "$path/$BACKUPFOLDER'_'$DATE_TIME/$2'_'$DATE_TIME.sql mysqldump failed" | mail -s "$2 Aliyun DB BK Faild! $DATE_TIME" liujunming@mytijian.com
	fi
}

Tar_Gz(){
	cd $path
	if [ -d "$BACKUPFOLDER"_"$YESTDAYBACKUP" ];then
		tar -zcvf "$BACKUPFOLDER"_"$YESTDAYBACKUP".tgz "$BACKUPFOLDER"_"$DATE_TIME"
		rm -rf "$BACKUPFOLDER"_"$YESTDAYBACKUP"
	fi
}

BACKUP_MYSQL(){
	for i in ${DATABASES_NAME[*]}
	do
		backup_mysql $i
		decide $? $i
	done
}

RESTORE_MYSQL(){
	for i in ${DATABASES_NAME[*]}
	do
  		restore_mysql $i
  		decide $? $i
	done
}
if [ ! -d $path/"$BACKUPFOLDER"_"$DATE_TIME" ];then
	mkdir -p $path/"$BACKUPFOLDER"_"$DATE_TIME"
fi
Tar_Gz

if [ X$1 = Xbackup ];then
	BACKUP_MYSQL
elif [ X$1 = Xrestore ];then
	RESTORE_MYSQL
else 
	echo "input error!!"
fi



