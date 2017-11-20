#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="watchdog"

cPkgName="$cApp"
cPkgAlso="chkconfig"

cProcess="$cApp"
cService="$gDirD/$cApp"
