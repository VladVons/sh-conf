#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="nginx"
cPkgName="$cApp"
#
cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="80|443"
cLog1="/var/log/$cApp/error.log"
