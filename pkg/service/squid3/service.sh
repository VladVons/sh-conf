#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test 

  # ShowFile $cLog2 ST 15

  # ExecM "squid3 -v"
  # ExecM "squid3 -k parse"
  # ExecM "du -hs /var/squid/cache" "used disk cache size" 
}


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}
  
  Exec $aAction
  #squid3 -k reconfigure

  TestEx
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #http://itadept.ru/freebsd-squid/

  #mkdir -p "/usr/local/etc/squid/conf"

  #mkdir -p /var/squid/logs
  #chown -R squid:squid /var/squid

  #mkdir -p $gDirData/sarg
  #touch $gDirData/sarg/OverLimit.txt

  #GenKey

  #init cache
  squid3 -z

  # debug mode
  squid3 -N -d 1 -D
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
