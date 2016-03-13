#!/bin/bash
#****************************************************************#
# ScriptName: wikijenkins.sh
# Author: 云尘(jimmy)
# Create Date: 2015-12-21 14:18
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-12-21 14:18
# Function: 
#***************************************************************#
rootpath="/opt/www/wiki/data/pages"

Create_Area() {
  #$1：地区英文名称 $2：地区中文名称
  cd $rootpath
  sudo  cp -r 1template $1
  sudo echo "[[$1:index|$2]\\" >> businesslink/index.txt
}

Create_Hospital() {
  #$1：医院英文名称 $2：医院中文名称 $3：地区中文名称
  cd $rootpath
  sudo cp -r 2template $1
  echo "[[$1:index|$2]\\" >>  $3/index.txt
}

if [ X$1 = Xarea ];then
        Create_Area $2 $3
elif [ X$1 = Xhospital ]
        Create_Hospital $2 $3 $4
else
        echo "you input args error!!!"
fi
