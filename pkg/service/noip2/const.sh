#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="noip2"

cPkgAlso="gcc"
cProcess="$cApp"
cService="$gDirD/$cApp"
cLog1="$gFileSysLog"

App="/usr/local/bin/$cApp"
