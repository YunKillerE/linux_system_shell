#!/bin/sh
#****************************************************************#
# ScriptName: spilt.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-05-20 18:59
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-20 19:53
# Function: 
#***************************************************************#
for i in `cat $1`
do
#	echo ${i:0:2}:${i:2:2}:${i:4:2}:${i:6:2}:${i:8:2}:${i:10:2}:${i:12:2}:${i:14:2}
	echo $i | sed 's/./&:/2;s/./&:/5;s/./&:/8;s/./&:/11;s/./&:/14;s/./&:/17;s/./&:/20'
done


