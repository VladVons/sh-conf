#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="avahi-daemon"

cPkgName="$cApp"
cPkgDepends="libnss-mdns avahi-utils"
#
cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="5353"
cLog1=$gFileSysLog
