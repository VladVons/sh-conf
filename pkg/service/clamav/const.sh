#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="clamav"

cPkgName="$cApp"
cPkgAlso="$cApp-daemon"
cPkgAlsoGui="clamtk"

cProcess="clam"
cService="$gDirD/clamav-freshclam"
cLog1=$gFileSysLog
