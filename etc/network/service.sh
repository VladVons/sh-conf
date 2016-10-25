#!/bin/bash
#--- VladVons@gmail.com

cApp="networking"
cService="/etc/init.d/$cApp"

source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  ExecM "ifconfig"
  ExecM "brctl show" "check bridge"

  ip addr show vmbr0
}

# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    *)		TestEx	;;
esac
