#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="mpd"

cPkgName="$cApp"
cPkgAlso="mpc alsa-utils alsa-base pulseaudio mpg123"

cProcess="$cApp"
cService="$gDirD/$cApp"
cPort="8000,6600"
cLog1="/var/log/$cApp/$cApp.log"
