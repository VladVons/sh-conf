#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="ssmtp"

cPkgName="$cApp"
cPkgAlso="mailutils"

cProcess="$cApp"
cPort="25"
cLog1="$gFileSysLog"
cLog2="/var/log/mail.log"
