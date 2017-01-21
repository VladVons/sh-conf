#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="epoptes-client"

cPkgName="$cApp"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="789"
cLog1="/var/log/$cApp/error.log"
