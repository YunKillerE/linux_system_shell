#!/bin/bash
#****************************************************************#
# ScriptName: remove_nginx_cluster_to_publish.sh
# Author: 云尘(jimmy)
# Create Date: 2015-11-19 13:36
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-11-19 13:36
# Function: 
#***************************************************************#
set -x
#===================================variables===================
tarpath="/home/goujia/tar"
tarfile="$tarpath/$(date +%Y%d).tgz"
allhost=(test1 web1)
decidenginxconfhost="test1"
prehost="web1"
nginxpath="/home/goujia/project/tengine"
nginxconf="$nginxpath/conf/nginx.conf"
alonehost="web1_host"
productionhost="web2_host"
md5file="/home/goujia/md5"

#================================function=====================
#ssh login
function ssh_to_host(){
  ssh $1 "$2"
}

function for_each_allhost(){
  for i in ${allhost[@]}
  do
          ssh $i "$1"
  done
}

function if_grep_else(){
  if grep "$1" $nginxconf
  then
          :
  else
          echo "the String $1 dosn't exist in the $nginxconf"
          exit 1;
  fi
}

function decide_failure_or_success(){
  if [ X$1 == X0 ]
  then
          :
  else
          $2
          exit 1;
  fi
}

function modify_nginx_conf(){
  #遍历集群，更改配置文件
  for_each_allhost "sed -i s/$productionhost/$alonehost/g $nginxconf"
  scp $decidenginxconfhost:$nginxconf /tmp/$decidenginxconfhost.nginx.conf
  #检测重启本机nginx
  sudo $nginxpath/sbin/nginx -t
  decide_failure_or_success $? "echo '$nginxpath/sbin/nginx -s reload'"
  sudo $nginxpath/sbin/nginx -s reload
  #比对远程nginx文件与本机的是否一致及是否包含被更改的内容
  #diff /tmp/$decidenginxconfhost.nginx.conf $nginxconf
  decide_failure_or_success $? "echo 'diff nginx conf'"
  if_grep_else $alonehost
  #重启集群中的所有nginx，移除待部署机器
  #for_each_allhost "sudo $nginxpath/sbin/nginx -s reload"
  #处理临时配置文件
  mv /tmp/$decidenginxconfhost.nginx.conf /tmp/`date +%Y%d%m%d%S`.nginx.conf
  find /tmp/ -name "*.nginx.conf" -type f -mtime +5|xargs rm -rf
}

function md5_decide(){
  premd5=`md5sum $tarfile |awk '{print $1}'`
  oldmd5=`cat $md5file`
  if [ X$premd5 == X$oldmd5 ]
  then
          :
  else
          echo "the project tarfile md5 different."
          exit 1;
  fi
}

function main_pre(){
  #比对md5值
  md5_decide

  #配置nginx集群，移除待部署集群
  modify_nginx_conf
}

#===================begin project publishing===================
projectpath="/home/goujia/project/web/www"
publishshell="new.sh"

function project_publish(){
  logname=`date +%Y%m%d%H%M%S`
  source /etc/profile
  ssh_to_host $prehost "source $projectpath/$publishshell > /tmp/log 2>&1"
  
  scp $prehost:/tmp/log /tmp/"$logname".log
  sleep 5
  tail -n 100 /tmp/"$logname".log
  echo "success!"
}

function last_version(){
  lastversion=`ls -al $projectpath/deploy |awk '{print $NF}'`
  echo $lastversion > /home/goujia/.lastversion
}

function current_version(){
  currentversion=`date +%Y%m%d%H%M%S`
  echo $currentversion > /home/goujia/.currentversion
  mkdir $projectpath/$currentversion
  tar -zxvf $tarfile -C $projectpath/$currentversion
  rm -rf $projectpath/deploy
  ln -s $projectpath/$currentversion $projectpath/deploy
}

function main_project(){
  #记录上一个版本号
  last_version
  #创建新版本目录，并解压压缩包到新目录
  current_version
  #执行部署脚本
  project_publish
}


main_pre
main_project

set +x
