#!/bin/bash
#****************************************************************#
# ScriptName: create_branch.sh
# Author: 云尘(jimmy)
# Create Date: 2015-10-25 18:15
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-10-25 18:15
# Function: 
#***************************************************************#
#当前脚本用法
function msg(){
    cat << EOF
Usage: $0 sourcebranch newbranch1 [newbranch2 newbranch3 ....]
sourcebranch 基于哪个分支创建
newbranch1   新分支名称，需要创建几个就跟几个参数
EOF
}

#判断输入参数是否符合要求，必须大于2，至少创建一个分支吧，要不然你执行这个脚本干嘛，吃饱了没事干啊
if [ $# -lt 2 ] 
then
	msg
	echo -e "\033[41;33;1m 至少提供两个参数，至少创建一个分支吧，要不然你执行这个脚本干嘛，吃饱了没事干啊  \033[0m"
	exit 1;
else
	:
fi

#判断当前分支是否有未提交内容，以便切换分支
function decide_git_status(){
    git_ignore_delete_cachefile
    statuscount=`git status -s |wc -l`
    if [ $statuscount == 0 ]
    then
	    :
    else
	    echo -e "\033[41;33;1m 当前分支存在未提交内容，请提交或者是git reset还原 \033[0m"
	    exit 1;
    fi
}

function swap(){
    temp=$1
    $1=$2
    $2=$temp
}

#判断数组中是否有相同元素
function decide_array_same(){
    for ((i=0;i<=${#array_branch[@]};i++))
    do
	    for ((j="i+1";j<=${#array_branch[@]};j++))
	    do
		    #echo "${array_branch[$i]} ${array_branch[$j]}"
		    if [ X"${array_branch[$i]}" = X"${array_branch[$j]}" ]
		    then
			    echo -e "\033[41;33;1m 提供了相同的分支名称，无法创建，你是猪吗？ \033[0m"
			    exit 1;
		    else
			    :
		    fi
	    done
    done
    
}

#判断字符串是否为空 ddd
function decide_string_is_empty(){
    if [ -z $1 ]
    then
	    :
    else
	    $1
    fi
}

#判断上一个命令是否执行成功
function success_or_fail(){
    if [ $? == 0 ]
    then
	    :
    else
            echo -e "\033[41;33;1m$1\033[m"
	    echo ""
	    decide_string_is_empty $2
	    decide_string_is_empty $3
	    exit 1;
    fi
}

#判断当前是否在$1分支,如果不在，则切换过去
function decide_which_branch(){
    current_branch=$(git branch |grep ^* |awk '{print $NF}')
    #echo $current_branch
    if [ X"$current_branch"  == X"$1" ]
    then
	    decide_git_status
            echo -e "\033[41;33;1m开始更新当前分支到最新状态................................\033[m"
	    git pull origin $1
	    echo ""
	    success_or_fail "更新分支失败，请检查原因"
    else
            echo -e "\033[41;33;1m确定当前分支是否有未提交的内容..............................\033[m"
	    echo ""
	    decide_git_status
            echo -e "\033[41;33;1m切换到指定分支..............................................\033[m"
	    echo ""
	    git checkout $1
	    success_or_fail "切换分支失败，请检查原因"
    fi
}

#判断当前是否在git根目录以及git的配置是否正常
function decide_git_config(){
    userconfig=$(git config --list  |egrep "user.name|user.email" |wc -l)
    if [ X"$userconfig" == X2 ]
    then
	    :
    else
	    echo -e "\033[41;33;1m 你是猪吗？user.name和user.email都不配置，你提交代码后谁知道你是谁啊  \033[0m"
	    echo "配置方法如下："
	    echo ""
	    echo "    git config --global user.name 'Your Name Comes Here'  "
	    echo "    git config --global user.email you@yourdomain.example.com"
	    echo ""
	    exit 1;
    fi
    
    if [ -d ".git" ]
    then
	    :
    else
	    echo -e "\033[41;33;1m 当前都不是git根目录，创建毛线的分支啊，切换到git根目录执行本脚本，听话啊，操作规范点，不然女的不然打屁股，男的跳楼去  \033[0m"
	    exit 1;
    fi
	
    if [ -d ".git" -a -e ".git/config" -a -s ".git/config" ] 
    then
	    :
    else
	    echo -e "\033[41;33;1m .git/config文件都不存在或者被清空了，怎么更新分支啊？怎么提交？手动输入仓库地址吗？累不累啊？  \033[0m"
	    echo "也就是说当前代码目录git配置有问题，重新克隆仓库代码就好了，看我多聪明，哈哈哈哈哈哈哈"
	    exit 1;
    fi
}

#遍历数组创建分支
function create_and_push_branch(){
    echo -e "\033[41;33;1m基于分支: [${array_branch[0]}] 创建新分支：[${array_branch[@]:1:100}]\033[0m"
    echo ""
    yes_or_no
    echo ""
    echo -e "\033[41;33;1m开始创建分支..............................................\033[m"
    echo ""
    for ((i=1;i<${#array_branch[@]};i++))
    do
	    #echo ${array_branch[i]}
    	    git branch ${array_branch[i]}
	    success_or_fail "分支创建失败，请检查原因"
	    echo -e "\033[41;33;1m${array_branch[i]}分支创建成功........................................\033[m"
	    echo ""
	    echo -e "\033[41;33;1m${array_branch[i]}开始提交分支........................................\033[m"
	    git push origin ${array_branch[i]}
	    echo ""
	    success_or_fail "分支提交失败，请查看原因" "echo -e '\033[41;33;1m 开始删除未提交的分支....................\033[m'" "git branch -d ${array_branch[i]}"
	    echo -e "\033[41;33;1m${array_branch[i]}分支提交成功........................................\033[m"
	    echo ""
    done
    echo -e "\033[41;34;1m恭喜恭喜！成功创建并提交如下分支：
==================================================================================================================================
${array_branch[@]:1:100}
==================================================================================================================================\033[m"
    echo ""
}

#显示当前分支情况
function print_branch_detail(){
    echo -e "\033[41;33;1m$1........................................\033[m"
    echo ""
    array_b=(`git branch  | awk '{print $NF}'`)
    #echo -e "\033[41;33;1m${array_b[*]}\033[m"
    echo -e "${array_b[*]}"
    echo ""
}

#忽略本脚本及.gitignore
function git_ignore_delete_cachefile(){
    echo -e "\033[41;33;1m开始创建忽略提交的文件....................................\033[m"
    echo ""
    spath=`pwd`
    echo "$0" > $spath/.gitignore
    echo ".gitignore" >> $spath/.gitignore
    rm -rf $spath/*~
    rm -rf $spath/.*~
}

#判断输入的分支是否已经存在,待写，思路是比较两个数组元素，将相同的元素打印出来,嵌套循环
function decide_input_branch_is_exist(){
    unset array_b
    array_b=(`git branch -a |awk '{print $NF}' | awk -F'/' '{print $NF}' |sort -n |uniq`)
    num=0
    resoult_b=()
    for ((i=1;i<${#array_branch[@]};i++))
    do
        #num=0
	#resoult_b=()
	for ((j=0;j<${#array_b[@]};j++))
	do
		if [ X${array_branch[$i]} == X${array_b[$j]} ]
		then
			resoult_b[$num]=${array_branch[$i]}
			echo ${resoult_b[$num]}
			let num=$num+1
		else
			:
		fi
	done
    done
    if [ X${#resoult_b[@]} == X0 ]
    then
	    :
    else
    	    echo -e "\033[41;33;1m如下分支名称：${resoult_b[*]} 已存在,请重新确定分支名，或者删除已存在的分支\033[m"
	    exit 1;
    fi
}

#更新当前主机时间
function update_time(){
    echo -e "\033[41;33;1m开始更新系统时间..........................................\033[m"
    ntpdate 0.centos.pool.ntp.org
    echo ""
    success_or_fail "网络连接不成功，请查看网络情况，或者联系云尘"
}

function y_or_n(){
    if [ X$1 == XY -o X$1 == Xy -o X$1 == Xyes ]
    then
	    :
    elif [ X$1 == XN -o X$1 == Xn -o X$1 == Xno ]
    then
	    exit 1;
    else
	    echo "输入有误，请重新执行，输入y/n"
	    exit 1;
    fi
}

#是否继续执行脚本
function yes_or_no(){
    echo ${array_branch[*]}
    echo ""
    #echo -n "是否继续（Y/N）："
    read -p "是否继续（Y/N）：" yy
    y_or_n $yy
}

#遍历数组,从角标1开始
function array_list_all(){
    count=${#array_branch[@]}
    for ((i=1;i<$count;i++))
    do
	    echo -ne ${$1[i]}
    done
}

#脚本执行入口
function main(){
    #更新当前主机的时间
    update_time
    #判断数组中是否有相同元素
    decide_array_same
    #判断输入的分支名称是否已经存在
    decide_input_branch_is_exist
    #判断当前是否在根代码目录以及git的配置是否有问题
    decide_git_config
    #创建之前判断当前是否在指定的基于分支上，也就是${array_branch[0]}
    decide_which_branch ${array_branch[0]}
    #输出当前分支情况
    print_branch_detail "创建之前的分支情况"
    #开始创建分支
    create_and_push_branch
    #输出创建之后的分支情况
    print_branch_detail "创建之后的分支情况"
}

#获取所有输入的参数赋值给数组array_branch
array_branch=($*)
#执行main函数
main

#echo -e "\033[41;33;1m   \033[m"
