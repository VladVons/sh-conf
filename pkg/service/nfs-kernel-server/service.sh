#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  Test

  ExecM "showmount -e localhost"

  # client side
  # apt-get install nfs-common
  # mount -t nfs 192.168.5.11:/home/chroot/lxde-32_xenial_i386 /mnt/nfs
  # mount -t nfs
}

ExecEx()
{
  ExecM "exportfs -ar"

  Exec
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
