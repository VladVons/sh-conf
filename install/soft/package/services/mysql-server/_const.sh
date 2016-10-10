#!/bin/bash

. $DIR_ADMIN/conf/Const.sh

Program="mysql-server"

Package="$Program mytop mydumper"
Process="mysql"
Service="$gDirD/mysql"
Port="3306"
Log1="$gFileSysLog"
gAuth="--user=$gMySQLUser --password=$gMySQLPassw"
gLocation="/var/lib/mysql"
