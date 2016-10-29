#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  ExecM "ifconfig $gExtIf"	"External Interface info"
  #ExecM "NetGetExtIP"		"My External IP"
  #ExecM "ping -c 3 $gWorldDNS"	"World root"
}


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}
  Log "$0->$FUNCNAME, $cApp, $aAction"

  pppoe-server -I eth1 -L 192.168.2.111

  TestEx
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
