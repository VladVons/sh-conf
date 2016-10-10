#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="subversion"

cPkgName="$cApp"
cPkgAlso="$cApp-tools libapache2-svn"

cProcess="svn"
cService="$gDirD/$cApp"
cPort="3690"
cLog1="$gFileSysLog"
  