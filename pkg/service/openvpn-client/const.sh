#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh
source $gDirPkg/service/openvpn/const.sh

Instance="oster-client"
cLog2="/var/log/${cApp}_${Instance}.log"
cLog1="/var/log/${cApp}_${Instance}-status.log"
