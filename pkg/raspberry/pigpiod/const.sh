#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="pigpio"

cPkgName="$cApp"

cProcess="pigpiod"
cService="$gDirD/$cApp"
cPort="8888"
#cLog1="/var/log/$cApp/error.log"
