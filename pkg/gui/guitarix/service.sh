#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


InstallEx()
{
  dpkg-reconfigure -p high jackd2

  sudo usermod -a -G audio $USER
  su $USER -c guitarix

  #pulseaudio -k
}


# ------------------------
#clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	InstallEx	$1	$2 ;;
    *)		TestEx	;;
esac
