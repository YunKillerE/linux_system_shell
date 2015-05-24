#!/bin/sh
#****************************************************************#
# ScriptName: createzone.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-05-24 06:17
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-24 12:53
# Function: 
#***************************************************************#
function diff(){
	if [ $1 = $2 ]
	then
		return 0
	else
		return 1
	fi
}

function countnum(){
#	numarray=${#domainid[@]}
	if [ $numarray = 4  ];then
		eval "var1=\${$1[0]}"
		eval "var2=\${$1[1]}"
		eval "var3=\${$1[2]}"
		eval "var4=\${$1[3]}"
	elif [ $numarray = 6 ];then
		eval "var1=\${$1[0]}"
		eval "var2=\${$1[1]}"
		eval "var3=\${$1[2]}"
		eval "var4=\${$1[3]}"
		eval "var5=\${$1[5]}"
		eval "var6=\${$1[6]}"
	elif [ $numarray = 8 ];then
		eval "var1=\${$1[0]}"
		eval "var2=\${$1[1]}"
		eval "var3=\${$1[2]}"
		eval "var4=\${$1[3]}"
		eval "var5=\${$1[5]}"
		eval "var6=\${$1[6]}"
		eval "var7=\${$1[7]}"
		eval "var8=\${$1[8]}"
	else
		echo "pls check the zone2name"
	fi


}

function zonecreate(){
if [ $1 = singlehost ]
then
	echo -ne "\033[31;1m==============================${hostname[0]} start======================================\033[0m"
	echo "
zonecreate \"$zonename1\",\"${dm2id1[0]}${dm2id1[1]}${dm2id1[2]}${dm2id1[3]}${dm2id1[4]}${dm2id1[5]}\"
cfgadd \"$cfgname1\",\"$zonename1\"
cfgenable \"$cfgname1\""
	echo "
zonecreate \"$zonename2\",\"${dm2id2[0]}${dm2id2[1]}${dm2id2[2]}${dm2id2[3]}${dm2id2[4]}${dm2id2[5]}\"
cfgadd \"$cfgname2\",\"$zonename2\"
cfgenable \"$cfgname2\""
	echo -e "\033[31;1m==============================${hostname[0]}   end======================================\033[0m"
elif [ $1 = mutiplehost ]
then
	echo "


	"
else
	echo "pls use zonecreate singlehost/mutiplehost"
fi
}

function array(){
	#Array
	domainid=(`cat zone2name |grep $1 |awk '{print $1}'`)
	cfgname=(`cat zone2name |grep $1 |awk '{print $2}'`)
	hostname=(`cat zone2name |grep $1 |awk '{print $3}'`)
	sunname=(`cat zone2name |grep $1 |awk '{print $4}'`)
	index=(`cat zone2name |grep $1 |awk '{print $5}'`)
}

function variable(){
	#variable
	zonename1="${hostname[0]}$hname1$hname2"_"${sunname[1]}"
	zonename2="${hostname[3]}$hname1$hname2"_"${sunname[3]}"
	dm2id1=("${domainid[0]},${index[0]}" "${domainid[1]},${index[1]}")
	dm2id2=("${domainid[2]},${index[2]}" "${domainid[3]},${index[3]}")
	cfgname1=${cfgname[0]}
	cfgname2=${cfgname[3]}
}

for i in `cat host`
do
	array $i
	numarray=${#hostname[@]}
if [ $numarray = 4 ];then
	#variable
	zonename1="${hostname[0]}"_"${sunname[0]}"
	zonename2="${hostname[2]}"_"${sunname[2]}"
	dm2id1=("${domainid[0]},${index[0]};" "${domainid[1]},${index[1]}")
	dm2id2=("${domainid[2]},${index[2]};" "${domainid[3]},${index[3]}")
	#add variable to array
#	numarray=${#dm2id1[@]}
#	echo $numarray
#	num=$[numarray-1]
#	echo $num
#	dm2id1[$num]=${dm2id1[$num]}""
#	dm2id1[$numarray]="88,89"
#	echo ${dm2id1[*]}
	cfgname1=${cfgname[0]}
	cfgname2=${cfgname[2]}
	#zonecreate
	zonecreate singlehost
elif [ $numarray = 12 ];then
	#variable
	hname1=`echo ${hostname[0]} |grep -o ".$"`
	hname2=`echo ${hostname[1]} |grep -o ".$"`
	hname3=`echo ${hostname[2]} |grep -o ".$"`
	name=`echo ${hostname[0]} | sed "s/..$//g"`
	zonename1="$name$hname1$hname2$hname3"_"${sunname[0]}"
	zonename2="$name$hname1$hname2$hname3"_"${sunname[5]}"
	dm2id1=("${domainid[0]},${index[0]};" "${domainid[1]},${index[1]};" "${domainid[2]},${index[2]};" "${domainid[3]},${index[3]};" "${domainid[4]},${index[4]};" "${domainid[5]},${index[5]}")
	dm2id2=("${domainid[6]},${index[6]};" "${domainid[7]},${index[7]};" "${domainid[8]},${index[8]};" "${domainid[9]},${index[9]};" "${domainid[10]},${index[10]};" "${domainid[11]},${index[11]}")
	cfgname1=${cfgname[0]}
	cfgname2=${cfgname[5]}
	zonecreate singlehost
elif [ $numarray = 8 ];then
	#variable
	hname1=`echo ${hostname[0]} |grep -o "..$"`
	hname2=`echo ${hostname[1]} |grep -o "..$"`
	name=`echo ${hostname[0]} |sed "s/..$//g"`
	zonename1="$name$hname1$hname2"_"${sunname[0]}"
	zonename2="$name$hname1$hname2"_"${sunname[4]}"
	dm2id1=("${domainid[0]},${index[0]};" "${domainid[1]},${index[1]};" "${domainid[2]},${index[2]};" "${domainid[3]},${index[3]}")
	dm2id2=("${domainid[4]},${index[4]};" "${domainid[5]},${index[5]};" "${domainid[6]},${index[6]};" "${domainid[7]},${index[7]}")
	cfgname1=${cfgname[0]}
	cfgname2=${cfgname[4]}
	zonecreate singlehost
else
	echo "pls check zone2name."

fi
done
