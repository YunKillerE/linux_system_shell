#!/bin/bash
#****************************************************************#
# ScriptName: mail.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-06-13 03:24
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-06-28 10:58
# Function: auto mail vpn pass to user
#***************************************************************#
path=`pwd`
function send_mail() {
echo  "
		the VPN username is : $user

		the VPN password is : $pass

		请妥善保管账号密码！VPN服务器地址：x.x.x.x

		关于VPN的详细使用见QQ群中的：VPN及SSH跳板使用手册v1.docx

		此邮件为系统发送，如有问题请联系面包或云尘！
	 " | mail -s "您的构家网VPN拨号账号已开通" $1
#echo "the VPN username is : $user the VPN password is : $pass" | mail -s "stc" ljm@goujiawang.com
}
for i in `cat $path/em.list`
do
#	u2p=(`sed -n "1p" $path/u2p.list`)
#	user=${u2p[0]}
#	pass=${u2p[1]}
	user=goujia_`sed -n "1p" em.list |cut -d'@' -f1`
	pass=`openssl rand -base64 5`
	send_mail $i
	vpnuser add $user $pass
#	echo "$user	 *	$pass	 *" >>/etc/ppp/chap-secrets
#	sed -i "1d" $path/u2p.list
#	sed -i "1d" $path/em.list
	sed -i "1 d" $path/em.list
done
