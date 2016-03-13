#!/bin/bash
#用法：参数：医院名称
murl="http://spi.mytijian.com:mapport"
stageurl="http://spi.mytijian.com:mapport"
mpwd=`pwd`

function DecideArgs() {
	if [ $1 != 1 ];then
	echo "input error!! you should input one args:hospital name"
	exit 1
	else
		:
	fi
}

function decideisinstalled() {
if [ $? = 0 ];then
	echo "jdk/tomcat/mediot-agent installed!!"
else
	$1
fi
}

function decideisexist() {
if [ -d $1 ];then
	rm -rf $1
else
	:
fi
}

#install jdk
function jdkins() {
	wget $murl/linux/jdk.tgz
	decideisinstalled "echo 'jdk.tgz download failure!! reinstall install.sh' && exit 1"
	tar -zxvf $mpwd/jdk.tgz -C /usr/local/
	rm -rf $mpwd/jdk.tgz*
    mv /usr/local/jdk /tmp
	ln -s /usr/local/jdk1.8.0_45 /usr/local/jdk
	#echo "export JAVA_HOME=/usr/local/jdk" >> /etc/profile

	if grep "export PATH=" /etc/profile ;then
		sed -i '/export JAVA_HOME=/d' /etc/profile
 		sed -i "/export PATH=/i\export JAVA_HOME=/usr/local/jdk" /etc/profile
		sed -i "s#export\ PATH=#export\ PATH=\$JAVA_HOME/bin:#g" /etc/profile
	else
		echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile
	fi

	echo "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile
 	#sed -i "/export PATH=/i\export JAVA_HOME=/usr/local/jdk" /etc/profile
	#sed -i "s#export\ PATH=#export\ PATH=\$JAVA_HOME/bin:#g" /etc/profile
	source /etc/profile
}
function InstallJdk() {
#	decideisexist "/usr/local/jdk1.8.0_45"
	#source /etc/profile
	#which wget
	#decideisinstalled "rpm -ivh $murl/linux/wget.rpm"
	#which wget
	#if [ $? != 0 ];then
	#	echo "pls install wget!!"
	#	exit 1;
	#fi
	#which java
	#decideisinstalled "jdkins"
	#which java
    ls /usr/local/jdk1.8.0_45
	decideisinstalled "jdkins"
}

#install tomcat
function TomcatInstall() {
	#decideisexist "/opt/apache-tomcat-8.0.26"
	#decideisexist "/opt/tomcat"
	if [ -d /opt/apache-tomcat-8.0.26 -o -d /opt/tomcat ];then
		:
	else
		wget $murl/linux/tomcat.tgz 
		decideisinstalled "echo 'tomcat.tgz download failure!! reinstall install.sh' && exit 1"
		tar -zxvf $mpwd/tomcat.tgz -C /opt/
		ln -s /opt/apache-tomcat-8.0.26 /opt/tomcat
		rm -rf $mpwd/tomcat.tgz*
	fi
}

#unzip mediator-agent
function MediatorUnzip() {
	rm -rf /opt/tomcat/webapps/mediator-agent*
	rm -rf $mpwd/mediator-agent.zip*
	wget $murl/public/configfile/hospital/$1/mediator-agent.zip
	decideisinstalled "echo 'mediator-agent.tgz download failure!! reinstall install.sh' && exit 1"
	unzip $mpwd/mediator-agent.zip -d /opt/tomcat/webapps/
	rm -rf $mpwd/mediator-agent.zip*
}

function MediatorSeparateUnzip() {
	rm -rf /opt/tomcat/webapps/mediator-agent*
	rm -rf $mpwd/mediator-agent.zip*
    #download base mediator-agent.zip
	wget $stageurl/mediator/base_mediator_agent
    decideisinstalled "echo 'mediator-agent.tgz download failure!! reinstall install.sh' && exit 1"
    unzip $mpwd/base_mediator_agent -d /opt/tomcat/webapps/mediator-agent
    rm -rf $mpwd/mediator-agent*
    #download his zip
	wget $stageurl/mediator/probe/mediator_probe
	decideisinstalled "echo 'mediator-probe.tgz download failure!! reinstall install.sh' && exit 1"
    unzip $mpwd/mediator_probe -d /opt/tomcat/webapps/mediator-agent/WEB-INF/lib/
    mv /opt/tomcat/webapps/mediator-agent/WEB-INF/lib/mediator-probe*/* /opt/tomcat/webapps/mediator-agent/WEB-INF/lib/
    rm -rf $mpwd/mediator_probe*
    #download configfile
	wget $murl/public/configfile/hospital/english_hospital_name/agent-db.properties
    cp -rf agent-db.properties /opt/tomcat/webapps/mediator-agent/WEB-INF/classes/agent-db.properties
	decideisinstalled "echo 'mediator-english_hospital_name1.tgz download failure!! reinstall install.sh' && exit 1"
	wget $murl/public/configfile/hospital/english_hospital_name/config.properties
    cp -rf config.properties /opt/tomcat/webapps/mediator-agent/WEB-INF/classes/config.properties
	decideisinstalled "echo 'mediator-english_hospital_name2.tgz download failure!! reinstall install.sh' && exit 1"
	wget $murl/public/configfile/hospital/english_hospital_name/tasks.properties
    cp -rf tasks.properties /opt/tomcat/webapps/mediator-agent/WEB-INF/classes/tasks.properties
	decideisinstalled "echo 'mediator-english_hospital_name2.tgz download failure!! reinstall install.sh' && exit 1"
	rm -rf $mpwd/agent-db.properties
	rm -rf $mpwd/config.properties
	rm -rf $mpwd/tasks.properties
}

function deploy_control() {
	rm -rf /opt/tomcat/webapps/control*
	rm -rf $mpwd/control*
    #download base mediator-agent.zip
	wget $stageurl/mediator/base_control_agent
    decideisinstalled "echo 'mediator-agent.tgz download failure!! reinstall install.sh' && exit 1"
    unzip $mpwd/base_control_agent -d /opt/tomcat/webapps/control
    wget $murl/public/configfile/hospital/english_hospital_name/control.config.properties
    cp -rf control.config.properties /opt/tomcat/webapps/control/WEB-INF/classes/config.properties
    wget $murl/public/configfile/hospital/english_hospital_name/control-db.properties
    cp -rf control-db.properties /opt/tomcat/webapps/control/WEB-INF/classes/control-db.properties
    rm -rf $mpwd/control*
}

#copy PreExecution.sh
function CopyShellFile() {
  wget $murl/shell/PreExecution.sh
  cp -rf PreExecution.sh /opt/tomcat/
  rm -rf PreExecution.sh
	#cp -rf /opt/tomcat/webapps/mediator-agent/PreExecution.sh /opt/tomcat/
	#change permission
	chown -R mytijian:mytijian /opt/tomcat*
	chown -R mytijian:mytijian /opt/apache-tomcat-*
}

#useradd
function UserAddX() {
id mytijian
if [ $? = 0 ];then
	:
else
	useradd mytijian
	echo mytijian2015 |passwd -–stdin mytijian
fi
}

PostCommand() {

  cd /opt/tomcat
  echo "add crontab......"
  if grep PreExecution /var/spool/cron/mytijian ;then
	  :
  else	
	  echo "*/5 * * * * /bin/sh /opt/tomcat/PreExecution.sh" >> /var/spool/cron/mytijian
  fi
  chown mytijian:mytijian /var/spool/cron/mytijian 

  echo "add rc.local...."
  if grep "apache-tomcat-8.0.26" /etc/rc.local;then
          :
  else
      echo "/opt/apache-tomcat-8.0.26/bin/startup.sh" >> /etc/rc.local
  fi

  echo "部署成功！！"
  echo -e '\033[41;33;1m 开始切换到mytijian用户，然后手动执行/opt/tomcat/bin/startup.sh启动tomcat \033[0m'
  su mytijian
}

Install_Autossh() {
if [ -f /etc/redhat-release ];then
        :
else
        echo "this is not centos"
        exit 1
fi

ver=`cat /etc/redhat-release |grep -o '[0-9]' |head -1`

if [ $ver -lt 6 ] ; then
        echo 5
        rpm -ivh http://spi.mytijian.com/linux/autossh-1.4c-1.el5.rf.x86_64.rpm
else
        echo 67
        rpm -ivh http://spi.mytijian.com/linux/autossh-1.4c-2.el6.x86_64.rpm
fi



}

#start tomcat
#PID=`ps -ef|grep tomcat | grep -v grep | awk '{print $2}'`
#[ ! -n "$PID" ] || kill -9 $PID

#sudo -u jenkins /opt/tomcat/bin/startup.sh

#begin install
#DecideArgs $#
#if [ X$2 == Xall ] ;then
InstallJdk
TomcatInstall
#MediatorUnzip $1
MediatorSeparateUnzip
deploy_control
UserAddX
CopyShellFile
Install_Autossh

cd /opt/tomcat
echo "add crontab......"
if grep PreExecution /var/spool/cron/mytijian ;then
	:
else	
	echo "*/5 * * * * /bin/sh /opt/tomcat/PreExecution.sh" >> /var/spool/cron/mytijian
fi
chown mytijian:mytijian /var/spool/cron/mytijian 
echo "部署成功！！"
echo -e '\033[41;33;1m 开始切换到mytijian用户，然后手动执行/opt/tomcat/bin/startup.sh启动tomcat \033[0m'
su mytijian

#elif [ X$2 == Xagent ] ;then
#	MediatorUnzip $1
#	CopyShellFile
#	UserAddX
#else
#	echo "pls input at least two parameters"
#fi
