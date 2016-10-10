#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="mysql-server"
cPkgDepends="mytop"
cDescr="MYSQL server"
cTag="service,db"

cProcess="mysql"
cService="$gDirD/mysql"
cPort="3306"
cLog1="$gFileSysLog"

gAuth="--user=$gMySQLUser --password=$gMySQLPassw"
gLocation="/var/lib/mysql"
