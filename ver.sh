#!/bin/bash
#****************************************************************#
# ScriptName: ver.sh
# Author: 云尘(jimmy)
# Create Date: 2015-12-15 22:28
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-12-15 22:28
# Function: 
#***************************************************************#
#当前目录
spwd=`pwd`
#需要监测的文件路径
filepath=$spwd/file
#tomcat pid
PID=`ps -ef|grep tomcat |grep $spwd| grep -v grep | awk '{print $2}'`

function CopyFile(){
for i in `cat $spwd/list`
do
        a=`echo $i |awk '{print $1}'`
        b=`echo $i |awk '{print $2}'`
        echo $a
        echo $b
        #cp $a $b
done
}

function decidefile(){
if [ -n $PID ]
then
        kill -9 $PID
        $spwd/bin/startup.sh
fi
}

if [ -f $filepath ]
then
        CopyFile
        decidefile
else
        :
fi
