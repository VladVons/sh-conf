#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="salesplatform"
# http://community.salesplatform.ru/documentation/

cPkgName="$cApp"
cPkgAlso="$cApp-mysql $cApp-mcrypt $cApp-gd $cApp-geoip $cApp-curl $cApp-dev php-pear php-apc"
cPkgAlso2="php5-imap"

cProcess="apache2"
cPort="80|443"
cService="$gDirD/apache2"
cLog1="$gFileSysLog"
