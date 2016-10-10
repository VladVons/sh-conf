#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="nut"

cPkgName="$cApp"
cPkgAlso="nut-cgi setserial"

cProcess="$cApp"
cService="$gDirD/$cApp-server"
cPort="3493"
cLog1="$gFileSysLog"

Man="ups.conf,upsd.conf,upsmon.conf,blazer_ser"
