#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  Test

  #ExecM "ifconfig"

  ExecM "ipsec version"
  ExecM "ipsec statusall"

  ExecM "ipsec rereadsecrets" "reload secrets file"
}


Init()
# ------------------------
{
  #https://itldc.com/blog/l2tp-ipsec-vpn-ubuntu-server/

  Log "$0->$FUNCNAME"
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
