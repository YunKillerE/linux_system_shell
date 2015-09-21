#change inotify variables

echo 81920 >/proc/sys/fs/inotify/max_user_watches
echo 12800 >/proc/sys/fs/inotify/max_user_instances
echo 163840 >/proc/sys/fs/inotify/max_queued_events

#variables
current_date=$(date +%Y%m%d_%H%M%S)
source_path=/home/bank/gh
log_file=/var/log/rsync_client.log
#rsync
rsync_server=120.26.122.216
rsync_user=root
rsync_pwd=/etc/secrets
rsync_module=ftpbank
#INOTIFY_EXCLUDE='(.*/*\.log|.*/*\.swp)$|^/tmp/src/mail/(2014|20.*/.*che.*)'
#RSYNC_EXCLUDE='/etc/rsyncd.d/rsync_exclude.lst'
#rsync client pwd check
if [ ! -e ${rsync_pwd} ];then
    echo -e "rsync client passwod file ${rsync_pwd} does not exist!"
    exit 0
fi
#inotify_function
inotify_fun(){
    /usr/bin/inotifywait -mrq --timefmt '%Y/%m/%d-%H:%M:%S' --format '%T %w %f' \
           -e modify,delete,create,move,attrib ${source_path} \
          | while read file
      do
          #/usr/bin/rsync -auvrtzopgP --exclude-from=${RSYNC_EXCLUDE} --progress --bwlimit=200 --password-file=${rsync_pwd} ${source_path} ${rsync_user}@${rsync_server}::${rsync_module} 
          /usr/bin/rsync -auvrtzopgP  --progress --password-file=${rsync_pwd} ${source_path} ${rsync_user}@${rsync_server}::${rsync_module} 
	sleep 100
	/bin/mv ${source_path}/*.txt  ${source_path}/old/
      done
}
#inotify log
inotify_fun >> ${log_file} 2>&1 &
