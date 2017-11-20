#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
 Test

 dmesg | grep watchdog
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #http://robocraft.ru/blog/3130.html

  modprobe bcm2835_wdt

  chkconfig watchdog on
  service watchdog start

  journalctl | grep dog
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
