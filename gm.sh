#!/bin/bash
#
# Function: publish for single app server
# Usage: execmd <hostname> <CMD># eg. execmd listhost detailhost forumhost 'netstat -ant |wc -l'
auto_ssh_copy_id(){
	expect -c "set timeout 60;
    	spawn ssh-copy-id $1;
  		expect *assword:*;
		send -- $1\r;
		interact;";
}
#auto_ssh_copy_id 192.168.218.199

auto_login_ssh(){
	expect -c "set timeout 60;
		spawn -noecho ssh -o StrictHostKeyChecking=no $2 ${@:3};
		expect *assword:*;
		send -- $1\r;
		interact;";
}
#auto_login_ssh root 192.168.218.199 "ls /root && ls /var"

checkstr()
{
        if [ -z `echo ${array[i]} | awk -F"-" '/-/{print $1}'` ];then
                eval host="${array[i]}"
                DESTHOSTS=`/root/bin/gethost.sh $host`
                SERVERS=`echo $DESTHOSTS`
        else
                host_start=`echo ${array[i]} | awk -F"-" '/-/{print $1}' | sed 's/[a-z]//g'`
                host_end=`echo ${array[i]} | awk -F"-" '/-/{print $2}'`
                if [ -z `echo $host_start | grep "^0"` ];then
                        for x in `seq $host_start $host_end`
                        do
                                host="$host `echo ${array[i]} | awk -F"-" '/-/{print $1}' | sed 's/[0-9]//g'`$x"
                        done
                else
                        for x in `seq $host_start $host_end`
                        do
                                if [ $x -lt 99 ];then
                                        host="$host `echo ${array[i]} | awk -F"-" '/-/{print $1}' | sed 's/[0-9]//g'`0$x"
                                else
                                        host="$host `echo ${array[i]} | awk -F"-" '/-/{print $1}' | sed 's/[0-9]//g'`$x"
                                fi
                        done
                fi
                SERVERS=`echo $host`
        fi
}

###############################################################################################################

if [ $# -lt 2 ]; then
    echo "Usage: $0 hostname1 hostname2 ... hostname_n 'command'";
    exit 1;
else
    num=$(($#-1))
    array=($@)
    eval cmd="\$$#"
    i=0
    while [ $i -lt $num ]
    do
        checkstr
        echo -e "\033[31;1m=========================== ${array[$i]} start ===========================\033[0m"; 
        echo
        for DEST_HOST in $SERVERS ; do
            echo -e "\033[32;1m=========================== $DEST_HOST ===========================\033[0m";
 #           ssh -o ConnectTimeout=5 $DEST_HOST $cmd
 			 PW="r00tadmin"
 			 auto_login_ssh $PW $DEST_HOST $cmd
            echo
        done
        echo -e "\033[31;1m=========================== ${array[$i]} end ===========================\033[0m";
        echo
        i=$((i+1))
        unset host
        unset SERVERS
    done
    echo "=== All done!!! ==="
fi
