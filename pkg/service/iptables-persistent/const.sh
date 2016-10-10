#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="iptables-persistent"
cPkgName="$cApp"
cPkgGeoIP="xtables-addons-common libtext-csv-xs-perl module-assistant"

cService="$gDirD/$cApp"
cLog1=$gFileSysLog

p_rdp=3389
p_squid=3128
p_ssh=22
p_vnc=5900
p_www=80

IntNetBase=$(echo $gIntNet | sed -r 's|.0/24||gI')
