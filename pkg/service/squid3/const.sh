#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="squid3"

cPkgName="$cApp"
cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="3128"
cLog1="/var/log/$cApp/cache.log"
cLog2="/var/log/$cApp/access.log"
