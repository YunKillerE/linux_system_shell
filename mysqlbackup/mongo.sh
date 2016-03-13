#!/bin/bash

path="/opt/.mysqlbackup/mongodb"
#vari
DATE_TIME=`date +%Y%m%d`
BACKUPFOLDER="mongo_backup"
YESTDAYBACKUP=`date -d '1 days ago' +%Y%m%d`
DB_HOSTNAME="10.51.28.212"

#backup function
backup_mongo(){
	echo "begin backup mongo ..........."	
	mongodump -h $DB_HOSTNAME --port 22333 -o $path/$BACKUPFOLDER"_"$DATE_TIME
	echo "end backup mongo ............."	
}

function restore_mongo(){
	echo "begin restore mongo ..........."	
	mongorestore --host 10.117.26.117 --port 22333 $path/$BACKUPFOLDER"_"$DATE_TIME
	echo "end restore mongo ............."	
}

Tar_Gz_Today(){
        cd $path
        if [ -d "$BACKUPFOLDER"_"$DATE_TIME" ];then
                tar -zcvf "$BACKUPFOLDER"_"$DATE_TIME".tgz "$BACKUPFOLDER"_"$DATE_TIME"
                rm -rf "$BACKUPFOLDER"_"$YESTDAYBACKUP"
        fi
}

Create_Directory() {
if [ ! -d $path/"$BACKUPFOLDER"_"$DATE_TIME" ];then
	mkdir -p $path/"$BACKUPFOLDER"_"$DATE_TIME"
else
	rm -rf $path/"$BACKUPFOLDER"_"$DATE_TIME"
	mkdir -p $path/"$BACKUPFOLDER"_"$DATE_TIME"
fi
}

if [ X$1 = Xbackup ];then
	Create_Directory
	backup_mongo
	Tar_Gz_Today
elif [ X$1 = Xrestore ];then
	restore_mongo
else 
	echo "input error!!"
fi
