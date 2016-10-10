#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh

ExecEx()
{
  Exec
  #service php5-fpm reload
}

# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
