rm -rf /tmp/rsync*
nohup /usr/bin/rsync --daemon --config=/etc/rsyncd/rsyncd.conf
