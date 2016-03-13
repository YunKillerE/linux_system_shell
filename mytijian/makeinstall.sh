#!/bin/sh
mpath="/opt/mediator/public/configfile/hospital"
tmppath="/opt/mediator/shell"

MakeInstallSh() {
source $mpath/$1/configwget.sh
cp -rf $tmppath/install.sh $tmppath/install.sh.tmp 
sed -i "s/base_mediator_agent/$base_mediator_agent/g" $tmppath/install.sh.tmp
sed -i "s/mediator_probe/$mediator_probe/g" $tmppath/install.sh.tmp
sed -i "s/english_hospital_name/$english_hospital_name/g" $tmppath/install.sh.tmp
sed -i "s/mapport/$mapport/g" $tmppath/install.sh.tmp
sed -i "s/base_control_agent/$base_control_agent/g" $tmppath/install.sh.tmp
cp -rf $tmppath/install.sh.tmp $mpath/$1/install.sh
rm -rf $tmppath/install.sh.tmp
}
#if [ -f $mpath/$1/configwget.sh ];then
#	echo "pls ensure exist the file $mpath/$1/configwget.sh"
#	exit 1;
#fi

if [ $# != 1 ];then
	echo "pls input an args of hospital_name"
	exit 1
elif [ ! -f $mpath/$1/configwget.sh ];then
	echo "pls ensure exist the file $mpath/$1/configwget.sh"
	exit 1;
else
	MakeInstallSh $1
fi
