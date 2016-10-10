#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="apcupsd"

cPkgName="$cApp"
cPkgAlso="apcupsd-cgi"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="3551"
cLog1=$gFileSysLog

