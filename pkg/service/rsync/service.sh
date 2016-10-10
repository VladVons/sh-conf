#!/bin/bash
#---VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  echo
  rsync localhost::
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  touch $cLog1
  chmod 600 $cLog1
  chown root:wheel $cLog1
}


Info()
{
  Log "$0->$FUNCNAME"

  MultiCall ManPrint $Man $gDirMan/$cApp
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    Info)	$1	$2 ;;
    *)		TestEx	;;
esac
