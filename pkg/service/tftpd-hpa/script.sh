#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


iso_pmagic()
# ------------------------
{
  Log "$0->$FUNCNAME"
  # http://www.gtkdb.de/index_7_2419.html

  DirTftpDst="$cDirTftp/image/pmagic"
  ISO=$(ls -1 $cDirIso/pmagic*.iso)
  echo "ISO: $ISO, DirMnt: $cDirMnt, $cDirTftpDst"

  ExecM "mkdir -p $cDirMnt $DirTftpDst"

  ExecM "mount -o loop $ISO $cDirMnt"
  ExecM "sh $cDirMnt/boot/pxelinux/pm2pxe.sh"
  ExecM "cp pm2pxe/files.cgz $DirTftpDst"
  ExecM "rm -R pm2pxe"

  ExecM "cp $cDirMnt/pmagic/{bzImage,fu.img,initrd.img,m32.img} $DirTftpDst"
  ExecM "umount $cDirMnt"
}


iso_winpe()
{
  Log "$0->$FUNCNAME"
  # https://www.microsoft.com/ru-ru/download/details.aspx?id=5753
  # http://www.ultimatedeployment.org/win7pxelinux1.html
  # http://www.3dnews.ru/626279
  # https://technet.microsoft.com/en-us/library/dd744541(WS.10).aspx

  #ISO="/mnt/hdd/data1/share/temp/Win/KB3AIK_RU.iso"
  ISO="/mnt/hdd/data1/share/public/images/Windows/Win7.iso"

  ExecM "mkdir -p $cDirMnt $DirTftpDst"
  ExecM "mount -o loop $ISO $cDirMnt"
}


clear
# ------------------------
case $1 in
    iso_pmagic)	$1	$2 ;;
    iso_winpe)	$1	$2 ;;
esac
