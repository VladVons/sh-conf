#!/bin/bash

# ------------------------
# Author: Vladimir Vons
# Organization: oster.com.ua
# eMail: VladVons@gmail.com
# Created: 12.03.2016
# ------------------------

source ./const.sh

#http://nikosapi.org/w/index.php/PXE_boot_Ubuntu_from_a_Debian_server
#http://help.ubuntu.ru/wiki/%D0%B4%D0%B8%D1%81%D1%82%D1%80%D0%B8%D0%B1%D1%83%D1%82%D0%B8%D0%B2_%D0%BD%D0%B0_%D0%B1%D0%B0%D0%B7%D0%B5_ubuntu_%D0%B2%D1%80%D1%83%D1%87%D0%BD%D1%83%D1%8E

DirTftp="conf/$cConf/out/tftp"


Info()
{
  echo
  echo "cDirRoot: $cDirRoot"
  echo "cArch   : $cArch"
  echo "cDistr  : $cDistr"
  echo "DirTftp : $DirTftp"
  read -p "Press enter to continue ..."
}


Chroot()
{
  aFunc=$1;

  CurDir=$(pwd)
  DirMap=${cDirRoot}${CurDir}

  mkdir -p $DirMap
  mount --bind ${CurDir} $DirMap

  chroot $cDirRoot $CurDir/chroot.sh Run $CurDir $aFunc

  umount -l -f $DirMap
}


Init()
{
  Info

  if [ ! -d "$cDirRoot" ]; then
    echo "debootstrap dir: $cDirRoot"
    debootstrap --arch=$cArch $cDistr $cDirRoot
  fi;

  Chroot All
  echo "Dir size: $(du -sh $cDirRoot)"
  echo "Dir files: $(find $cDirRoot -type f | wc -l)"

  mkdir -p $DirTftp
  cp -L $cDirRoot/{initrd.img,vmlinuz} $DirTftp

  #mksquashfs $cDirRoot filesystem.squashfs -e boot

  # ???
  rm $cDirRoot/var/{lock,run}
}


Pkg()
{
  Info
  Chroot Pkg
}


Help()
{
  echo "Ver:     1.02"
  echo "Author:  Vladimir Vons"
  echo "eMail:   VladVons@gmail.com"
  echo "Created: 12.03.2016"
}


clear
Help

case $1 in
    Info)		$1	$2 $3 ;;
    Init)		$1	$2 $3 ;;
    Pkg)		$1	$2 $3 ;;
    Chroot)		$1 	$2 $3 ;;
esac
