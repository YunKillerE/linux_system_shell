#!/bin/sh
#****************************************************************#
# ScriptName: uniq2host.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-05-24 12:30
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-24 12:56
# Function: 
#***************************************************************#
cat zone2name |grep pc |awk '{print $3}' |sort |uniq |sed "s/..$//g" |uniq >host
sed -i "s/-/_/g" zone2name host
