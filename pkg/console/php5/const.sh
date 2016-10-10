#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="php5"

cPkgName="$cApp"
cPkgAlso="$cApp-mysql $cApp-mcrypt $cApp-gd $cApp-geoip $cApp-curl $cApp-dev php-pear php-apc"
cPkgAlso2="php5-imap php-getid3"

cProcess="apache2"
cPort="80|443"
cService="$gDirD/apache2"
cLog1="$gFileSysLog"
