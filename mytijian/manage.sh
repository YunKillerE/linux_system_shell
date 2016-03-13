#!/bin/bash
#****************************************************************#
# ScriptName: ssh.sh
# Function: 
#***************************************************************#
Decide() {
        if [ X$1 = X0 ];then
                :
        else
                wget http://spi.mytijian.com/linux/$2
                yum localinstall epel autossh
        fi
}
Install_Autossh(){
    if [ -f /etc/redhat-release ];then
            :
    else
            echo "this is not centos"
            exit 1
    fi

    ver=`cat /etc/redhat-release |grep -o '[0-9]' |head -1`
    
    which autossh
    if [ X$? = X1 ];then
	    if [ $ver -lt 6 ] ; then
        	    echo 5
            	rpm -ivh http://spi.mytijian.com/linux/autossh-1.4c-1.el5.rf.x86_64.rpm
            	Decide $? autossh-1.4c-1.el5.rf.x86_64.rpm
    	    else
            	echo 67
            	rpm -ivh http://spi.mytijian.com/linux/autossh-1.4c-2.el6.x86_64.rpm
            	Decide $? autossh-1.4c-2.el6.x86_64.rpm
    	    fi
    else
	:
    fi
}

Ssh_GenKey_Auto() {
   if [ -d /root/.ssh ];then
           chmod 700 /root/.ssh
   else
           mkdir /root/.ssh
           chmod 700 /root/.ssh
   fi
    echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEApJMrQHljB9hYQWafBJ+wzV4NmIHJvddndaSy7AniqfBwGiOK
adljx2RPsJlMRDNhRJ9ikpqgfohY7i5KzfW6zFvLNV7B+5hZOHt8QCjkr8WpYnCq
aaXPMxJ5MFRV7eW/CHt98R477Y9/e/NfTgnFut71PipkGGKcJrrNnIkiVEsCd/1v
aetBmeXwWLw0nGL93VnSEgMKt+anp9ktCu6mnhVGrRc1JfsblqkhCvnXz65TGy9p
iI2kt0+U58Z0FiX6G5JitN21v0E5j+mgDpVNBxH4A1SaDJfSEuDy+yy/f8vyNDwT
xwl99Wp4T5t4EQDNCZGYFn/ueUicGdLzqxt/lQIDAQABAoIBADmZTGT3VwKS5GiX
WwZKQZ3O0iFTI2Fu90XES96yowLpJMLxN4G0lOhfIkjjjj68YMmcouo+dfdzDvTl
fMbSvvrxEZDvRiMhMfDDvzvRVCB0pJDQb+AjuP3d9E5G5gAqDY8RcYWnGEBPncWq
6ussHmkFyX1lZrzmHlKrxHSJxlsLifNqc5T2/mrnw3/Djy4g6PjbSzHM+DYk4vM+
bm/Q/5cCtn25jyimaMdy+AxpRAWjOO8MiSyTVYUSTRJT6wYbbSFgCLZxO7mEK/5T
VnTmyaJWDLgCEK2segaG7sP1OUluE+K+BOINu/3BKjq4REd2yw+rfStRYKZQGOjT
M82hgY0CgYEA0D1sHgNLdn294iqDGjKHVNt9kltotyZmSh0pO33X1NGUHvrd1MzA
MZZZLZ2Y39f9nAIqfOpJ12u3VOX10HzDSwvt8OsajrjyFbSRSp7LNtMGJZStd8WV
epOPpFXiVvYG0TEAl4K6HvDTmYbZywVQGdN76BFvsASlltIPqr+oOhsCgYEAylIA
U8spZKcv5aYomL+YjEUxFUcxHIsYCtwL+Dj/THsDvpDXS3PrwWNNVWqpxFwxQuXA
Yc67Pvcye3z87Ain22rK3u/9Ru/PSPkHlhb3prE7Ryogb2n8ayyU32e3K2yiv+Fh
0QXQC8BZZUaO0LVFDrQ7PwRJiKVyWy0hpOZByA8CgYAS7MIaqCn/hsXu+/YWN2ld
KOVsm6oUmwTIz4WjxngK+1D+z8XBRSpiV0ubfasbDMIbn4bE+3XiggOTT6LbY7tL
4rWpI3Sya9R0bIiXw36saNkyKSTqsaY4EZkIUlXTmWBdOprXKiZIEZLpbPv2G3GA
J1wnZw5DbOivoD+UQP7E6QKBgBHSaV74PXw1Uf3LxjW2YuywR6OVMtlN019ZhOBn
vO1yxKCrx5tI6dKOOci1baDzcg9vh6PV/x6LzfGcz/bGyGqGnLpIr6npA/xsm2N4
QHZ5lDwvlM3bqzWRpseLLlJv7mIyq1grR+lRF07ZiUkPPrcN304sxYF4+XrYnecV
tWO3AoGBAKhS8VZaApuIDxBV+xbZRtgBg95K0fi7WjAyPWtBe2SinNtgzop4/SCr
IN9AYTGb5kHkh++BFur/Mhj06m51CQFHsDC+9ZemYHUTA+xAHQBDS25InCSyB+iD
GHqtnqZzjF0xBFnxQbpIhbXUcdMQVP4KACw/XJc2cJ2ja7vAcnwn
-----END RSA PRIVATE KEY-----" > /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa

    echo "spi.mytijian.com,121.40.87.210 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCX29Qo7wRQLo6nTggBnX7J9TSka4FfvDlazLKN/lxMEiVMAKkQq5j804165Mp664r01fgqG8egLrVbYBjAZDHVIJF46hh14oRaxjVKUt6+s7SInZ1JByEuqDAXwxHjK7JVkAomIrVu1Wxx41VpozKWiLwuNxNW6rMy/Ybs7ISEAy2zD6JdVKPtSgVE9RndmoJ71AMo3Nxzo88jOvR1l2gSpD6OcJZ1R6LuHAMNsi3AZ92vdZNTxIRSATIUXhgpgcZPftRKzaVn7NfD00ZyW/yvgCKxcMYMK49dNLJVglLl9NrFoECuU9XB6ZMy4TM9XYSkxEZo+lNemOhPjswGSkaF" > /root/.ssh/known_hosts
    chmod 600 /root/.ssh/known_hosts
}

Ssh_GenKey() {
        echo "按三下回车。。。。。"
        ssh-keygen
}

Ssh_Tunnel() {
        echo "输入密码。。。。。"
        ssh-copy-id ubuntu@spi.mytijian.com
        echo "输入yes"
        ssh ubuntu@spi.mytijian.com "ls"
        echo "ok!!!"
}

Ssh_Tunnel_Auto() {
        /usr/bin/autossh -M 30004 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R spi.mytijian.com:30003:localhost:22 ubuntu@spi.mytijian.com        
	if grep autossh /etc/rc.local;then
		:
	else
		echo '/usr/bin/autossh -M 30004 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R spi.mytijian.com:30003:localhost:22 ubuntu@spi.mytijian.com' >> /etc/rc.local
	fi
}

Check_Crontab() {
        ss=`ps aux |grep autossh |grep -v grep |awk '{print $NF}'`
        if [ X$? = X0 ];then
                :
        else
                Ssh_Tunnel
        fi
}

Crontab_Add() {
        spath=`pwd`
        cp  -rf $spath/ssh.sh /root/.ssh/
        if grep "ssh.sh" /var/spool/cron/root ;then
                  :
        else  
                  echo "*/1 * * * * /bin/bash /root/.ssh/ssh.sh check" >> /var/spool/cron/root
        fi
}

if [ X$1 = Xcheck ];then
        Ssh_Tunnel_Auto
else
        Install_Autossh
        Ssh_GenKey_Auto
        Ssh_Tunnel_Auto
        Crontab_Add
fi

