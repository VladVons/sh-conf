#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}
  Log "$0->$FUNCNAME, $cApp, $aAction"

  ConfName="dsl-provider"

  poff $ConfName
  sleep 1

  pon  $ConfName debug
  sleep 1

  Test
}


# ------------------------
clear
case $1 in
    Exec|e)     ExecEx    $2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
