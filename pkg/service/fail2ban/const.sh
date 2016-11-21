#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="fail2ban"

cPkgName="$cApp"
cPkgAlso="geoip-bin"

cProcess="$cApp"
cService="$gDirD/$cApp"

cLog1="/var/log/$cApp.log"
cLog_fail2ban="$cLog1"
cLog_freeswitch="/var/log/freeswitch/freeswitch.log"
cLog_ssh="/var/log/auth.log"

cMan="jail.conf"
cBlackList="/etc/fail2ban/ip.blacklist"