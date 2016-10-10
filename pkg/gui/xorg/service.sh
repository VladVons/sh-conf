#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/Service.sh


TestEx()
{
 Test

 ExecM "ps -e | grep Xorg --color=auto" "Check if Xserver is running"
 ExecM "pidof X && echo 'X server is running'"
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
