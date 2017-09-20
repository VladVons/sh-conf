#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  update-rc.d vbox-startvm defaults
}


# ------------------------
clear
case $1 in
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
