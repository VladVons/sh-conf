#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="iptables-persistent"
cPkgName="$cApp"
cPkgGeoIP="xtables-addons-common libtext-csv-xs-perl module-assistant"

cService="$gDirD/$cApp"
cLog1=$gFileSysLog

p_ssh=22
p_www=80
p_rdp=3389
p_vnc=5900
p_squid_http=3128
p_squid_https=3129


IntNetBase=$(echo $gIntNet | sed -r 's|.0/24||gI')
