path=`pwd`
for i in `cat $path/u2g.list`
do
  arr=( `sed -n "1p" $path/u2g.list` )
  id=${arr[0]}
  name=${arr[1]}
  groupadd -g $id $name
  useradd -d /home/$name -u $id -g $id -s /bin/bash -G sudo -f $name
  echo mytijian2015 | passwd --stdin $name
  mkdir /home/$name
  chown -R $name:$name /home/$name
  sed -i "1 d" $path/u2g.list
done
