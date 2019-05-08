#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="exim4"

cPkgName="$cApp"
cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="25"
cLog1="/var/log/$cApp/mainlog"
