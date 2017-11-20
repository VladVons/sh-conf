#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="apache2"

cPkgName="$cApp"
cPkgAlso="apache2-utils libapache2-mod-geoip libapache2-svn libapache2-mod-php libapache2-mod-perl2 libapache2-modsecurity"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="80|443"
cLog1="/var/log/$cApp/error.log"
