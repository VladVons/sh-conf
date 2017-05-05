#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="openvpn"

cPkgName="$cApp"
cPkgAlso="easy-rsa"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="1194"

Instance="oster-server3"
cLog2="/var/log/${cApp}_${Instance}.log"
cLog1="/var/log/${cApp}_${Instance}-status.log"

cDirRsa="/usr/share/easy-rsa"
