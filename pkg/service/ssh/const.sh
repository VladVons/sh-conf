#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="openssh"

cPkgName="openssh-server"
cProcess="ssh"
cService="$gDirD/$cProcess"
cPort="22"
Log="$gFileSysLog"
Man="sshd_config"
