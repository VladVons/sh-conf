#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="mongodb"

cPkgName="$cApp"

cProcess="$cApp"
cService="$gDirD/$cProcess"
cPort="27017"
cLog1="/var/log/$cApp/$cApp.log"

