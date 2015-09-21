mkdir /etc/rsyncd
touch /etc/rsyncd/rsyncd.{conf,secrets,motd}

chmod 0600 /etc/rsyncd/rsyncd.secrets


echo "
pid file = /tmp/rsync.pid
port = 873
address = 120.26.122.216
uid = root
gid = root
use chroot = no
read only = no
write only = no
max connections = 5
log file = /tmp/rsyncd.log
transfer logging = yes
log format = %t %a %m %f %b
syslog facility = local3
timeout = 300
[html]
path=/home/goujia/project/html
list=yes
ignore errors
auth users = root
secrets file=/etc/rsyncd/rsyncd.secrets
comment = 116
exclude = log
[web]
path=/home/goujia/project/web
list=yes
ignore errors
auth users = root
secrets file=/etc/rsyncd/rsyncd.secrets
comment = 116
exclude = log
" >/etc/rsyncd/rsyncd.conf


