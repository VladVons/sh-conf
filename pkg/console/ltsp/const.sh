#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="ltsp-server-standalone"

cPkgName="$cApp"
cPkgAlso="tftpd-hpa isc-dhcp-server"
Service="$gDirD/$Program"
Log1=$gFileSysLog

cMan="ltsp-build-client"