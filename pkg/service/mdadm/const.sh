#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="mdadm"

cPkgName="$cApp"
cPkgAlso="lvm2 parted gdisk"

cProcess="$cApp"
cService="$gDirD/$cApp"
cLog1=$gFileSysLog

DevMD="/dev/md0"
