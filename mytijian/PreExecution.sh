set -x
#!/bin/bash
#当前目录
spwd="/opt/tomcat"
#需要监测的文件路径
filepath=$spwd/MYTIJIAN_RELOAD.ini
tmpfile1="/opt/tomcat/upgrade/mediator-agent"
tmpfile2="/opt/tomcat/upgrade/control"

Dos2unixFile() {
	if [ -f $tmpfile/linabc.txt ];then
		dos2unix $tmpfile/linabc.txt
	else
		exit 1;
	fi
}

download_upgrade(){

    if [ -s $filepath ];then
            url=`cat $filepath`
            if [ -n $url ];then
                    :
            else
                    echo "url is emety"
                    exit 1
            fi
    fi

    cd $spwd
    wget $url
    if [ X$? = X0 ];then
            :
    else
            echo "download file error!!"
            exit 1
    fi

}

#delete file
function UzipFile(){
    download_upgrade
    if [ -d $spwd/upgrade ];then
            rm -rf $spwd/upgrade/*
    else
	        mkdir $spwd/upgrade
    fi
	unzip $spwd/upgrade.zip -d $spwd/upgrade
	sed -i 's#\\#\/#g' $tmpfile/linabc.txt
}

MkdirBackup() {
        if [ -d $spwd/backup ];then
                :
        else
                mkdir $spwd/backup
        fi

}

function CopyFile(){
while read line
do
	a=`echo $line |awk '{print $1}'`
	b=`echo $line |awk '{print $2}'`
	echo a=$a
	echo b=$b
  echo "backup file $b ......"
  #cp -rf $spwd/$b $spwd/backup/`date +%Y%m`
  echo "upgrade file $a ......"
	cp -rf $1/$a $spwd/$b
	#chown $USER:$USER $spwd/$b
done < $1/linabc.txt
}

function delete_old_work_file(){
    while read delfile
    do
        if [ -n $delfile ];then
                cd $spwd
                rm -rf $delfile
        fi
    done < $1/del_linabc.txt
}

function decidefile(){
	if [ X$1 = Xstop ];then
		#tomcat pid
		PID=`ps -ef|grep tomcat| grep -v grep | awk '{print $2}'`
		if [ -n $PID ]
		then
			kill -9 $PID
		fi
	else
		#tomcat pid
		PID=`ps -ef|grep tomcat| grep -v grep | awk '{print $2}'`
		if [ -n $PID ]
		then
			kill -9 $PID
		fi
		source /etc/profile 2>&1 >/dev/null
		$spwd/bin/startup.sh
	fi
}


function DelFile(){
#while read line
#do
#	a=`echo $line |awk '{print $1}'`
#	b=`echo $line |awk '{print $2}'`
#	echo a=$a
#	echo b=$b
#	rm -rf $spwd/$a
#done < $spwd/linabc.txt
#	rm -rf $spwd/linabc.txt
#	rm -rf $spwd/winabc.txt
	mv $spwd/upgrade.zip $spwd/backup/upgrade-`date +%Y%m`.zip
	#mv $tmpfile/linabc.txt $spwd/backup
  	echo "delete tmpfile ......."
	rm -rf $filepath
	rm -rf $tmpfile
	rm -rf $spwd/upgrade.zip
}

function RecoveDirectory(){
	decidefile stop
	
	dirs=`date +%Y%m`
	mkdir -p $spwd/backup/$dirs
	mv $spwd/webapps/control $spwd/backup/$dirs
	mv $spwd/webapps/mediator-agent $spwd/backup/$dirs
	
	#mv directory to webapps
	mv $tmpfile/control $spwd/webapps/
	mv $tmpfile/mediator-agent $spwd/webapps/
}


if [ -f $filepath ]
then
	var=`cat $filepath`
	if [ X$var = Xrecove ];then
		UzipFile
		MkdirBackup
		RecoveDirectory
		decidefile
		DelFile
	else
		UzipFile
		MkdirBackup
		CopyFile $tmpfile1
		CopyFile $tmpfile2
        if [ -s $tmpfile1/del_linabc.txt ];then
            delete_old_work_file $tmpfile1
        fi
        if [ -s $tmpfile2/del_linabc.txt ];then
            delete_old_work_file $tmpfile2
        fi
    	decidefile
		DelFile
	fi
else
        :
fi
set +x

#!/bin/bash
#****************************************************************#
# ScriptName: monitor.sh
# Create Date: 2015-12-25 10:17
# Function: 
#***************************************************************#
xtomcat=`ps aux |grep tomcat |grep -v grep`
if [ -z "$xtomcat" ];then
		source /etc/profile 2>&1 >/dev/null
        /opt/apache-tomcat-8.0.26/bin/startup.sh
else
        :
fi
