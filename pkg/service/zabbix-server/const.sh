#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="zabbix-server"

cPkgName="zabbix-frontend-php"
cPkgDepends="zabbix-server-mysql mysql-server apache2 php5 php5-cli php5-common php5-mysql"

cProcess="zabbix_server"
cService="$gDirD/$cApp"
cPort="10051"
cLog1="/var/log/zabbix/zabbix_server.log"
