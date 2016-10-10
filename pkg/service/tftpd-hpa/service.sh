#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


InstWin()
{
  Log "$0->$FUNCNAME"

  FileWim="wimboot-latest.zip"

  ExecM "wget http://git.ipxe.org/releases/wimboot/$FileWim"
  ExecM "mkdir -p $cDirTftp"
  ExecM "unzip -j -d $cDirTftp $FileWim */wimboot"
  ExecM "rm $FileWim"
}


Init()
{
  Log "$0->$FUNCNAME"

  ExecM "mkdir -p $cDirTftp/{pxelinux.cfg,image}"

  ExecM "cp $cDirSysLinux/modules/bios/{ldlinux.c32,libcom32.c32,libgpl.c32,libutil.c32,linux.c32,reboot.c32,vesamenu.c32} $cDirTftp"
  ExecM "cp $cDirSysLinux/memdisk $cDirTftp"

  ExecM "cp $cDirPxeLinux/pxelinux.0 $cDirTftp"

  chgrp -R nobody $TFTP_DIRECTORY
}


InstallEx()
{
  Log "$0->$FUNCNAME"

  Install
  InstWin
}

# ------------------------
clear
case $1 in
    Exec|e)	Exec		$2 ;;
    Init)	$1		$2 ;;
    Install)	InstallEx	$2 ;;
    *)		Test ;;
esac
