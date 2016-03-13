#!/bin/sh
#用法：参数1：linux 参数2：医院名称
mpath="/opt/mediator"
publicpath=$mpath/public
linuxpath=$mpath/linux
winpath=$mpath/windows
configpath=$publicpath/configfile/hospital
targetpath=$mpath/tomcat/mediator-agent
controlpath=$mpath/tomcat/control
shellpath=$mpath/shell

source $configpath/$2/configwget.sh

Dos2unixFile() {
  if [ -f $targetpath/linabc.txt ];then
          rm -rf $targetpath/linabc.txt
          cp $publicpath/winabc.txt $targetpath/linabc.txt
          dos2unix $targetpath/linabc.txt
  else
          cp $publicpath/winabc.txt $targetpath/linabc.txt
          dos2unix $targetpath/linabc.txt
  fi
}

LinuxZip() {
	
	rm -rf $mpath/tomcat/mediator-agent*
	unzip $publicpath/mediator-agent.zip -d $mpath/tomcat
	cp -rf $configpath/hospital/$1/*.properties $targetpath/WEB-INF/classes/
	cd $mpath/tomcat
	cp -rf $shellpath/PreExecution* $targetpath/
	zip -r mediator-agent.zip mediator-agent
	#mkdir $configpath/$1/
	cp -rf mediator-agent.zip $configpath/hospital/$1/
}

WindowsZip() {
	#source $configpath/$english_hospital_name/configwget.sh
	rm -rf $mpath/tomcat/mediator-agent
	unzip $mpath/mediator/$base_mediator_agent -d $mpath/tomcat/mediator-agent
	unzip $mpath/mediator/probe/$mediator_probe -d $mpath/tomcat/mediator-agent/WEB-INF/lib/
	#cp -rf $mpath/tomcat/*probe*/* $mpath/tomcat/mediator-agent/WEB-INF/lib/
	cp -rf $configpath/$1/*.properties $targetpath/WEB-INF/classes/
    #control
    unzip $mpath/mediator/$base_control_agent -d $mpath/tomcat/control
    cp -rf $configpath/$1/control.config.properties $controlpath/WEB-INF/classes/config.properties
    cp -rf $configpath/$1/control-db.properties $controlpath/WEB-INF/classes/control-db.properties
	cd $mpath/tomcat
	cp $shellpath/PreExecution.bat .
	cp -rf $winpath/MyTiJianClientUpdateTool.exe .
	cp -rf $winpath/MyTiJianClientUpdateService.exe .
	zip -r mediator-agent.zip mediator-agent control MyTiJianClientUpdateService.exe MyTiJianClientUpdateTool.exe PreExecution.bat
	#zip -r $1/$1.zip tomcat/mediator-agent shell
	#zip -r $1/all.zip tomcat/mediator-agent shell windows
	#mkdir $configpath/$1/
	mv -f mediator-agent.zip $configpath/$1/
	rm -rf $mpath/tomcat/*
}

if [ $# != 2 ] ;then
	echo "input error! you should input one args!!!"
	exit 1;
elif [ $1 = linux ] ;then
	LinuxZip $english_hospital_name
elif [ $1 = windows ] ;then
	WindowsZip $english_hospital_name
fi
