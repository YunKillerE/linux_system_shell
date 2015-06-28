#!/bin/bash
#Auther:jimmy
#date:2015-6-16

path=/root/bkmysql/.mysqlbackup

#vari
DATE_TIME=`date +%Y%m%d`
BACKUPFOLDER="database_backup"
DB_HOSTNAME="localhost"
DB_USERNAME="root"
DB_PASSWORD=""
DATABASES_NAME=(ges test_ges site)

#backup function

function backup_mysql(){
	
	/usr/bin/mysqldump -u"$DB_USERNAME" -p"$DB_PASSWORD" -h "$DB_HOSTNAME" $1>$path/"$BACKUPFOLDER"_"$DATE_TIME"/"$1"_"$DATE_TIME".sql
}

function restore_mysql(){
	
	#/usr/bin/mysql -u"$DB_USERNAME" -p"$DB_PASSWORD" -h "$DB_HOSTNAME" $1<$path/"$BACKUPFOLDER"_"$DATE_TIME"/"$1"_"$DATE_TIME".sql
	/usr/bin/mysql -u"$DB_USERNAME" -h "$DB_HOSTNAME" $1<$path/$BACKUPFOLDER"_"$DATE_TIME/$1"_"$DATE_TIME.sql
}

function decide(){

	if [ $1 = 0 ] ;then
		echo "$path/$BACKUPFOLDER"_"$DATE_TIME/$1"_"$DATE_TIME.sql mysqldump OK!" | mail -s "mysqldump OK! $2_$DATE_TIME.sql" liujmsunits@hotmail.com
	else
		echo "$path/$BACKUPFOLDER"_"$DATE_TIME/$1"_"$DATE_TIME.sql mysqldump failed" | mail -s "mysqldump Faild! $2_$DATE_TIME.sql" liujmsunits@hotmail.com
	fi
}

#mkdir $path/"$BACKUPFOLDER"_"$DATE_TIME"

for i in ${DATABASES_NAME[*]}
do
	restore_mysql $i
	decide $? $i
done

mysql -uroot -e "use ges;update g_menu set TARGET='http://t_www.goujiawang.com' where ID=1150;"
