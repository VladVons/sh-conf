#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh

Test()
{
  Log "$0->$FUNCNAME"

  pveversion -v
}

# ------------------------
clear
case $1 in
    Test)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
