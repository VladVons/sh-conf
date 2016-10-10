#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="rsyslog"

cPkgName="$cApp"
cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="514"
cLog1=$gFileSysLog
