#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="ntp"

cPkgName="$cApp"
cPkgAlso="ntpdate"

cProcess="ntpd"
cService="$gDirD/$cApp"
cPort="123"
cLog1="$gFileSysLog"
