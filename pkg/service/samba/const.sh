#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="samba"

cPkgName="$cApp"
cPkgAlso="winbind"

cProcess="smb|nmb|winbindd"
cPort="137|138|139|445"
cService="$gDirD/$cApp"
cLog1="/var/log/$cApp/log.smbd"
Man="smb.conf,limits.conf"
