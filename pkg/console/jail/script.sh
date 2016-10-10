#!/bin/bash

# ------------------------
# Author: Vladimir Vons
# Organization: oster.com.ua
# eMail: VladVons@gmail.com
# Created: 21.09.2015
# ------------------------

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


Pattern()
{
  aFile=$1;

  cat ./pattern/$aFile | grep -v "^$\|^#"
}


DirCreateFile()
{
  aFilePath="$1";

  Dir=$(dirname $aFilePath)
  if [ ! -d "$Dir" ]; then
    Log "$0->$FUNCNAME, $Dir"
    mkdir -p "$Dir"
  fi;
}


DirCreate()
{
  aDir="$1";

  if [ ! -d "$aDir" ]; then
      Log "$0->$FUNCNAME, $aDir"
      mkdir -p "$aDir"
  fi;
}


FileDepend()
{
  aFile=$1;

  ldd $aFile | awk '{ print $3 }' | egrep -v ^'\('
}


FileDependCopy()
{
  aFile=$1;

  for i in $(FileDepend $aFile); do
    FileDst=${DirRoot}${i}
    if [ ! -r $FileDst ]; then
      echo "$aFile->$i"

      Dir="$(dirname $FileDst)"
      DirCreate $Dir

      cp --update --verbose $i $Dir
    fi;
  done;
}


DirDepend()
{
  aDir=$1;

  find $aDir -type f | \
  while read File; do
    for i in $(FileDepend $File); do
      echo "$File->$i"
    done;
  done;
}


FileCopy()
{
  aFile=$1; aDepend=$2;
 
  if [ -r $aFile ]; then
    FileDst=${DirRoot}${aFile}
    if [ ! -r $FileDst ]; then
      Log "$0->$FUNCNAME, $FileDst"

      echo
      DirCreateFile $FileDst
      cp --update --verbose $aFile $FileDst
      if [ $aDepend == 1 ]; then
        FileDependCopy $aFile
      fi;
    fi;
  else
    Log "$0->$FUNCNAME, not found: $aFile"
  fi;
}


FilesExe()
{
  cp --parents --update /lib64/ld-linux-x86-64.so.2 $DirRoot

  Pattern FileExe.txt | \
  while read i; do
    FileCopy $i 1
  done;
}


FilesCreate()
{
  Pattern FileCreate.txt | \
  while read i; do
    FileDst=${DirRoot}${i}
    if [ ! -r $FileDst ]; then
      Log "$0->$FUNCNAME, $FileDst"
      DirCreateFile $FileDst
      touch $FileDst
    fi;
  done;
}


FilesCopy()
{
  Pattern FileCopy.txt | \
  while read i; do
    FileCopy $i 0
  done;
}



DirsCreate()
{
  Pattern DirCreate.txt | \
  while read i; do
    DirDst=${DirRoot}${i}
    DirCreate "$DirDst"
  done;
}


DirsCopy()
{
  Pattern DirCopy.txt | \
  while read i; do
    DirDst=${DirRoot}${i}
    DirCreate "$DirDst"
    cp --recursive --update "$i" $(dirname "$DirDst")
  done;
}




PkgsInstall()
{
  Pattern PkgInstall.txt | \
  while read i; do
    Found=$(dpkg -l $i 2>&1 | grep ii | awk '{ print $3 }')
    if [ -z "$Found" ]; then
	Log "$0->$FUNCNAME, $i"
	apt-get install --yes --no-install-recommends $i
    fi;
  done;
}


JUserAdd()
{
  aUser=$1; aPassw=$2;

  Home=${DirRoot}/home/$aUser
  DirCreate $Home
  chown ${aUser}:${aUser} $Home

  UserAddSys $aUser $aPassw $cGroup /bin/bash $Home
}


Init()
{
  DirCreate $DirRoot
  chown root:root $DirRoot
  chmod 755 $DirRoot

  groupadd $cGroup

  mknod -m 666 $DirRoot/dev/null c 1 3

  DirsCreate
  DirsCopy

  FilesCreate
  FilesCopy
  FilesExe

  du -h -s $DirRoot

  #apt-get install syslinux squashfs-tools genisoimage
}


GetDepends()
{
  File="Depends.txt"

  DirDepend /bin > $File
  DirDepend /sbin >> $File
  DirDepend /usr/bin >> $File
  DirDepend /usr/sbin >> $File
}


AsChroot()
{
  #DirCreate $DirTemp
  #cp --update _const.sh $0 $DirTemp
  #cp --update --recursive pattern $DirTemp
  echo "A1"
  ls

  echo "A2"
  cd /tmp
  ls 

  #apt-get update

  #PkgsInstall
  #apt-get clean
  #rm /var/lib/apt/lists/*
}


Chroot()
{
  mount --bind /dev $DirRoot/dev
  #mount --bind /run/resolvconf/resolv.conf $DirRoot/etc/resolv.conf
  #mount --bind /tmp $DirRoot/tmp
  #mount --bind /proc $DirRoot/proc

  #DirCreate $DirTemp
  cp --update _const.sh $0 $DirRoot
  #cp --update --recursive pattern $DirTemp

  chroot $DirRoot "cd /"
  #chroot $DirRoot $0 AsChroot 
  #chroot $DirRoot cd /
 
  #umount $DirRoot/proc
  #umount $DirRoot/tmp
  #umount $DirRoot/etc/resolv.conf
  umount $DirRoot/dev
}


# ------------------------
clear
# ltsp-build-client --arch=i386 --skipimage --chroot=my-i386
# ltsp-update-image --arch=i386
# ltsp-update-kernels

# debootstrap --arch=i386 --download-only --keep-debootstrap-dir  trusty x-i386 
# apt-cache policy mc

case $1 in
    AsChroot)		$1	$2 $3 ;;
    GetDepends)		$1	$2 $3 ;;
    Init)		$1	$2 $3 ;;
    JUserAdd)		$1 	$2 $3 ;;
    Chroot)		$1 	$2 $3 ;;
    PkgsInstall)	$1	$2 $3 ;;
esac
