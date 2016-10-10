#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="monit"

cPkgName="$cApp"
cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="2812"
cLog1="/var/log/$cApp.log"

