set +x
#!/bin/bash
#****************************************************************#
# ScriptName: tomcatloganalysis.sh
#***************************************************************#
spwd="/opt/logtmp"

ignoreclass="$spwd/ignoreclass"
mailcontent="$spwd/mailcontent"
emaillist="$spwd/emaillist"
scphost="$spwd/scphost"
directory="$spwd/directory"
workerror="$spwd/workerror"
uniqclass="$spwd/uniqclass"
allclass="$spwd/allclass"
mailsend="$spwd/mailsend"

#创建目录
Mkdir_Spwd() {
	echo Mkdir_Spwd
        if [ -d $spwd ];then
                :
        else
                mkdir $spwd
        fi
        if [ -f $ignoreclass ];then
                :
        else
                touch $ignoreclass
        fi
        if [ -f $emaillist ];then
                :
        else
                echo "pls create emaillist"
                exit 1
        fi
}

#生成邮件内容
Create_Content() {
	if [ -s $1 ];then
		ActualRows=`sed -n '$=' $1`
		echo $ActualRows > $rowsfile
		echo "ActualRows=$ActualRows"
		if [ $ActualRows = $rows ];then
			:
		elif [ $ActualRows > $rows ];then
				sed -n "$rows,$ActualRows p" $1 |grep ERROR > $workerror
				seqnum=`cat $workerror |wc -l`
				Intercept_String $seqnum
				#Add_Server_Name
		else #[ $ActualRows < $rows ];then
				:
		#else
		#		rows=1
		#		echo "rows=$rows"
		#		sed -n "$rows,$ActualRows p" $1 |grep ERROR > $workerror
		#		#let seqnum=$ActualRows-$rows+1
		#		seqnum=`cat $workerror |wc -l`
		#		echo "seqnum=$seqnum"
		#		Intercept_String $seqnum
		#		#Add_Server_Name
		fi
	else
		:
	fi
	#Add_Server_Name $mailcontent	
	echo "" >> $mailcontent
}

#处理字符串类
Intercept_String() {
        #1
        for i in `seq $1`
        do
		echo "\$1==$1"
		echo "i==$i"
            #classname=`sed -n "$i"p $workerror |awk '{print $5}' |cut -d'(' -f2 |cut -d':' -f1`
            #echo "classname=$classname"
            rowsclass=`sed -n "$i"p $workerror |awk '{print $5}'`
	    classname=`echo $rowsclass | cut -d'(' -f2 |cut -d':' -f1`
            echo "rowsclass=$rowsclass"

			if [ -n $classname ];then
				if grep "$classname" $ignoreclass ;then
					:
				else
					echo "$rowsclass" >>$allclass
				fi
			else
				:
			fi
		done
		
		sed -i '/^$/d' $allclass
		cat $allclass |sort |uniq > $uniqclass
		sed -i '/^$/d' $uniqclass
		for i in `cat $uniqclass`
		do
			#a=`echo $i |cut -d'!' -f1`
			#echo "a=$a"
			b=`echo $i |cut -d'(' -f2 |cut -d':' -f1`
			echo "b=$b"
			frequency=`grep "$b" $allclass |wc -l`
			echo "    $frequency         $i" >>$mailcontent
			unset frequency
		done
}

Send_Email() {
        if [ -s $emaillist -a -s $mailsend ];then
           for i in `cat $emaillist`
           do
                  cat $1 |mail -s "每小时错误汇总-`date +%Y-%m-%d-%H`" $i
           done
        else
            echo "no error!!! or no email!!! or no mailcontent!!!"
        fi
}

Scp_Mailcontent() {
	if [  -s $scphost ];then
		for i in `cat $scphost`
		do
			scp $i:$mailsend $spwd/$i.mailsend
		done
	else
		echo "scphost not exist!!"
	fi

}

Add_Server_Name() {
    if grep `hostname` $1;then
            :
    else
            sed -i "1 i\服务器名称：`hostname` 日志文件名称：$2" $1
    fi
}

Start_Log_Analysis() {
#	for i in `cat $directory`
#	do
		echo Start_Log_Analysis
		#Clear_File
		Mkdir_Spwd
		Create_Content $1
		#Send_Email
#	done
}

Create_Args_To_Start() {
	for i in `cat $directory`
	do
		echo "===================$i==========================="
		Clear_File start
		filename=`echo $i |cut -d'/' -f6` # 3:00 of every day need to set 0
		if [ -s $spwd/$filename ];then
			:
		else
		 	echo 1 > $spwd/$filename
		fi
		rowsfile="$spwd/$filename"
		rows=`cat $rowsfile`
		echo "rows=$rows"
		Start_Log_Analysis $i
		cat $mailcontent > $spwd/$filename.mailcontent
		XX_File $spwd/$filename.mailcontent
		Add_Server_Name "$spwd/$filename.mailcontent" "$filename"
	done
}

XX_File() {
	sed -i '/^$/d' $1
	cat $1 |sort |uniq > $spwd/xxtmp	
	cat $spwd/xxtmp > $1
	rm -rf $spwd/xxtmp
}

#清理文件
Clear_File() {
	if [ X$1 = Xrm ];then
	echo Clear_File
	rm -rf $uniqclass
	rm -rf $allclass
	rm -rf $workerror
	rm -rf $mailcontent
	rm -rf $spwd/*.mailcontent
	rm -rf $spwd/*mailsend

	touch $uniqclass
	touch $allclass
	touch $workerror
	touch $mailcontent
	elif [ X$1 = Xstart ];then
	rm -rf $uniqclass
        rm -rf $allclass
        rm -rf $workerror
        rm -rf $mailcontent

        touch $uniqclass
        touch $allclass
        touch $workerror
        touch $mailcontent
	elif [ X$1 = Xdelete ];then
	for i in `ls $spwd |egrep ^[0-9]*[1-9][0-9]*`
	do
		rm -rf $spwd/$i
	done
	else 
	rm -rf $uniqclass
	rm -rf $allclass
	rm -rf $workerror
	rm -rf $mailcontent
	rm -rf $spwd/*.mailcontent
	rm -rf $spwd/*mailsend
	fi
}

Send_Content_Mail() {
	cat $spwd/*.mailcontent > $mailsend
	Scp_Mailcontent //发邮件的那台服务器才需要执行此函数
	cat $spwd/*.mailsend >> $mailsend
	#Add_Server_Name
	Send_Email $mailsend
}

#Clear_File rm
Create_Args_To_Start
Send_Content_Mail

Clear_File
Clear_File delete
set -x
