#!/usr/bin/python
# -*- coding: UTF-8 -*-
#****************************************************************#
# ScriptName: mysql.py
# Author: 云尘(jimmy)
# Create Date: 2016-03-16 17:48
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-03-22 01:02
# Function:
#***************************************************************#
import pymysql
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

class MYSQL:
    """
    对pymssql的简单封装
    使用该库时，需要在Sql Server Configuration Manager里面将TCP/IP协议开启
    用法：
    """
    def __init__(self,host,user,pwd,db):
        self.host = host
        self.user = user
        self.pwd = pwd
        self.db = db

    def __GetConnect(self):
        """
        得到连接信息
        返回: conn.cursor()
        """
        if not self.db:
            raise(NameError,"没有设置数据库信息")
        self.conn = pymysql.connect(host=self.host,user=self.user,password=self.pwd,database=self.db,charset="utf8")
        cur = self.conn.cursor()
        if not cur:
            raise(NameError,"连接数据库失败")
        else:
            return cur

    def ExecQuery(self,sql):
        """
        执行查询语句
        返回的是一个包含tuple的list，list的元素是记录行，tuple的元素是每行记录的字段
        调用示例：
                ms = MSSQL(host="localhost",user="sa",pwd="123456",db="PythonWeiboStatistics")
                resList = ms.ExecQuery("SELECT id,NickName FROM WeiBoUser")
                for (id,NickName) in resList:
                    print str(id),NickName
        """
        cur = self.__GetConnect()
        cur.execute(sql)
        resList = cur.fetchall()

        #查询完毕后必须关闭连接
        self.conn.close()
        return resList

    def ExecNonQuery(self,sql):
        """
        执行非查询语句
        调用示例：
            cur = self.__GetConnect()
            cur.execute(sql)
            self.conn.commit()
            self.conn.close()
        """
        cur = self.__GetConnect()
        cur.execute(sql)
        self.conn.commit()
        self.conn.close()

def main():

## ms = MSSQL(host="localhost",user="sa",pwd="123456",db="PythonWeiboStatistics")
## #返回的是一个包含tuple的list，list的元素是记录行，tuple的元素是每行记录的字段
## ms.ExecNonQuery("insert into WeiBoUser values('2','3')")

    ms = MYSQL(host="192.168.1.28",user="root",pwd="hadoop",db="sqoop")
    #f = open(sys.argv[1],'r')
    #print sys.argv[1]
    #mssql = f.read()
    mssql = sys.argv[1]
    if sys.argv[2] == 's':
    	resList = ms.ExecQuery(mssql)
    	#for (cc,) in resList:
        #     print cc
	#print resList[0]
	#print resList
	#print type(resList)
	s1 = resList[0]
	s2 = list(s1)
	print s2
	s3 = ' '.join(str(v) for v in s2)
	print s3
	#f = open('/root/tmp','w')
	
    elif sys.argv[2] == 'o':
        ms.ExecNonQuery(mssql)
    else:
        print 'argv[2] input error!! select orther'

if __name__ == '__main__':
    main()
