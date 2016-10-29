#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  Test

  iscsiadm -m discovery -t st -p 192.168.2.111
  iscsiadm -m node

  iscsiadm -m node --targetname "iqn.2001-04.com.example:storage.lun1" --portal "192.168.2.111:3260" --login
}

# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
