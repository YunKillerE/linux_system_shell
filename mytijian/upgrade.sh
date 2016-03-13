set -x
#!/bin/bash
#1，拷贝文件到/tmp/diff目录中
#2，进行比较，将不同的文件拷贝到upgrade目录中，并记录文件名及路径，创建linabc、winabc

directory_name="$1"
new_version="$2"
#tmp directory
diffpath="/tmp/diff"
#war file
new_war_path="/opt/mediator/mediator/mediator-agent-"$new_version".war"
old_zip_path="/opt/mediator/public/configfile/hospital/$directory_name/mediator-agent.zip"
control_war_path="/opt/mediator/mediator/control-"$new_version".war"
#diff file save path
upgrade_path="$diffpath/upgrade/mediator-agent"
control_upgrade_path="$diffpath/upgrade/control"
#txt file
linabc="$upgrade_path/linabc.txt"
winabc="$upgrade_path/winabc.txt"
control_linabc="$control_upgrade_path/linabc.txt"
control_winabc="$control_upgrade_path/winabc.txt"

#del txt file
del_linabc="$upgrade_path/del_linabc.txt"
del_winabc="$upgrade_path/del_winabc.txt"
del_control_linabc="$control_upgrade_path/del_linabc.txt"
del_control_winabc="$control_upgrade_path/del_winabc.txt"

save_upgrade="/opt/mediator/public/configfile/hospital/$directory_name"

diff_funtion() {
	if [ -f $new_war_path ];then
		:
	else
		echo "new version mediator-agent isn't exist!!"
		exit 1
	fi
	if [ -f $old_zip_path ];then
		:
	else
		echo "old version mediator-agent isn't exist!!"
	fi
	if [ -d /tmp/diff ];then
		rm -rf /tmp/diff/*
	else
		mkdir /tmp/diff
	fi
	if [ -d $upgrade_path ];then
		:
	else
		mkdir -p $upgrade_path
	fi
	if [ -d $control_upgrade_path ];then
		:
	else
		mkdir -p $control_upgrade_path
	fi
}

copy_file_to_diff() {
	diff_funtion
	#agent war
	unzip $new_war_path -d /tmp/diff/mediator-agent
    #unzip his zip
    source /opt/mediator/public/configfile/hospital/$directory_name/configwget.sh
    unzip /opt/mediator/mediator/probe/$mediator_probe -d $diffpath/mediator-agent/
    mv $diffpath/mediator-agent/mediator-probe*/* $diffpath/mediator-agent/WEB-INF/lib/
    rm -rf $diffpath/mediator-agent/mediator-probe*

	#old_zip
	unzip $old_zip_path -d /tmp/diff/mediator-agent-old
	rm -rf /tmp/diff/mediator-agent-old/*.exe
	rm -rf /tmp/diff/mediator-agent-old/*.bat
	mv /tmp/diff/mediator-agent-old/mediator-agent/* /tmp/diff/mediator-agent-old/
	rm -rf /tmp/diff/mediator-agent-old/mediator-agent

	#control war
	unzip $control_war_path -d /tmp/diff/control
	#old_zip
	mv /tmp/diff/mediator-agent-old/control /tmp/diff/control-old
}

diff_directory_file() {
	echo "create new_version ............."
	find $diffpath/mediator-agent/ -type f > /tmp/diff/new_version
	echo "create old_version.............."
	find $diffpath/mediator-agent-old/ -type f > /tmp/diff/old_version
	echo "create ok!!!"

	echo "create new_version_control ............."
	find $diffpath/control/ -type f > /tmp/diff/new_version_control
	echo "create old_version_control.............."
	find $diffpath/control-old/ -type f > /tmp/diff/old_version_control
	echo "create control ok!!!"
}

copy_config_file() {
	configfilepath="/opt/mediator/public/configfile/hospital/$directory_name"
	#cp -rf $configfilepath/*.properties $upgrade_path
	for i in `ls $configfilepath |grep .properties`
	do
		con=`echo $i | grep -o '^.......'`
		sed -i "/$i/d" $control_upgrade_path/*.txt
		sed -i "/$i/d" $upgrade_path/*.txt
		if [ X$con = Xcontrol ];then
			if [ X$i = Xcontrol.config.properties ];then
				cp $configfilepath/$i $control_upgrade_path/config.properties
				echo "config.properties webapps/control/WEB-INF/classes/config.properties" >> $control_upgrade_path/winabc.txt
				echo "config.properties webapps/control/WEB-INF/classes/config.properties" >> $control_upgrade_path/linabc.txt
			else
				cp $configfilepath/$i $control_upgrade_path
				echo "$i webapps/control/WEB-INF/classes/$i" >> $control_upgrade_path/winabc.txt
				echo "$i webapps/control/WEB-INF/classes/$i" >> $control_upgrade_path/linabc.txt
			fi
		else
			cp $configfilepath/$i $upgrade_path
			echo "$i webapps/mediator-agent/WEB-INF/classes/$i" >> $upgrade_path/winabc.txt
			echo "$i webapps/mediator-agent/WEB-INF/classes/$i" >> $upgrade_path/linabc.txt
		fi
	done
	sed -i 's/$/\r/' $upgrade_path/winabc.txt
	sed -i 's/$/\r/' $control_upgrade_path/winabc.txt
}


loop_file() {
	#\$1 is new war version file
	#\$2 is old war version file
	for i in `cat $1`
	do
		echo "=====================$i=========================="
		new_filename=`echo $i |awk -F'/' '{print $NF}'`
		new_filepath=`echo $i |sed  "s/pom.xml//g" |sed "s/\/tmp\/diff//g"` #不知道当时是怎么写的，不知道被谁改了，这地方貌似没什么意义

		echo "new_filename=$new_filename"
		echo "new_filepath=$new_filepath"

		old_filepath=`cat $2 |grep $new_filename`
		echo $old_filepath
		if [ -n $old_filepath ];then
			diff $i $old_filepath
			if [ X$? = X0 ];then
				:
			else
				cp $i $3
				lss=`echo $3 | grep -o '.......$'`
				if [ X$lss = Xcontrol ];then
					echo "$new_filename $i" >> $control_linabc
					echo "$new_filename $i" >> $control_winabc
				else
					echo "$new_filename $i" >> $linabc
					echo "$new_filename $i" >> $winabc
				fi
			fi
		else
			:
		fi
	done
}


loop_delete_file() {
	#\$1 is new war version file
	#\$2 is old war version file
	for i in `cat $2`
	do
		echo "=====================$i=========================="
		new_filename=`echo $i |awk -F'/' '{print $NF}'`
		new_filepath=`echo $i |sed  "s/pom.xml//g" |sed "s/\/tmp\/diff//g"` #不知道当时是怎么写的，不知道被谁改了，这地方貌似没什么意义

		echo "new_filename=$new_filename"
		echo "new_filepath=$new_filepath"

		old_filepath=`cat $1 |grep $new_filename`
		echo $old_filepath
		if [ -z $old_filepath ];then
				lss=`echo $3 | grep -o '.......$'`
				if [ X$lss = Xcontrol ];then
					echo "$i" >> $del_control_linabc
					echo "$i" >> $del_control_winabc
				else
					echo "$i" >> $del_linabc
					echo "$i" >> $del_winabc
				fi
		else
			:
		fi
	done
    sed -i "s/-old//g" $del_control_linabc $del_control_winabc $del_linabc $del_winabc
}

last_create_resoult(){
	copy_config_file

	sed -i "s/\/tmp\/diff/webapps/g" $diffpath/upgrade/control/*.txt
	sed -i "s/\/tmp\/diff/webapps/g" $diffpath/upgrade/mediator-agent/*.txt

    sed -i 's/$/\r/' $upgrade_path/*win*.txt
    sed -i 's/$/\r/' $control_upgrade_path/*win*.txt

    sed -i 's/\//\\/g' $upgrade_path/*win*.txt $control_upgrade_path/*win*.txt

	cd $diffpath/upgrade
	zip -r upgrade.zip *
	cp -rf $diffpath/upgrade/upgrade.zip $save_upgrade
	#rm -rf $save_upgrade/mediator-agent-last-version.zip
	mv $old_zip_path $save_upgrade/mediator-agent-last-version.zip
	#/bin/bash /opt/mediator/shell/makezip.sh windows $directory_name
	echo "pls command the makezip.sh shell to create new zip file!!"
}
copy_file_to_diff
diff_directory_file
loop_file "$diffpath/new_version" "$diffpath/old_version" $upgrade_path
loop_file "$diffpath/new_version_control" "$diffpath/old_version_control" $control_upgrade_path
loop_delete_file "$diffpath/new_version" "$diffpath/old_version" $upgrade_path
loop_delete_file "$diffpath/new_version_control" "$diffpath/old_version_control" $control_upgrade_path
last_create_resoult
set +
