#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="php"

cPkgName="$cApp"
cPkgAlso="libapache2-mod-php $cApp-mysql $cApp-mcrypt $cApp-gd $cApp-geoip $cApp-dev $cApp-curl php-pear php-apc"
cPkgAlso2="$cApp-imap php-getid3"

cProcess="apache2"
cPort="80|443"
cService="$gDirD/apache2"
cLog1="$gFileSysLog"
