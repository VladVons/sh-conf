#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="transmission-daemon"

cPkgName="$cApp"
cPkgAlso="transmission-cli"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="9091"

cLog1="/var/log/$cApp.log"
cUser="debian-transmission"
cMan="$cApp"

cDirRoot="/var/lib/$cApp"
