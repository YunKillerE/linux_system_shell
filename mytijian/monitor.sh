#!/bin/bash
#****************************************************************#
# ScriptName: monitor.sh
# Create Date: 2015-12-25 10:17
# Function: 
#***************************************************************#
xtomcat=`ps aux |grep tomcat |grep -v grep`
if [ -z $xtomcat ];then
        /opt/apache-tomcat-8.0.26/bin/startup.sh
else
        :
fi
