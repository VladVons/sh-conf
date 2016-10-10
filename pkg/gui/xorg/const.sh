#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="xserver-xorg"

cPkgName="$cApp-core"
cPkgAlso="$cApp-input-all $cApp-video-all $cApp-video-fbdev xinit"

cProcess="Xorg0"
cLog1="/var/log/Xorg.0.log"
