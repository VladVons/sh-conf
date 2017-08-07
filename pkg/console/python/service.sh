#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test
 
  ExecM "python -V"
}


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Install

  pip install MySQL-python
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx		$2 ;;
    Init)	$1		$2 ;;
    Install)	InstallEx	$1 $2 ;;
    *)		TestEx		;;
esac
