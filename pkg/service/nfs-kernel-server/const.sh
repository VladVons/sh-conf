#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="nfs-kernel-server"

cPkgName="$cApp"
cPkgAlso="nfs4-acl-tools"
cProcess="nfsd"
cService="$gDirD/$cApp"
cLog1=$gFileSysLog
