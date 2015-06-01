#!/bin/bash
#****************************************************************#
# ScriptName: function.sh
# Author: $liujmsunits@hotmail.com
# Create Date: 2015-05-06 22:15
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-06-02 19:33
# Function: 
#***************************************************************#
pass="roottoor"
auto_ssh_copy_id(){
	expect -c "set timeout 10;
    	spawn ssh-copy-id $1;
  		expect *assword:*;
		send -- $pass\r;
		interact;";
}
#for i in `cat $1`
#do
#	auto_ssh_copy_id $i
#done


auto_login_ssh(){
	expect -c "set timeout -1;
		spawn -noecho ssh -o StrictHostKeyChecking=no $2 ${@:3};
		expect *assword:*;
		send -- $pass\r;
		interact;";
}
#auto_login_ssh client "ifconfig eth0 && cat /root/.ssh/id_rsa"


auto_ssh_copy_id () {
	    expect -c "set timeout -1;
	     spawn ssh-copy-id $1;
    	      expect {
   				*(yes/no)* {send -- yes\r;exp_continue;}
      			*assword:* {send -- $pass\r;exp_continue;}
           		eof        {exit 0;}
         		}";
}
for i in `cat $1`
do
	auto_ssh_copy_id $i																												
done



																												
