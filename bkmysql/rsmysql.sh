
path=/root/bkmysql/.mysqlbackup

DATE_TIME=`date +%Y%m%d`
BACKUPFOLDER="database_rsync"

#backup function


function decide(){

	if [ $1 = 0 ] ;then
		echo "$path/$BACKUPFOLDER'_'$DATE_TIME/$1'_'$DATE_TIME rsync ok!" | mail -s "$DATE_TIME rsync 247 ok!" liujmsunits@hotmail.com
	else
		echo "$path/$BACKUPFOLDER'_'$DATE_TIME/$1'_'$DATE_TIME rsync error" | mail -s "$DATE_TIME rsync 247 error!" liujmsunits@hotmail.com
	fi
}
rsync -aSvH --password-file=/etc/rsyncd/secrets --bwlimit=800 root@112.124.xx.xx::mysql /root/bkmysql/.mysqlbackup >/dev/null 2>1&
decide $?
sleep 10
