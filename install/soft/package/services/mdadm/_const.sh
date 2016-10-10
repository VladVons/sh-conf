#!/bin/bash

. $DIR_ADMIN/conf/Const.sh

Program="mdadm"

Package="$Program lvm2 parted gdisk"
Process="$Program"
Service="$gDirD/$Program"
Log1=$gFileSysLog

DevMD="/dev/md0"
