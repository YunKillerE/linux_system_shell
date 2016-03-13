#!/bin/bash
#****************************************************************#
# ScriptName: innobackupex.sh
# Author: 云尘(jimmy)
# Create Date: 2015-12-20 19:22
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-12-20 19:22
# Function: 
#***************************************************************#
#备份总目录
backup_path="/root/mysqlbackup"
#备份文件名称
backup_filename=`date +%Y%m%d%H`
#备份前一天的文件名称
yesteday_filename=`date -d '1 days ago' +%Y%m%d`
#备份子目录名称
backup_directory=`date +%Y%m%d`
#全量备份名称
full_backup_name="full_backup"
#增量备份名称
incremental_backup_name="incremental_$backup_filename"
#mysql数据存放目录
mysql_datadir="/data/mysql"
#mysql启动和停止
mysqld_start="service mysqld start"
mysqld_stop="service mysqld stop"
#mysql用户
mysql_user="root"
#mysql密码
mysql_passwd="xxxxxxx"
#mysql默认配置文件
default_file="/etc/my.cnf"
#备份时使用的内存，数据库在G级别以上可以加快备份速度
use_memory="1G"

#stop mysql and clear datadir
Stop_Mysql() {
  #stop mysql
  $mysqld_stop
  mpid=`netstat -tunlp |grep 3306 |awk '{print $NF}'|cut -d'/' -f1`
  if [ -n $mpid ];then
          kill -9 $mpid
  else
          :
  fi
  #bakcup datadir
  if [ -d $backup_path/datadir ];then
          rm -rf $backup_path/datadir/*
          mv -f $mysql_datadir  $backup_path/datadir
  else
          mkdir $backup_path/datadir
          mv -f $mysql_datadir  $backup_path/datadir
  fi

  #clear datadir
  rm -rf $mysql_datadir
  mkdir $mysql_datadir

}

#还原时数据库数据清理
Mysql_Data_Update() {
  echo "clear data....."
  cat $spwd/sql.ini | while read i
  do
          mysql -u$mysql_user -p$mysql_passwd -e "$i"
  done
}


#压缩前一天的备份，节省空间
Make_Tar_Gz() {
 cd $backup_path
 if [ -f $yesteday_filename ];then
         tar -zcvf $yesteday_filename.tgz $yesteday_filename
 fi
}

#全量备份函数
Full_Backup_Zip() {
  Make_Tar_Gz
  rm -rf $backup_path/$backup_directory
  tmp_path="$backup_path/$backup_directory/$full_backup_name"
  mkdir -p $tmp_path
  innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --no-timestamp --use-memory=$use_memory --stream=tar $tmp_path | gzip - > $tmp_path/$backup_filename.tar.gz
}

Full_Backup() {
  rm -rf $backup_path/$backup_directory
  tmp_path="$backup_path/$backup_directory"
  mkdir -p $tmp_path
  innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --no-timestamp --use-memory=$use_memory $tmp_path/$full_backup_name
}
#全量还原函数
Full_Restore() {
  #stop mysql and clear datadir
  Stop_Mysql
  cd  $1
  innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --apply-log $1
  innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --copy-back $1
  chown -R mysql:mysql $mysql_datadir
  $mysqld_start
  #clear data
  Mysql_Data_Update
}

#增量备份
Incremental_Backup() {
  cd $backup_path/$backup_directory
  rm -rf $backup_filename
  countls=`ls -l |grep -v total |wc -l`
  lastls=`ls -l |grep -v total | awk '{print $NF}' |tail -2 |head -1`
  if [ -d $full_backup_name ];then
          :
  else
          Full_Backup
  fi

  if [ $countls = 1 ];then
          innobackupex --defaults-file=$default_file  --user=$mysql_user --password=$mysql_passwd --no-timestamp  --incremental-basedir=$backup_path/$backup_directory/$full_backup_name --incremental $backup_path/$backup_directory/$backup_filename
  elif [ $countls -gt 1 ];then
          innobackupex --defaults-file=$default_file  --user=$mysql_user --password=$mysql_passwd --no-timestamp  --incremental-basedir=$backup_path/$backup_directory/$lastls --incremental $backup_path/$backup_directory/$backup_filename
  else
          echo "当前备份目录有手动创建的文件，这回导致备份失败，请检查并删除！！"
  fi
}

#增量备份还原是调用的函数
Full_Restore_inc() {
  #stop mysql and clear datadir
  Stop_Mysql
  cd  $1
  innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --apply-log $1/$full_backup_name
  innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --copy-back $1/$full_backup_name
  chown -R mysql:mysql $mysql_datadir
  $mysqld_start
}

#增量备份还原
Incremental_Restore() {
  if [ -z $1 ];then
          echo "请带参数执行增量备份还原，参数为增量备份目录"
          exit 1
  fi
  #Incremental_Backup
  cd $1
  if [ -d $full_backup_name ];then
          :
  else
          Full_Backup
  fi
  basename=`ls -l |grep -v total |awk '{print $NF}' |tail -1`
  lastls=`ls -l |grep -v total | awk '{print $NF}' |grep -v $basename`
  innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --apply-log --redo-only $1/$full_backup_name
  for i in $lastls
  do
          innobackupex --defaults-file=$default_file --user=$mysql_user --password=$mysql_passwd --apply-log --redo-only  $1/$full_backup_name --incremental-dir=$1/$i
  done
  Full_Restore_inc $1
  #clear data
  Mysql_Data_Update
}

if [ X$1 = XFull_Backup ];then
	Full_Backup
elif [ X$1 = XIncremental_Backup ];then
	Incremental_Backup
elif [ X$2 = XIncremental_Restore ];then
	Incremental_Restore $1
elif [ X$2 = XFull_Restore ];then
	Full_Restore $1
else
	echo "input error!!"
fi


