#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="backuppc"

cPkgName="$cApp"
cPkgAlso="libapache2-mod-perl2 cifs-utils rsync build-essential gcc make"

cProcess="$cApp"
cService="$gDirD/$cApp"
cLog1="/var/lib/$cApp/log/LOG"

DirConf="/etc/$cApp"
User="$cApp"
