#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="smartmontools"

cPkgName="$cApp"
cPkgAlsoGUI="gsmartcontrol"

cProcess="smartd"
cService="$gDirD/$cApp"
cLog1="$gFileSysLog"
DefHDD="/dev/sda"
