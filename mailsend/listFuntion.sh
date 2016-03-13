#!/bin/bash
#****************************************************************#
# ScriptName: listFuntion.sh
# Author: 云尘(jimmy)
# Create Date: 2015-11-26 15:52
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-11-26 15:52
# Function: 
#***************************************************************#
path=`pwd`
function send_mail() {
echo  "BEGIN:VCARD
VERSION:3.0
N:;$1;;;
FN:$1
EMAIL;TYPE=INTERNET;TYPE=WORK:$3
CATEGORIES:$2
END:VCARD" >> out.txt
#echo "the VPN username is : $user the VPN password is : $pass" | mail -s "stc" ljm@goujiawang.com
}
for i in `cat $path/list`
do
	u2p=(`sed -n "1p" $path/list`)
	name=${u2p[0]}
	group=${u2p[1]}
	mail=${u2p[2]}
	send_mail $name $group $mail
	sed -i "1 d" $path/list
done


