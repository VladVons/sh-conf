#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="apt-cacher-ng"

cPkgName="$cApp"
cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="3142|9999"
cLog1="/var/log/$cApp/apt-cacher.err"
cLog2="/var/log/$cApp/apt-cacher.log"
