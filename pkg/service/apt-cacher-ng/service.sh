#!/bin/bash
#--- VladVons@gmail.com
# https://help.ubuntu.com/community/Apt-Cacher-Server
# http://www.tecmint.com/apt-cache-server-in-ubuntu/

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
{
  Log "$0->$FUNCNAME"

  #/usr/share/apt-cacher/apt-cacher-imcPort.pl -l /var/cache/apt/archives
}


# ------------------------
clear
case $1 in
    Exec|e)     Exec    $2 ;;
    Init)       	$1 $2 ;;
    Install)		$1 $2 ;;
    *)		Test	;;
esac
