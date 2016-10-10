#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  Test

  getent group $cGroup
}

# ------------------------
clear
case $1 in
    Install)	Install	$2 $3 $4;;
    *)		TestEx		;;
esac
