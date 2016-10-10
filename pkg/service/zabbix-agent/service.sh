#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./ppa.sh
source $DIR_ADMIN/conf/script/service.sh



InstallEx()
{
  AddPpa
  Install
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec		$2 ;;
    Install)	InstallEx	$2 ;;
    *)		Test		;;
esac
