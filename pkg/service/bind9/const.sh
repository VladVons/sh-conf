#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="bind9"

cPkgName="$cApp"
cProcess="named"
cPort="53"
cService="$gDirD/$cApp"
cLog1=$gFileSysLog
cLog3="/var/log/$Process/$Process.log"

DirEtc="$gDirEtc/bind"
DirDyn="$DirEtc/dyn"
