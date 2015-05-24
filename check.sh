#!/bin/bash
#****************************************************************#
# ScriptName: check.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-5-20
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-20 19:51
# Function: 
#***************************************************************#

if [ $# -lt 2 ]; then
    echo "Usage: $0 hostname 'command1 && command2 .... '";
    exit 1;
else
	for i in `cat $1`
    do
   #     echo
        for DEST_HOST in $i ; do
            echo -e "\033[32;1m=========================== $DEST_HOST ===========================\033[0m";
             ssh -o ConnectTimeout=5 $DEST_HOST $2
# 			 PW="r00tadmin"
# 			 auto_login_ssh $PW $DEST_HOST $cmd
        done
    done
fi
