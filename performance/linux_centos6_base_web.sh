#!/bin/bash
#****************************************************************#
# ScriptName: linux_centos6_base.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-07-13 11:38
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-07-13 15:38
# Function:web系统基础优化 
#***************************************************************#
set -x
function deterpm()
{
	rpm -qa |grep $1
}

function Decide()
{
	if [ $1 = 0 ];then
		:
	else
		$2
	fi
}

function ntpconfig()
{
	/etc/init.d/ntpd stop
	/usr/sbin/ntpdate ntp.api.bz > /dev/null 2>&1
	/etc/init.d/ntpd start
	echo "*/5 * * * * /usr/sbin/ntpdate ntp.api.bz > /dev/null 2>&1" >> /var/spool/cron/root
}
#source
wget -c http://mirrors.163.com/.help/CentOS6-Base-163.repo -O /etc/yum.repos.d/CentOS6-Base-163.repo
yum clean metadata
nohup yum makecache &

#ntp
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc --localtime

deterpm ntp
Decide $? "yum install ntp -y"

ntpconfig

#sysctl.conf
function sysctlconfig()
{
cat >> /etc/sysctl.conf <<EOF
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.core.netdev_max_backlog=20000
net.core.somaxconn = 2048
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
#the web behand lvs
#net.ipv4.conf.all.arp_ignore = 1
#net.ipv4.conf.all.arp_announce = 2
#net.ipv4.conf.bond0.arp_ignore = 1
#net.ipv4.conf.bond0.arp_announce = 2
EOF
}
#mem=`cat /proc/meminfo |grep MemTotal |awk '{print $2}'`
#shmax=`expr 1024 \* $mem`
#shmall=`expr $shmax / 4096`
#echo $shmax
#echo $shmall
sysctlconfig

#stop ipv6
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
/sbin/chkconfig ip6tables off

#open file limits.conf
echo "* soft nofile 65535
* hard nofile 65535
* soft nproc 65535
* hard nproc 65535" >> /etc/security/limits.conf

set +x
