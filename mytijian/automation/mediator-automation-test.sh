#!/bin/bash
#****************************************************************#
# ScriptName: mediator-automation-test.sh
# Create Date: 2016-03-10 09:37
# Function:mediator-ws/agent/order/single item/company test
# 1.place an order by sql,test synchronization results
# 2,single item sync...
# 3,company sync...
# 4,create medical report by sql,and test synchronization results
#***************************************************************#
spwd=`pwd`
#load variable file
source $spwd/config.ini

#env check
#当前脚本用法
function msg(){
    cat << EOF
    Usage: $0 ........
    EOF
}

echo -e "\033[41;33;1m  \033[0m"

function decide(){
    if [ X$? = X0 ];then
            :
    else
            $1
    fi
}

function runsql(){
    mysql -u$mysql_user -p$mysql_passwd -h $mysql_address -e "$1"
}

#执行生成订单sql
#mysql connection check
runsql "show database"
decide "echo -e '\033[41;33;1m mysql connection error!! \033[0m';exit 1"

function createorder(){
    ordersql=""
    select_ordersql=""
    runsql "$ordersql"
}

function check_mysql_order_result(){
    order_select_result=`runsql $select_ordersql`
    if [ X$order_select_result = X ];then
            :
    else
            echo -e "\033[41;33;1m createorder faild!! \033[0m"
            exit 1
    fi
}

#生成mongo订单
function runmongo(){
    echo "$1" |mongo $mongo_address:$mongo_port/$mongo_database --shell
}

function createmongoorder(){
    mongosql=""
    select_mongo_ordersql=""
    runmongo "$mongosql"
}

function check_mongo_order_result(){
    mongo_order_select_result=`runmongo $select_mongo_ordersql`
    if [ Xselect_mongo_ordersql = X ];then
            :
    else
            echo -e "\033[41;33;1m create mongo order failed!! \033[0m"
    fi
}

            











