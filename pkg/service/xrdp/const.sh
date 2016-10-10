#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="xrdp"

cPkgName="$cApp"
cProcess=$cApp
cService="$gDirD/$cApp"
cPort="3350"
cLog1="/var/log/xrdp-sesman.log"
