#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Test()
{
  Log "$0->$FUNCNAME"

  pveversion -v
}


Update()
{
  aSrc=$1;
  aSrc="/path/to/proxmox-ve_4.1-2f9650d4-21.iso"

  Log "$0->$FUNCNAME, $aSrc"

  #https://pve.proxmox.com/wiki/Upgrade_from_4.0_to_4.1_using_the_ISO_image

  Dst="/mnt/cdrom"

  mkdir -p $Dst
  mount -o loop $aSrc $Dst

  apt-cdrom --no-auto-detect --cdrom  $Dst --no-mount add
  cat /var/lib/apt/cdroms.list
  cat /etc/apt.sources.list

  apt-get update && apt-get dist-upgrade
}


# ------------------------
clear
case $1 in
    Test)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
