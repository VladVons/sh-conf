#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="avahi-daemon"

cPkgName="$cApp"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="5353"
cLog1=$gFileSysLog
