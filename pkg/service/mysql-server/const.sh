#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="mysql-server"

cPkgName="$cApp"
cPkgAlso="mytop phpmyadmin"

cProcess="mysql"
cService="$gDirD/$cProcess"
cPort="3306"
cLog1="$gFileSysLog"

gLocation="/var/lib/$cProcess"
