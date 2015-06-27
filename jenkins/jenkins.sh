#!/bin/bash
#****************************************************************#
# ScriptName: jenkins.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-06-27 16:45
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-06-27 16:46
# Function: 
#***************************************************************#
source /etc/profile

git pull origin `git branch -a |tail -1 |awk -F'/' '{print $NF}'`

mvn clean package

wpath=/home/goujia/project/goujia/web/website

#function
function sshweb(){
	#$1 host $2 command 
    ssh web1 "$1"
}

function jettyrestart(){
	ssh web1 "export PATH=/usr/local/jdk1.8.0_45/bin:$PATH && cd $1 && sudo -u goujia ./bin/jetty.sh stop && sleep 2 && sudo -u goujia ./bin/jetty.sh start && sleep 10"
}

function taillog(){
	ssh web1 "tail $wpath/bin/$1/logs/*.log"
}

#backup && scp all file to web  && change the file user
#sshweb "rm -rf $wpath/website.bak && mv $wpath/website $wpath/website.bak && mkdir $wpath/website"
scp -rp * web1:$wpath/website/
sshweb "chown -R goujia:goujia $wpath/website/"

#copy application.properties file to console
sshweb "cp -Rf $wpath/bin/application.properties $wpath/website/website-console/target/website-console-0.0.1-SNAPSHOT/WEB-INF/classes/application.properties"
sshweb "cp -Rf $wpath/bin/application.properties $wpath/website/website-console/target/classes/application.properties"

#copy application.properties file to web
sshweb "cp -Rf $wpath/bin/application1.properties $wpath/website/website-web/target/website-web-0.0.1-SNAPSHOT/WEB-INF/classes/application.properties"

#change ueidt
#sshweb "sed -i 's/PATH_CONTEXT="\/web"/PATH_CONTEXT="http:\/\/t_website.goujiawang.com"/g' $wpath/website/website-console/target/website-console-0.0.1-SNAPSHOT/source/sui/library/ueditor/ueditor.config.js"
sshweb "/bin/sh $wpath/bin/sed.sh"

#clear jetty log
sshweb "rm -rf $wpath/bin/jetty/logs/*"
sshweb "rm -rf $wpath/bin/jettyweb/logs/*"

#jetty restart 
jettyrestart $wpath/bin/jetty/ &
sleep 20
jettyrestart $wpath/bin/jettyweb/ &
sleep 20

#tail log
sleep 20
taillog jetty
sleep 20
taillog jettyweb

sleep 3
