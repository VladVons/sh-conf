#!/bin/bash
#--- VladVons@gmail.com

cApp="networking"
cService="/etc/init.d/$cApp"

source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  ExecM "ifconfig"
}

# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    *)		TestEx	;;
esac
