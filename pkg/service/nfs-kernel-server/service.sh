#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh



ExecEx()
{
  ExecM "exportfs -a"

  Exec

  # client side
  # apt-get install nfs-common
  # mount -t nfs 192.168.2.1:/home /mnt/nfs/home
  # mount -t nfs
}

# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
