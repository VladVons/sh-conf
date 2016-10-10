#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="zabbix-agent"
cPkgName="$cApp"

cProcess="zabbix_agentd"
cService="$gDirD/$cApp"
cPort="10051"
cLog1="/var/log/zabbix/$cProcess.log"
