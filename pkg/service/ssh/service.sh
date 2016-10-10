#!/bin/bash

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Info()
# ------------------------
{
  Log "$0->$FUNCNAME"

  MultiCall ManPrint "$Man"
}



# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    Info)	$1	$2 ;;
    *)		Test	;;
esac
