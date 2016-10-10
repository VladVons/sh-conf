#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh



TestEx()
# ------------------------
{
  Test

  ExecM "ntpq -p"		"peers"
  #ExecM "ntpdate -q localhost"	"sync info"

  #echo
  #MultiCall ShowFile "$cLog2,$Log3" SGT $cProcess 15
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #dpkg-reconfigure tzdata 
  #timedatectl set-timezone Europe/Kiev
  #ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime

  #hwclock --debug
  #hwclock --utc

  # force sync
  ntpdate -v -b in.pool.ntp.org

  touch $cLog1
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)		$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
