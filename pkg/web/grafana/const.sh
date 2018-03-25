#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="grafana"

cPkgName="$cApp"
cPkgDepends="apt-transport-https"

cProcess="grafana-server"
cService="$gDirD/$cProcess"
cPort="3000"
cLog1="/var/log/grafana/grafana.log"
