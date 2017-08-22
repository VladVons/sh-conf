#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Exec()
# ------------------------
{
  aAction=${1:-"restart"}

  #Exec $aAction    

  eval "service $cProcess $aAction"
  sleep 3
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
