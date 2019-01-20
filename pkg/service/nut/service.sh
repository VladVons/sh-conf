#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test 

  # check supported driver
  #http://networkupstools.org/stable-hcl.html


  ExecM "dmesg | grep tty[SU]"
  #ExecM "setserial -g /dev/ttyS[0123]"

  #ExecM "usbconfig"
  ExecM "upsc MyUPS"
  #ExecM "upsdrvctl -D -u root start"
  
  #https://susilon.wordpress.com/2014/08/09/monitoring-a-ups-with-nut-on-debian-or-ubuntu-linux/
  #driver = powercom -u root
  #
  #powercom test
  #/lib/nut/powercom -a MyUPS -u root -DD
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #Var="/var/db/nut"
  #mkdir -p  $Var
  #chown uucp $Var
}


Info()
{
  Log "$0->$FUNCNAME"

  #http://forum.ubuntu.ru/index.php?topic=256787.0

  MultiCall ManPrint $Man $gDirMan/$cApp
  #cat /usr/share/nut/driver.list
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    Info)	$1	$2 ;;
    *)		TestEx	;;
esac
