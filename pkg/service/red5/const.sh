#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="red5-server"

cPkgName="$cApp"
cPkgDepends="libtomcat6-java ant"
cProcess="$cApp"
cPort="1935|1936|5080|8088"
cService="$gDirD/$cApp"
cLog1=$gFileSysLog
