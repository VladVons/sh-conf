#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="isc-dhcp-server"

cPkgName="$cApp"
cProcess="dhcpd"
cService="$gDirD/$cApp"
cLog1=$gFileSysLog
