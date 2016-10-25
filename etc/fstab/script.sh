#!/bin/bash
#--- VladVons@gmail.com

#https://forum.proxmox.com/threads/local-lvm-storage-and-vm-format.27209/page-2

AddNewPartition()
{
  # storage tree
  lsblk

  # text gui partition manager
  cfdisk /dev/sda

  #--- refresh partitins
  #apt-get install parted
  #partprobe

  mkfs -t ext4 /dev/sdX
}


LVM()
{
  apt-get install lvm2

  #--- mount 
  modprobe dm-mod
  #lsblk
  #lvs
  #pvs

  vgscan
  vgchange -ay vgdata

  mkdir -p /mnt/hdd/data2
  mount /dev/vgdata/home /mnt/hdd/data2

  #--- create volume group
  pvscan
  pvdisplay

  lsblk
  vgcreate vgdata /dev/sdaX
  vgdisplay

  #--- create logical volume 'thin'
  pvesm lvmthinscan vgdata
  lvcreate -L 10G -n vol1 vgdata
  lvconvert --type thin-pool vgdata/vol1


  #--- volume group rename
  vgdisplay
  vgrename -v LGE8xa-m4Q8-zFRc-U1df-X2Me-t37c-XIcRbt vgdata2


  #--- create simple volume
  lvcreate -L 10G -n vol2 vgdata
  mkfs -t ext4 /dev/vgdata/vol2


  #--- logical volume rename
  lvrename vgdata vol1 vol3


  #--- logical volume resize
  lvresize --size +4G /dev/vgdata/vol1
  resize2fs /dev/vgdata/vol1


  #--- logical volume remove
  umount /dev/vgdata/vol2
  lvremove /dev/vgdata/vol2


  #--- group volume remove
  vgremove vgdata
  pvremove /dev/sdb1
}


ClearBoot()
{
  aDev="$1"
  Log "$0->$FUNCNAME, $aDev"

  dd if=/dev/zero of=/dev/$aDev count=1
  sync

}