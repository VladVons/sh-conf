#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="postfix"

cPkgName="$cApp"
cPkgAlso="mailutils"
#cPkgAlso="libsasl2-modules sasl2-bin mailutils courier-authlib"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="25"
cLog1="/var/log/mail.log"
 