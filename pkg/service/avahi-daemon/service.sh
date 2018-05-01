#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


# plugin
# https://addons.mozilla.org/uk/firefox/addon/live-http-headers/

TestEx()
{
  Test

  nmap -p 80 --open $gIntNet 
  avahi-browse -art
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
