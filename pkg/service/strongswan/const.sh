#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="strongswan"

cPkgName="$cApp"
cPkgAlso="libstrongswan-extra-plugins strongswan-ikev1 strongswan-ikev2 libcharon-extra-plugins"

cProcess="ipsec"
cService="$gDirD/$cProcess"

cDir="/etc/ipsec.d"

# See also softether
# http://www.softether-download.com/files/softether
