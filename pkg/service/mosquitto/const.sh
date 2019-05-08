#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="mosquitto"

cPkgName="$cApp"

cProcess="$cApp"
cService="$gDirD/$cProcess"
cPort="1883"
cLog1="/var/log/$cApp/$cApp.log"
