#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="lxc-pve"

cPkgName="$cApp"
cPkgDepends="lxc-pve"
cPkgAlso="mc htop iotop iftop screen acpid hddtemp lm-sensors smartmontools apcupsd fail2ban iptables-persistent monit pv tcpdump dnsutils nmap zip git subversion"
cProcess="pvedaemon"
cService="$gDirD/$Process"

LogDir="/var/log/lxc"
cLog1="$LogDir/lxc.log"

cMan="pct.conf,lxc-create"
