#!/bin/bash
#--- VladVons@gmail.com


. $DIR_ADMIN/conf/Utils.sh
. ./_const.sh


SaveToConf()
{
  aMsg="$1";

  echo "$aMsg" >> /etc/mdadm/mdadm.conf
}


Create()
{
  Log "$0->$FUNCNAME"

  ExecM "mdadm --verbose --create $DevMD --level=5 --raid-devices=3 /dev/sd[bcd]"
  ExecM "mkfs.ext4 -O 64bit -L MyLabel $DevMD" 	"format disk larger then 16Tb with 64bit option"
  ExecM "tune2fs -m 0 $DevMD"	"no reserved blocks"

  SaveToConf "$(mdadm --detail --scan)"
  ExecM "update-initramfs -k all -u"

  Info
}


Add()
{
  CheckParam "$0->$FUNCNAME(aDevHDD='$1')" $# 1 1
  aDevHDD=$1;
  Log "$0->$FUNCNAME, $aDevHDD"

  Wait  "Check UPS before adding disk!"

  #ExecM "sfdisk -d /dev/sdb | sfdisk $aDevHDD"	"clone disk structure"
  ExecM "mdadm --verbose --add  $DevMD $aDevHDD"
  ExecM "mdadm --verbose --grow $DevMD --level=5 --raid-devices=4 --backup-file=/mnt/smb/tr24/GrowMD.dat"
  ExecM "watch cat /proc/mdstat"	"watching progress bar for rebuild"
  ExecM "e2fsck -f $DevMD"	"check MD disk"
  ExecM "resize2fs -p $DevMD"	"resize MD disk"

}


Remove()
{
  CheckParam "$0->$FUNCNAME(aDevHDD='$1')" $# 1 1
  aDevHDD=$1;
  Log "$0->$FUNCNAME, $aDevHDD"

  ExecM "mdadm --fail   $DevMD $aDevHDD"
  ExecM "mdadm --remove $DevMD $aDevHDD"
}


ReAttach()
{
  CheckParam "$0->$FUNCNAME(aDevHDD='$1')" $# 1 1
  aDevHDD=$1;
  Log "$0->$FUNCNAME, $aDevHDD"

  Wait  "Check UPS before adding disk!"

  Remove $aDevHDD

  ExecM "mdadm --add $DevMD $aDevHDD"
  ExecM "watch cat /proc/mdstat"
}


Info()
{
  Log "$0->$FUNCNAME"

  ExecM "parted -l"
  ExecM "mdadm --detail $DevMD"
  ExecM "cat /proc/mdstat"
  ExecM "df -h"
}


# ------------------------
clear
case $1 in
    Add)	$1 $2 $3 ;;
    Create)	$1 $2 $3 ;;
    Info)	$1 $2 $3 ;;
    Remove)	$1 $2 $3 ;;
esac
