#!/bin/bash
#VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  NetStat ":$cPort"

  ExecM "ifconfig | grep 'inet '"
  ExecM "ip route"
  ExecM "route -n"

  echo
  ShowFile "$cLog1" ST 15
  #ShowFile "$cLog2" ST 15

  echo
  grep PUSH_REPLY $cLog2 | awk '{ print $2, $3, $4, $7}'
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  touch $cLog1
  chown nobody:nogroup $cLog1

  touch $cLog2
  chown nobody:nogroup $cLog2

  # inside lcx container
  #mkdir /dev/net
  #mknod /dev/net/tun c 10 200
  #chmod 666 /dev/net/tun
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
