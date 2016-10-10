#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="nfs-kernel-server"

cPkgName="$cApp"
cProcess="nfsd"
cService="$gDirD/$cApp"
cLog1=$gFileSysLog
