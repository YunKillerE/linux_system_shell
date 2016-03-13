#!/bin/bash
#****************************************************************#
# ScriptName: uninstall.sh
# Function: 
#***************************************************************#
Uninstall_Tomcat(){
  echo "begin uninstall tomcat...."
  PID=`ps -ef|grep tomcat | grep -v grep | awk '{print $2}'`
  echo $PID
  [ ! -z $PID ]&&kill -9 $PID
  rm -rf /opt/tomcat
  rm -rf /opt/apache-tomcat-8.0.26
}

Uninstall_Jdk() {
  echo "begin uninstall jdk......"
  rm -rf /usr/local/jdk
  rm -rf /usr/local/jdk1.8.0_45
  sed -i /'export JAVA_HOME='/d /etc/profile
  sed -i "s#export\ PATH=\$JAVA_HOME/bin:#export\ PATH=#g" /etc/profile
  sed -i /'export CLASSPATH=.:$JAVA_HOME'/d /etc/profile
}

Uninstall_Mediator() {
  rm -rf /tmp/mediator-agent
  PID=`ps -ef|grep tomcat | grep -v grep | awk '{print $2}'`
  echo $PID
  [ ! -z $PID ]&&kill -9 $PID
  mv /opt/apache-tomcat-8.0.26/webapps/mediator-agent /tmp
}

if [ X$1 = Xjdk ];then
        Uninstall_Jdk
elif [ X$1 = Xtomcat ];then
        Uninstall_Tomcat
elif [ X$1 = Xall ];then
        Uninstall_Tomcat
        Uninstall_Jdk
else
        Uninstall_Mediator
fi
