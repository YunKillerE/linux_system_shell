#!/usr/bin/expect -f
#****************************************************************#
# ScriptName: autossh.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-05-11 08:22
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-11 08:30
# Function: 
#***************************************************************#
set ip [lindex $argv 1]
set password [lindex $argv 0]
set timeout 20
spawn ssh root@$ip
expect {
"*yes/no" { send "yse\r"; exp_continue }
"*assword:" {send "$password\r" }
}
interact
#autossh.sh password ip

